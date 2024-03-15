CC ?= gcc

all: build/recur_seq build/recur_omp

build/recur_seq: build/recur_seq.o build/walltime.o
	$(CC) -O3 $^ -o $@

build/recur_seq.o: recur_seq.c walltime.h
	$(CC) -c -O3 $< -o $@

build/recur_omp: recur_omp.c build/walltime.o
	$(CC) -O3 -fopenmp $^ -o $@

build/recur_omp.o: recur_omp.c walltime.h
	$(CC) -c -O3 -fopenmp $< -o $@

build/walltime.o: walltime.c walltime.h
	$(CC) -c $< -o $@

clean:
	$(RM) build/*
