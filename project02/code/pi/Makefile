<<<<<<< HEAD
CC      = gcc
=======
CC      ?= gcc
>>>>>>> a34d1c96343d732ac645fb133c4a58ae0386ed26
CFLAGS  = -O2 -fopenmp

all: build/pi_serial build/pi_omp_critical build/pi_omp_reduction

build/pi_serial: build/pi_serial.o build/walltime.o
	$(CC) $(CFLAGS) $^ -o $@

build/pi_serial.o: pi_serial.c walltime.h
	$(CC) -c $(CFLAGS) $< -o $@

build/pi_omp_critical: build/pi_omp_critical.o build/walltime.o
	$(CC) $(CFLAGS) $^ -o $@

build/pi_omp_critical.o: pi_omp_critical.c walltime.h
	$(CC) -c $(CFLAGS) $< -o $@

build/pi_omp_reduction: build/pi_omp_reduction.o build/walltime.o
	$(CC) $(CFLAGS) $^ -o $@

build/pi_omp_reduction.o: pi_omp_reduction.c walltime.h
	$(CC) -c $(CFLAGS) $< -o $@

build/walltime.o: walltime.c walltime.h
	$(CC) -c $(CFLAGS) $< -o $@

.PHONY: clean
clean:
	$(RM) build/* *.data
