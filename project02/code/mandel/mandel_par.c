#include <stdio.h>
#include <stdlib.h>

#include <sys/time.h>
#include <time.h>
#include <unistd.h>
#include <omp.h>

#include "consts.h"
#include "pngwriter.h"
#include "walltime.h"

int main(int argc, char **argv)
{
       png_data *pPng = png_create(IMAGE_WIDTH, IMAGE_HEIGHT);

       double x, y, x2, y2, cx, cy;

       const double fDeltaX = (MAX_X - MIN_X) / (double)IMAGE_WIDTH;
       const double fDeltaY = (MAX_Y - MIN_Y) / (double)IMAGE_HEIGHT;

       long nTotalIterationsCount = 0;

       long i, j;

       double time_start = walltime();

#pragma omp parallel for shared(pPng) private(i, j, x, y, x2, y2, cx, cy) reduction(+ : nTotalIterationsCount)
       for (j = 0; j < IMAGE_HEIGHT; j++)
       {
              // printf("Thread %d/%d is working on row %ld\n", omp_get_thread_num(), omp_get_num_threads(), j);
              cx = MIN_X;
              cy = MIN_Y + fDeltaY * j;

              for (i = 0; i < IMAGE_WIDTH; i++)
              {
                     x = cx;
                     y = cy;
                     x2 = x * x;
                     y2 = y * y;
                     // compute the orbit z, f(z), f^2(z), f^3(z), ...
                     // count the iterations until the orbit leaves the circle |z|=2.
                     // stop if the number of iterations exceeds the bound MAX_ITERS.
                     int n = 0;
                     // >>>>>>>> CODE IS MISSING

                     for (int k = 0; k < MAX_ITERS; k++)
                     {
                            if (x2 + y2 > 4.0)
                            {
                                   break;
                            }
                            y = 2 * x * y + cy;
                            x = x2 - y2 + cx;
                            x2 = x * x;
                            y2 = y * y;
                            n++;
                     }
                     // <<<<<<<< CODE IS MISSING
                     // n indicates if the point belongs to the mandelbrot set
                     // plot the number of iterations at point (i, j)
                     int c = ((long)n * 255) / MAX_ITERS;
#pragma omp critical
                     {
                            png_plot(pPng, i, j, c, c, c);
                     }

                     nTotalIterationsCount += n;
                     cx += fDeltaX;
              }
       }

       double time_end = walltime();

       // print benchmark data
       printf("Max. iterations:            %d\n", (long)MAX_ITERS);
       printf("Number of threads:          %d\n", omp_get_max_threads());
       printf("Total time:                 %g seconds\n",
              (time_end - time_start));
       printf("Image size:                 %ld x %ld = %ld Pixels\n",
              (long)IMAGE_WIDTH, (long)IMAGE_HEIGHT,
              (long)(IMAGE_WIDTH * IMAGE_HEIGHT));
       printf("Total number of iterations: %ld\n", nTotalIterationsCount);
       printf("Avg. time per pixel:        %g seconds\n",
              (time_end - time_start) / (double)(IMAGE_WIDTH * IMAGE_HEIGHT));
       printf("Avg. time per iteration:    %g seconds\n",
              (time_end - time_start) / (double)nTotalIterationsCount);
       printf("Iterations/second:          %g\n",
              nTotalIterationsCount / (time_end - time_start));
       // assume there are 8 floating point operations per iteration
       printf("MFlop/s:                    %g\n",
              nTotalIterationsCount * 8.0 / (time_end - time_start) * 1.e-6);

       if (argc > 1)
       {

              png_write(pPng, argv[1]);
       }
       else
       {
              png_write(pPng, "images/mandel_par.png");
       }

       return 0;
}
