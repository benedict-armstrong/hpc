const char *dgemm_desc = "Blocked dgemm.";

#ifndef BLOCK_SIZE
#define BLOCK_SIZE 32
#endif

/* This routine performs a dgemm operation
 *
 *  C := C + A * B
 *
 * where A, B, and C are lda-by-lda matrices stored in column-major format.
 * On exit, A and B maintain their input values.
 */
void square_dgemm(int n, double *A, double *B, double *C) {

  for (int i = 0; i < n; i += BLOCK_SIZE) {
    for (int j = 0; j < n; j += BLOCK_SIZE) {
      for (int k = 0; k < n; k += BLOCK_SIZE) {
        // Correct block dimensions if block "goes off edge of" the matrix
        int M = (i + BLOCK_SIZE < n) ? BLOCK_SIZE : n - i;
        int N = (j + BLOCK_SIZE < n) ? BLOCK_SIZE : n - j;
        int K = (k + BLOCK_SIZE < n) ? BLOCK_SIZE : n - k;
        // Perform individual block dgemm
        for (int i2 = 0; i2 < M; ++i2) {
          for (int j2 = 0; j2 < N; ++j2) {
            for (int k2 = 0; k2 < K; ++k2) {
              C[(i + i2) + (j + j2) * n] +=
                  A[(i + i2) + (k + k2) * n] * B[(k + k2) + (j + j2) * n];
            }
          }
        }
      }
    }
  }
}
