from mpi4py import MPI

comm = MPI.COMM_WORLD
rank = comm.Get_rank()
size = comm.Get_size()

sum = 0

next_rank = (rank + 1) % size
prev_rank = (rank - 1 + size) % size

send_sum = rank
recv_sum = 0

for i in range(size):
    comm.send(send_sum, dest=next_rank)
    recv_sum = comm.recv(source=prev_rank)

    print(f"{rank} sum: {sum} + {recv_sum} = {sum + recv_sum}")

    sum += recv_sum
    send_sum = recv_sum

if rank == 0:
    print(f"{rank} final sum: {sum}")
