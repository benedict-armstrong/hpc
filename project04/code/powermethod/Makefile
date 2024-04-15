CC      = mpicc
CFLAGS  = -O3 # Useful flags for debgging -Wall -g -fsanitize=address
LDFLAGS = -lm # -fsanitize=address

all: build/powermethod_rows

build/powermethod_rows: build/powermethod_rows.o build/walltime.o
	$(CC) $(LDFLAGS) $^ -o $@

build/powermethod_rows.o: powermethod_rows.c
	$(CC) -c $(CFLAGS) $< -o $@

build/walltime.o: walltime.c walltime.h
	$(CC) -c $(CFLAGS) $< -o $@

.PHONY: clean
clean:
	$(RM) build/*.o build/powermethod_rows
