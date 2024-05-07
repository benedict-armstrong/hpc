from mpi4py import MPI

rank = MPI.COMM_WORLD.Get_rank()
size = MPI.COMM_WORLD.Get_size()

sum = 0

next_rank = (rank + 1) % size
prev_rank = (rank - 1 + size) % size

send_sum = rank
recv_sum = 0

for i in range(size):
    MPI.COMM_WORLD.send(send_sum, dest=next_rank)
    recv_sum = MPI.COMM_WORLD.recv(source=prev_rank)

    print(f"{rank} sum: {sum} + {recv_sum} = {sum + recv_sum}")

    sum += recv_sum
    send_sum = recv_sum

if rank == 0:
    print(f"{rank} final sum: {sum}")
