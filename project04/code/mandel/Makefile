MPICC = mpicc
CFLAGS = -O3 -lpng
INCLUDES = 

all: build/mandel_mpi

build/mandel_mpi:  mandel_mpi.c pngwriter.c
	$(MPICC) $^ $(CFLAGS) $(INCLUDES) -o $@

clean:
	rm -f build/mandel_mpi

