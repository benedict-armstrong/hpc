MPI_CC     = mpicc
CFLAGS =

build/ring_sum: ring_sum.c
	$(MPI_CC) $(CFLAGS) $^ -o $@

.PHONY: clean
clean:
	$(RM) build/ring_sum
