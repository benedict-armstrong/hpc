MPI_CC = mpicc
CFLAGS = 

build/hello_mpi: hello_mpi.c
	echo $(origin MPI_CC) 
	$(MPI_CC) $(CFLAGS) $^ -o $@

.PHONY: clean
clean:
	$(MPI_CC) build/hello_mpi
