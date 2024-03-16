CXX    ?= g++
CFLAGS  = -O3 -fopenmp

all: build/hist_seq build/hist_omp

build/hist_seq: build/hist_seq.o build/walltime.o
	$(CXX) $(CFLAGS) $^ -o $@

build/hist_seq.o: hist_seq.cpp walltime.h
	$(CXX) -c $(CFLAGS) $< -o $@

build/hist_omp: build/hist_omp.o build/walltime.o
	$(CXX) $(CFLAGS) $^ -o $@

build/hist_omp.o: hist_omp.cpp walltime.h
	$(CXX) -c $(CFLAGS) $< -o $@

build/walltime.o: walltime.c walltime.h
	$(CXX) -c $(CFLAGS) $< -o $@

.PHONY: clean
clean:
	$(RM) build/* *.data
