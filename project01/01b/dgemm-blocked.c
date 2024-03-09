const char *dgemm_desc = "Blocked dgemm.";

/* This routine performs a dgemm operation
 *
 *  C := C + A * B
 *
 * where A, B, and C are lda-by-lda matrices stored in column-major format.
 * On exit, A and B maintain their input values.
 */
void square_dgemm(int n, double *A, double *B, double *C) {
  // TODO: Implement the blocking optimization
  //       (The following is a placeholder naive three-loop dgemm)

  // Blocked dgemm
  int block_size = 100;
  for (int i = 0; i < n; i += block_size) {
    for (int j = 0; j < n; j += block_size) {
      for (int k = 0; k < n; k += block_size) {
        // Correct block dimensions if block "goes off edge of" the matrix
        int M = (i + block_size < n) ? block_size : n - i;
        int N = (j + block_size < n) ? block_size : n - j;
        int K = (k + block_size < n) ? block_size : n - k;
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
