MPICC      = mpicc
CFLAGS  = -O3 # Useful flags for debgging -Wall -g -fsanitize=address
LDFLAGS = -lm # -fsanitize=address

all: build/powermethod_rows

build/powermethod_rows: build/powermethod_rows.o build/walltime.o
	$(MPICC) $(LDFLAGS) $^ -o $@

build/powermethod_rows.o: powermethod_rows.c
	$(MPICC) -c $(CFLAGS) $< -o $@

build/walltime.o: walltime.c walltime.h
	$(MPICC) -c $(CFLAGS) $< -o $@

.PHONY: clean
clean:
	$(RM) build/*.o build/powermethod_rows
