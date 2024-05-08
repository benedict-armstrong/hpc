import time
import sys
from typing import List
import numpy as np
from mpi4py import MPI  # MPI_Init and MPI_Finalize automatically called
import matplotlib.pyplot as plt
from mandelbrot_task import *
import matplotlib as mpl
mpl.use('Agg')

# some parameters
MANAGER = 0  # rank of manager
TAG_TASK = 1  # task       message tag
TAG_TASK_DONE = 2  # tasks done message tag
TAG_DONE = 3  # done       message tag


def manager(
    comm: MPI.Intracomm,
    tasks: List[mandelbrot_patch]
):
    """
    The manager.

    Parameters
    ----------
    comm : mpi4py.MPI communicator
        MPI communicator
    tasks : list of objects with a do_task() method perfroming the task
        List of tasks to accomplish

    Returns
    -------
    ... ToDo ...
    """

    TasksDoneByWorker = {}
    ntasks = len(tasks)
    nworkers = comm.Get_size() - 1
    task_index = 0
    tasks_done = 0
    completed_tasks = []

    print(f"Manager starting with {ntasks} tasks and {nworkers} workers")

    # send first batch of tasks to workers
    for worker in range(1, nworkers + 1):
        if task_index < ntasks:
            comm.send(tasks[task_index], dest=worker, tag=TAG_TASK)
            task_index += 1

    # receive results from workers and send new tasks
    while tasks_done < ntasks:
        status = MPI.Status()
        task = comm.recv(source=MPI.ANY_SOURCE, tag=MPI.ANY_TAG, status=status)
        source = status.Get_source()
        tag = status.Get_tag()

        # print(f"Manager received message with tag {tag} from {source}")

        if tag == TAG_TASK_DONE:
            tasks_done += 1
            completed_tasks.append(task)
            if source not in TasksDoneByWorker:
                TasksDoneByWorker[source] = 1
            else:
                TasksDoneByWorker[source] += 1
            if task_index < ntasks:
                comm.send(tasks[task_index], dest=source, tag=TAG_TASK)
                task_index += 1
        else:
            print(
                f"Manager received unexpected message with tag {tag} from {source}")

    # send termination message to workers
    for worker in range(1, nworkers + 1):
        comm.send(None, dest=worker, tag=TAG_DONE)

    return TasksDoneByWorker, completed_tasks


def worker(comm: MPI.Intracomm):
    """
    The worker.

    Parameters
    ----------
    comm : mpi4py.MPI communicator
        MPI communicator
    """

    while True:
        status = MPI.Status()
        mp: mandelbrot_patch = comm.recv(
            source=MANAGER, tag=MPI.ANY_TAG, status=status)
        tag = status.Get_tag()

        # print(f"Worker {comm.Get_rank()} received message with tag {tag}")

        if tag == TAG_TASK:
            # print(f"Worker {comm.Get_rank()} starting task")
            mp.do_work()
            assert mp.work_done, "Worker: Task not done!"
            comm.send(mp, dest=MANAGER, tag=TAG_TASK_DONE)
        elif tag == TAG_DONE:
            print(f"Worker {comm.Get_rank()} done")
            break
        else:
            print(f"Worker received unexpected message with tag {tag}")


def readcmdline(rank):
    """
    Read command line arguments

    Parameters
    ----------
    rank : int
        Rank of calling MPI process

    Returns
    -------
    nx : int
        number of gridpoints in x-direction
    ny : int
        number of gridpoints in y-direction
    ntasks : int
        number of tasks
    """
    # report usage
    if len(sys.argv) != 4:
        if rank == MANAGER:
            print("Usage: manager_worker nx ny ntasks")
            print("  nx     number of gridpoints in x-direction")
            print("  ny     number of gridpoints in y-direction")
            print("  ntasks number of tasks")
        sys.exit()

    # read nx, ny, ntasks
    nx = int(sys.argv[1])
    if nx < 1:
        sys.exit("nx must be a positive integer")
    ny = int(sys.argv[2])
    if ny < 1:
        sys.exit("ny must be a positive integer")
    ntasks = int(sys.argv[3])
    if ntasks < 1:
        sys.exit("ntasks must be a positive integer")

    return nx, ny, ntasks


if __name__ == "__main__":

    # get COMMON WORLD communicator, size & rank
    comm = MPI.COMM_WORLD
    size = comm.Get_size()
    my_rank = comm.Get_rank()

    # report on MPI environment
    if my_rank == MANAGER:
        print(f"MPI initialized with {size:5d} processes")

    # read command line arguments
    nx, ny, ntasks = readcmdline(my_rank)

    # start timer
    timespent = - time.perf_counter()

    # trying out ... YOUR MANAGER-WORKER IMPLEMENTATION HERE ...
    x_min = -2.
    x_max = +1.
    y_min = -1.5
    y_max = +1.5
    M = mandelbrot(x_min, x_max, nx, y_min, y_max, ny, ntasks)
    tasks = M.get_tasks()

    if my_rank == MANAGER:
        TasksDoneByWorker, tasks = manager(comm, tasks)

        m = M.combine_tasks(tasks)
        plt.imshow(m.T, cmap="gray", extent=[x_min, x_max, y_min, y_max])
        plt.savefig("mandelbrot.png")
    else:
        worker(comm)

    # stop timer
    timespent += time.perf_counter()

    # inform that done
    if my_rank == MANAGER:
        print(f"Run took {timespent:f} seconds")
        for i in range(size):
            if i == MANAGER:
                continue
            print(f"Process {i:5d} has done {TasksDoneByWorker[i]:10d} tasks")
        print("Done.")
