from mpi4py import MPI
import numpy as np

rank = MPI.COMM_WORLD.Get_rank()
size = MPI.COMM_WORLD.Get_size()

sum = 0

next_rank = (rank + 1) % size
prev_rank = (rank - 1 + size) % size

send_sum = np.array([rank], dtype=np.int64)
recv_sum = np.array([0], dtype=np.int64)

for i in range(size):
    MPI.COMM_WORLD.Send(send_sum, dest=next_rank)
    MPI.COMM_WORLD.Recv(recv_sum, source=prev_rank)

    print(f"{rank} sum: {sum} + {recv_sum} = {sum + recv_sum}")

    sum += recv_sum
    send_sum = recv_sum

if rank == 0:
    print(f"{rank} final sum: {sum}")
