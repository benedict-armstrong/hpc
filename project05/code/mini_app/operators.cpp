//******************************************
// operators.cpp
// based on min-app code written by Oliver Fuhrer, MeteoSwiss
// modified by Ben Cumming, CSCS
// *****************************************

// Description: Contains simple operators which can be used on 2/3d-meshes

#include "data.h"
#include "operators.h"
#include "stats.h"

namespace operators
{

    // compute the diffusion-reaction stencils
    // s_old is the population concentration at time step k-1, s_new at k,
    // and f is the residual (see Eq. (7) in Project 3).
    void diffusion(data::Field const &s_old, data::Field const &s_new,
                   data::Field &f)
    {
        using data::domain;
        using data::options;

        using data::bndE;
        using data::bndN;
        using data::bndS;
        using data::bndW;

        using data::buffE;
        using data::buffN;
        using data::buffS;
        using data::buffW;

        double alpha = options.alpha;
        double beta = options.beta;

        int nx = domain.nx;
        int ny = domain.ny;
        int iend = nx - 1;
        int jend = ny - 1;

        // TODO: exchange the ghost cells using non-blocking point-to-point
        //       communication

        // copy the boundary values into the buffers
        for (int j = 1; j < jend; j++)
        {
            buffN[j - 1] = s_new(iend, j);
            buffS[j - 1] = s_new(0, j);
        }

        for (int i = 1; i < iend; i++)
        {
            buffE[i - 1] = s_new(i, jend);
            buffW[i - 1] = s_new(i, 0);
        }

        // debug
        std::cout << "rank: " << domain.rank << std::endl;

        // create MPI_Request objects for the non-blocking communication
        MPI_Request reqs[8];

        // send buffers to neighbours
        MPI_Isend(&buffN, ny, MPI_DOUBLE, domain.neighbour_north, 0, MPI_COMM_WORLD, &reqs[0]);
        MPI_Isend(&buffS, ny, MPI_DOUBLE, domain.neighbour_south, 0, MPI_COMM_WORLD, &reqs[1]);
        MPI_Isend(&buffE, nx, MPI_DOUBLE, domain.neighbour_east, 0, MPI_COMM_WORLD, &reqs[2]);
        MPI_Isend(&buffW, nx, MPI_DOUBLE, domain.neighbour_west, 0, MPI_COMM_WORLD, &reqs[3]);

        // the interior grid points
        for (int j = 1; j < jend; j++)
        {
            for (int i = 1; i < iend; i++)
            {
                f(i, j) = -(4. + alpha) * s_new(i, j)         // central point
                          + s_new(i - 1, j) + s_new(i + 1, j) // east and west
                          + s_new(i, j - 1) + s_new(i, j + 1) // north and south
                          + alpha * s_old(i, j) + beta * s_new(i, j) * (1.0 - s_new(i, j));
            }
        }

        // east boundary
        {
            int i = nx - 1;
            for (int j = 1; j < jend; j++)
            {
                f(i, j) = -(4. + alpha) * s_new(i, j) + s_new(i - 1, j) + bndE[j] + s_new(i, j - 1) + s_new(i, j + 1) + alpha * s_old(i, j) + beta * s_new(i, j) * (1.0 - s_new(i, j));
            }
        }

        // west boundary
        {
            int i = 0;
            for (int j = 1; j < jend; j++)
            {
                f(i, j) = -(4. + alpha) * s_new(i, j) + bndW[j] + s_new(i + 1, j) + s_new(i, j - 1) + s_new(i, j + 1) + alpha * s_old(i, j) + beta * s_new(i, j) * (1.0 - s_new(i, j));
            }
        }

        // north boundary (plus NE and NW corners)
        {
            int j = ny - 1;

            {
                int i = 0; // NW corner
                f(i, j) = -(4. + alpha) * s_new(i, j) + bndW[j] + s_new(i + 1, j) + s_new(i, j - 1) + bndN[i] + alpha * s_old(i, j) + beta * s_new(i, j) * (1.0 - s_new(i, j));
            }

            // north boundary
            for (int i = 1; i < iend; i++)
            {
                f(i, j) = -(4. + alpha) * s_new(i, j) + s_new(i - 1, j) + s_new(i + 1, j) + s_new(i, j - 1) + bndN[i] + alpha * s_old(i, j) + beta * s_new(i, j) * (1.0 - s_new(i, j));
            }

            {
                int i = nx - 1; // NE corner
                f(i, j) = -(4. + alpha) * s_new(i, j) + s_new(i - 1, j) + bndE[j] + s_new(i, j - 1) + bndN[i] + alpha * s_old(i, j) + beta * s_new(i, j) * (1.0 - s_new(i, j));
            }
        }

        // south boundary (plus SW and SE corners)
        {
            int j = 0;
            {
                int i = 0; // SW corner
                f(i, j) = -(4. + alpha) * s_new(i, j) + bndW[j] + s_new(i + 1, j) + bndS[i] + s_new(i, j + 1) + alpha * s_old(i, j) + beta * s_new(i, j) * (1.0 - s_new(i, j));
            }

            // south boundary
            for (int i = 1; i < iend; i++)
            {
                f(i, j) = -(4. + alpha) * s_new(i, j) + s_new(i - 1, j) + s_new(i + 1, j) + bndS[i] + s_new(i, j + 1) + alpha * s_old(i, j) + beta * s_new(i, j) * (1.0 - s_new(i, j));
            }

            {
                int i = nx - 1; // SE corner
                f(i, j) = -(4. + alpha) * s_new(i, j) + s_new(i - 1, j) + bndE[j] + bndS[i] + s_new(i, j + 1) + alpha * s_old(i, j) + beta * s_new(i, j) * (1.0 - s_new(i, j));
            }
        }

        // Accumulate the flop counts
        // 8 ops total per point
        stats::flops_diff += 12 * (nx - 2) * (ny - 2) // interior points
                             + 11 * (nx - 2 + ny - 2) // NESW boundary points
                             + 11 * 4;                // corner points

        // receive buffers into bndX from neighbours
        MPI_Irecv(&bndN, ny, MPI_DOUBLE, domain.neighbour_north, 0, MPI_COMM_WORLD, &reqs[4]);
        MPI_Irecv(&bndS, ny, MPI_DOUBLE, domain.neighbour_south, 0, MPI_COMM_WORLD, &reqs[5]);
        MPI_Irecv(&bndE, nx, MPI_DOUBLE, domain.neighbour_east, 0, MPI_COMM_WORLD, &reqs[6]);
        MPI_Irecv(&bndW, nx, MPI_DOUBLE, domain.neighbour_west, 0, MPI_COMM_WORLD, &reqs[7]);

        // wait for all non-blocking communication to complete
        MPI_Waitall(8, reqs, MPI_STATUSES_IGNORE);
    }

}
