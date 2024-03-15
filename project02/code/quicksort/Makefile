CC     ?= gcc-13
MIN_SIZE ?= 100
CFLAGS = -O3 -fopenmp -DMIN_SIZE=$(MIN_SIZE)

all: build/quicksort

build/quicksort: build/quicksort.o build/walltime.o
	$(CC) $(CFLAGS) $^ -o $@

build/quicksort.o: quicksort.c walltime.h
	$(CC) -c $(CFLAGS) $< -o $@

build/walltime.o: walltime.c walltime.h
	$(CC) -c $(CFLAGS) $< -o $@

.PHONY: clean
clean:
	$(RM) build/*
