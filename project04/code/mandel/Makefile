CC = mpicc
CFLAGS = -O3 -lpng

all: build/mandel_mpi

build/mandel_mpi:  mandel_mpi.c pngwriter.c
	$(CC) $^ $(CFLAGS) -o $@

clean:
	rm -f build/mandel_mpi

