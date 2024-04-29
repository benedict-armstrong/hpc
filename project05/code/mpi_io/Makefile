CXXMPI      = mpicc
CXXFLAGS = -Wall

build/mpi_io: mpi_io.c
	$(CXXMPI) -Wall $< -o $@

.PHONY: clean
clean:
	$(RM) build/mpi_io $(OBJ) output.*
