#include <mpi.h> // MPI
#include <stdio.h>

int main(int argc, char *argv[])
{

  // Initialize MPI, get size and rank
  int size, rank;
  MPI_Init(&argc, &argv);
  MPI_Comm_size(MPI_COMM_WORLD, &size);
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);

  // IMPLEMENT: Ring sum algorithm
  int sum = 0; // initialize sum
  printf("%i Init \n", rank);

  int next_rank = (rank + 1) % size;
  int prev_rank = (rank - 1 + size) % size;

  int recv_sum;
  int send_sum = rank;

  for (int i = 0; i < size; i++)
  {
    MPI_Send(&send_sum, 1, MPI_INT, next_rank, 0, MPI_COMM_WORLD);
    MPI_Recv(&recv_sum, 1, MPI_INT, prev_rank, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);

    printf("%i sum: %i + %i = %i \n", rank, sum, recv_sum, sum + recv_sum);

    sum += recv_sum;
    send_sum = recv_sum;
  }

  // Finalize MPI
  MPI_Finalize();

  return 0;
}
