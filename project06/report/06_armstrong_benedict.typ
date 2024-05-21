#import "hpclab-template.typ": hpclab-report
#show: doc => hpclab-report(
  project-nr: 6,
  due-date: "Monday 27 May 2024, 23:59 (midnight)",
  student-name: "Benedict Armstrong",
  partner-names: "Tristan Gabl",
  show_disclaimer: false,
  doc,
)

= Introduction

All benchmarks and programs were run on the *Euler VII — phase 2 cluster* with
*AMD EPYC 7763* cpus unless explicitly specified otherwise.

= Graph Partitioning with Julia: Load balancing for HPC [50 points]

Apart from the initial setup working with `julia` on euler was straightforward.
The code for all implementations is available in `code/graph_part/`.

== Inertial bisection

== Spectral bisection

// #grid(
//   columns: 2,
//   gutter: 3,
//   [#figure(
//       image("plots/mini_app/strong_scaling.svg"),
//       caption: "Strong scaling MPI",
//     ) <mini_app_strong_mpi>],
//   [#figure(
//       image("plots/mini_app/strong_scaling_omp.svg"),
//       caption: "Strong scaling OpenMP",
//     ) <mini_app_strong_omp>],
//   [#figure(image("plots/mini_app/speedup.svg"), caption: "Speedup MPI") <mini_app_speedup_mpi>],
//   [#figure(image("plots/mini_app/speedup_omp.svg"), caption: "Speedup OpenMP") <mini_app_speedup_omp>],
//)

== Recursive bisection

= HPC software frameworks [50 points]