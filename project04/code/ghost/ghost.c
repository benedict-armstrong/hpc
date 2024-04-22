/****************************************************************
 *                                                              *
 * This file has been written as a sample solution to an        *
 * exercise in a course given at the CSCS-USI Summer School     *
 * It is made freely available with the understanding that      *
 * every copy of this file must include this header and that    *
 * CSCS/USI take no responsibility for the use of the enclosed  *
 * teaching material.                                           *
 *                                                              *
 * Purpose: Exchange ghost cell in 2 directions using a topology*
 *                                                              *
 * Contents: C-Source                                           *
 *                                                              *
 ****************************************************************/

/* Use only 16 processes for this exercise
 * Send the ghost cell in two directions: left<->right and top<->bottom
 * ranks are connected in a cyclic manner, for instance, rank 0 and 12 are connected
 *
 * process decomposition on 4*4 grid
 *
 * |-----------|
 * | 0| 1| 2| 3|
 * |-----------|
 * | 4| 5| 6| 7|
 * |-----------|
 * | 8| 9|10|11|
 * |-----------|
 * |12|13|14|15|
 * |-----------|
 *
 * Each process works on a 6*6 (SUBDOMAIN) block of data
 * the D corresponds to data, g corresponds to "ghost cells"
 * xggggggggggx
 * gDDDDDDDDDDg
 * gDDDDDDDDDDg
 * gDDDDDDDDDDg
 * gDDDDDDDDDDg
 * gDDDDDDDDDDg
 * gDDDDDDDDDDg
 * gDDDDDDDDDDg
 * gDDDDDDDDDDg
 * gDDDDDDDDDDg
 * gDDDDDDDDDDg
 * xggggggggggx
 */

#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>

#define SUBDOMAIN 6
#define DOMAINSIZE (SUBDOMAIN + 2)

#define RANK_TO_WATCH 9

int main(int argc, char *argv[])
{
    int rank, size, i, j, dims[2], periods[2], rank_top, rank_bottom, rank_left, rank_right;
    double data[DOMAINSIZE * DOMAINSIZE];
    MPI_Request request;
    MPI_Status status;
    MPI_Comm comm_cart;
    MPI_Datatype data_ghost;

    // Initialize MPI
    MPI_Init(&argc, &argv);

    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    if (size != 16)
    {
        printf("please run this with 16 processors\n");
        MPI_Finalize();
        exit(1);
    }

    // initialize the domain
    for (i = 0; i < DOMAINSIZE * DOMAINSIZE; i++)
    {
        data[i] = rank;
    }

    // TODO: set the dimensions of the processor grid and periodic boundaries in both dimensions
    dims[0] = 4;
    dims[1] = 4;
    periods[0] = 1;
    periods[1] = 1;

    // TODO: Create a Cartesian communicator (4*4) with periodic boundaries (we do not allow
    // the reordering of ranks) and use it to find your neighboring
    // ranks in all dimensions in a cyclic manner.
    MPI_Cart_create(MPI_COMM_WORLD, 2, dims, periods, 0, &comm_cart);

    // TODO: find your top/bottom/left/right neighbor using the new communicator, see MPI_Cart_shift()
    // int rank_top, rank_bottom;
    // int rank_left, rank_right;
    MPI_Cart_shift(comm_cart, 1, 1, &rank_left, &rank_right);
    MPI_Cart_shift(comm_cart, 0, 1, &rank_top, &rank_bottom);

    // BONUS: diagonal neighbors
    int rank_left_top, rank_right_top, rank_left_bottom, rank_right_bottom;
    int coords[2];
    MPI_Cart_coords(comm_cart, rank, 2, coords);

    MPI_Cart_rank(
        comm_cart,
        (int[]){(coords[0] - 1 + dims[0]) % dims[0], (coords[1] - 1 + dims[1]) % dims[1]},
        &rank_left_top);

    MPI_Cart_rank(
        comm_cart,
        (int[]){(coords[0] - 1 + dims[0]) % dims[0], (coords[1] + 1) % dims[1]},
        &rank_right_top);

    MPI_Cart_rank(
        comm_cart,
        (int[]){(coords[0] + 1) % dims[0], (coords[1] - 1 + dims[1]) % dims[1]},
        &rank_left_bottom);

    MPI_Cart_rank(
        comm_cart,
        (int[]){(coords[0] + 1) % dims[0], (coords[1] + 1) % dims[1]},
        &rank_right_bottom);

    if (rank == RANK_TO_WATCH)
    {
        printf("Neighbors of rank %d\n", rank);
        printf("+-----------+\n");
        printf("| %2.d| %2.d| %2.d|\n", rank_left_top, rank_top, rank_right_top);
        printf("|-----------|\n");
        printf("| %2.d| %2.d| %2.d|\n", rank_left, rank, rank_right);
        printf("|-----------|\n");
        printf("| %2.d| %2.d| %2.d|\n", rank_left_bottom, rank_bottom, rank_right_bottom);
        printf("+-----------+\n");
    }

    //  TODO: create derived datatype data_ghost, create a datatype for sending the column, see MPI_Type_vector() and MPI_Type_commit()
    // data_ghost
    MPI_Type_vector(SUBDOMAIN, 1, DOMAINSIZE, MPI_DOUBLE, &data_ghost);
    MPI_Type_commit(&data_ghost);

    //  TODO: ghost cell exchange with the neighbouring cells in all directions
    //  use MPI_Irecv(), MPI_Send(), MPI_Wait() or other viable alternatives

    //  to the top
    int top_start = DOMAINSIZE + 1;
    MPI_Isend(&data[top_start], SUBDOMAIN, MPI_DOUBLE, rank_top, 0, comm_cart, &request);
    MPI_Irecv(&data[1], SUBDOMAIN, MPI_DOUBLE, rank_top, 0, comm_cart, &request);

    //  to the bottom
    int bottom_start = DOMAINSIZE * (DOMAINSIZE - 2) + 1;
    MPI_Isend(&data[bottom_start], SUBDOMAIN, MPI_DOUBLE, rank_bottom, 0, comm_cart, &request);
    MPI_Irecv(&data[bottom_start + DOMAINSIZE], SUBDOMAIN, MPI_DOUBLE, rank_bottom, 0, comm_cart, &request);

    //  to the left
    int left_start = DOMAINSIZE + 1;
    MPI_Isend(&data[left_start], 1, data_ghost, rank_left, 0, comm_cart, &request);
    MPI_Irecv(&data[left_start - 1], 1, data_ghost, rank_left, 0, comm_cart, &request);

    //  to the right
    int right_start = 2 * DOMAINSIZE - 2;
    MPI_Isend(&data[right_start], 1, data_ghost, rank_right, 0, comm_cart, &request);
    MPI_Irecv(&data[right_start + 1], 1, data_ghost, rank_right, 0, comm_cart, &request);

    // diagonal neighbors
    // Send all non blocking
    MPI_Isend(&data[top_start], 1, MPI_DOUBLE, rank_left_top, 0, comm_cart, &request);
    MPI_Isend(&data[top_start + SUBDOMAIN - 1], 1, MPI_DOUBLE, rank_right_top, 0, comm_cart, &request);
    MPI_Isend(&data[bottom_start], 1, MPI_DOUBLE, rank_left_bottom, 0, comm_cart, &request);
    MPI_Isend(&data[bottom_start + SUBDOMAIN - 1], 1, MPI_DOUBLE, rank_right_bottom, 0, comm_cart, &request);

    // Receive all non blocking
    MPI_Irecv(&data[0], 1, MPI_DOUBLE, rank_left_top, 0, comm_cart, &request);
    MPI_Irecv(&data[DOMAINSIZE - 1], 1, MPI_DOUBLE, rank_right_top, 0, comm_cart, &request);
    MPI_Irecv(&data[DOMAINSIZE * (DOMAINSIZE - 1)], 1, MPI_DOUBLE, rank_left_bottom, 0, comm_cart, &request);
    MPI_Irecv(&data[DOMAINSIZE * DOMAINSIZE - 1], 1, MPI_DOUBLE, rank_right_bottom, 0, comm_cart, &request);

    //  wait for all communication to finish
    MPI_Wait(&request, &status);

    MPI_Barrier(comm_cart);

    if (rank == RANK_TO_WATCH)
    {
        printf("data of rank %d after communication\n", rank);
        for (j = 0; j < DOMAINSIZE; j++)
        {
            for (i = 0; i < DOMAINSIZE; i++)
            {
                printf("%2.f ", data[i + j * DOMAINSIZE]);
                // printf("%4.1f ", data[i + j * DOMAINSIZE]);
            }
            printf("\n");
        }
    }

    // Free MPI resources (e.g., types and communicators)
    // TODO
    MPI_Type_free(&data_ghost);
    MPI_Comm_free(&comm_cart);

    // Finalize MPI
    MPI_Finalize();

    return 0;
}
