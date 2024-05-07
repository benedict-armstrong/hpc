from mpi4py import MPI
import numpy as np

SUBDOMAIN = 6
DOMAIN_SIZE = SUBDOMAIN + 2

RANK_TO_WATCH = 9

rank = MPI.COMM_WORLD.Get_rank()
size = MPI.COMM_WORLD.Get_size()


if size != 16:
    raise ValueError("This script is intended to be run with 16 MPI processes")

data = np.ones((DOMAIN_SIZE, DOMAIN_SIZE), dtype=np.int64) * rank

dims = [4, 4]
periods = [True, True]

comm = MPI.COMM_WORLD.Create_cart(dims, periods, reorder=True)

coords = comm.Get_coords(rank)

top, bottom = comm.Shift(0, 1)
left, right = comm.Shift(1, 1)

if rank == RANK_TO_WATCH:
    print(
        f"""
        Neighbours of rank {rank}:
        +{11*'-'}+
        |{'-':^3}|{top:^3}|{'-':^3}|
        +{11*'-'}+
        |{left:^3}|{rank:^3}|{right:^3}|
        +{11*'-'}+
        |{'-':^3}|{bottom:^3}|{'-':^3}|
        +{11*'-'}+
        """
    )


left_s = data[1, 1:-1].copy()
right_s = data[-2, 1:-1].copy()


left_r = np.zeros(SUBDOMAIN, dtype=np.int64)
right_r = np.zeros(SUBDOMAIN, dtype=np.int64)

reqs = [
    comm.Isend(data[1, 1:-1], dest=top),
    comm.Isend(data[-2, 1:-1], dest=bottom),
    comm.Isend(left_s, dest=left),
    comm.Isend(right_s, dest=right),
    comm.Irecv(data[0, 1:-1], source=top),
    comm.Irecv(data[-1, 1:-1], source=bottom),
    comm.Irecv(left_r, source=left),
    comm.Irecv(right_r, source=right),
]


MPI.Request.Waitall(reqs)
comm.Barrier()

data[1:-1, 0] = left_r
data[1:-1, -1] = right_r

if rank == RANK_TO_WATCH:
    print(data)
