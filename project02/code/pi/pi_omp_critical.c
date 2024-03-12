#include "walltime.h"
#include <omp.h>
#include <stdio.h>  /* printf */
#include <stdlib.h> /* atol */

int main(int argc, char *argv[])
{
  long int N = 1000000;
  double time_start, h, sum, pi;

  if (argc > 1)
    N = atol(argv[1]);

  /* Parallelize with OpenMP using the critical directive */
  time_start = walltime();
  h = 1. / N;
  sum = 0.;
#pragma omp parallel
  {
    double sum_private = 0.;
    int nthreads = omp_get_num_threads();
    int tid = omp_get_thread_num();
    int i_beg = tid * N / nthreads;
    int i_end = (tid + 1) * N / nthreads;
    for (int i = i_beg; i < i_end; ++i)
    {
      double x = (i + 0.5) * h;
      sum_private += 4.0 / (1.0 + x * x);
    }

#pragma omp critical
    sum += sum_private;
  }
  pi = sum * h;
  double time = walltime() - time_start;

  printf("pi = \%.15f, N = %9d, time = %.8f secs\n", pi, N, time);

  return 0;
}
