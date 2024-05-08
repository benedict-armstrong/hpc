#import "hpclab-template.typ": hpclab-report
#show: doc => hpclab-report(
  project-nr: 5,
  due-date: "Monday 13 May 2024, 23:59 (midnight)",
  student-name: "Benedict Armstrong",
  partner-names: "",
  show_disclaimer: false,
  doc,
)

= Introduction

All benchmarks and programs were run on the *Euler VII — phase 2 cluster* with
*AMD EPYC 7763* cpus.

= Parallel Space Solution of a nonlinear PDE using MPI [in total 60 points]
== Initialize/finalize MPI and welcome message [5 Points]
== Domain decomposition [10 Points]
== Linear algebra kernels [5 Points]
== The diffusion stencil: Ghost cells exchange [10 Points]
== Implement parallel I/O [10 Points]
== Strong scaling [10 Points]
== Weak scaling [10 Points]

== Bonus [20 Points]: Overlapping computation/computation details

= Python for High-Performance Computing [in total 40 points]
== Sum of ranks: MPI collectives [5 Points]

For this task I translated the cpp code from #link(
  "https://github.com/benedict-armstrong/hpc/tree/main/project04/code/ring",
  "project04/ring",
) to python. As outlined in the task description I implemented one version which
communicates using python objects and another version which uses `NumPy` arrays.
To test the code I ran the following commands:

```sh
mpirun -np 8 python3 slow_comm.py | sort > slow_comm.txt
mpirun -np 8 python3 fast_comm.py | sort > fast_comm.txt
```

The respective code and text files with the output can be found in
`code/hpc_python/rank_sum`.

== Ghost cell exchange between neighboring processes [5 Points]

Again i started this task by translating cpp code this time from #link(
  "https://github.com/benedict-armstrong/hpc/tree/main/project04/code/ghost",
  "project04/ghost",
) to python. The implementation of the ghost cell exchange using `NumPy` arrays
was pretty straight forward except for the sending of the first and last
columns. As far as I could tell `mpi4py` doesn't really support sending non
memory contiguous data. To work around this I created a copy of the data I
wanted to send as a contiguous array.

```py
left_s = data[1, 1:-1].copy()
right_s = data[-2, 1:-1].copy()
```

We also need to create a contiguous receiving buffer for the ghost cells.

```py
left_r = np.zeros(SUBDOMAIN, dtype=np.int64)
right_r = np.zeros(SUBDOMAIN, dtype=np.int64)
```

After sending the ghost cells we can receive them and copy them into the correct
position.

```py
data[1:-1, 0] = left_r
data[1:-1, -1] = right_r
```

To test the code I ran the following commands:

```sh
mpirun -np 16 python3 ghost.py
```

Which as expected prints the correct output:

```txt
[[ 9  5  5  5  5  5  5  9]
 [ 8  9  9  9  9  9  9 10]
 [ 8  9  9  9  9  9  9 10]
 [ 8  9  9  9  9  9  9 10]
 [ 8  9  9  9  9  9  9 10]
 [ 8  9  9  9  9  9  9 10]
 [ 8  9  9  9  9  9  9 10]
 [ 9 13 13 13 13 13 13  9]]
```

== A self-scheduling example: Parallel Mandelbrot [30 Points]
