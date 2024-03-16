/* FILE: omp_bug2.c
 * DESCRIPTION:
 *   Another OpenMP program with a bug.
 ******************************************************************************/
#include <omp.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[])
{
  int nthreads, i, tid;
  double total;

  tid = -1;

  printf("Nested parallelism is %s\n",
         omp_get_nested() ? "supported" : "not supported");

  /* Spawn parallel region */
#pragma omp parallel private(tid)
  {
    /* Obtain thread number */
    tid = omp_get_thread_num();
    /* Only master thread does this */
    if (tid == 0)
    {
      nthreads = omp_get_num_threads();
      printf("Number of threads = %d\n", nthreads);
    }
    printf("Thread %d is starting...\n", tid);

#pragma omp barrier

    /* do some work */
    total = 0.0;
#pragma omp for schedule(dynamic, 10) reduction(+ : total)
    for (i = 0; i < 1000000; i++)
    {

      if (tid != omp_get_thread_num())
      {
        printf("Thread %d: tid = %d\n", omp_get_thread_num(), tid);
      }
      total += i * 1.0;
    }

  } /* End of parallel region */

  printf("Thread %d is done! Total= %e\n", tid, total);
}
