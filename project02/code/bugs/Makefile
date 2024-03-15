CC     ?= g++
CFLAGS = -O3 -fopenmp

all: build/omp_bug1 build/omp_bug2 build/omp_bug3 build/omp_bug4 build/omp_bug5

build/omp_bug1: omp_bug1.c
	$(CC) $(CFLAGS) $< -o $@

build/omp_bug2: omp_bug2.c
	$(CC) $(CFLAGS) $< -o $@

build/omp_bug3: omp_bug3.c
	$(CC) $(CFLAGS) $< -o $@

build/omp_bug4: omp_bug4.c
	$(CC) $(CFLAGS) $< -o $@

build/omp_bug5: omp_bug5.c
	$(CC) $(CFLAGS) $< -o $@

clean:
	$(RM) build/omp_bug1 build/omp_bug2 build/omp_bug3 build/omp_bug4 build/omp_bug5
