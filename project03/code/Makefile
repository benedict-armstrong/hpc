CXX     ?= g++
CXXFLAGS = -O3 -fopenmp

SOURCES = walltime.cpp stats.cpp data.cpp operators.cpp linalg.cpp main.cpp
HEADERS = walltime.h   stats.h   data.h   operators.h   linalg.h
OBJ     = build/walltime.o   build/stats.o   build/data.o   build/operators.o   build/linalg.o   build/main.o

all: build/main

build/walltime.o:walltime.cpp walltime.h
	$(CXX) $(CXXFLAGS) -c $< -o $@

build/stats.o: stats.cpp stats.h
	$(CXX) $(CXXFLAGS) -c $< -o $@

build/data.o: data.cpp data.h
	$(CXX) $(CXXFLAGS) -c $< -o $@

build/operators.o: operators.cpp operators.h
	$(CXX) $(CXXFLAGS) -c $< -o $@

build/linalg.o: linalg.cpp linalg.h
	$(CXX) $(CXXFLAGS) -c $< -o $@

build/main.o: main.cpp $(HEADERS)
	$(CXX) $(CXXFLAGS) -c $< -o $@

build/main: $(OBJ)
	$(CXX) $(CXXFLAGS) $(OBJ) -o $@

.PHONY: clean
clean:
	$(RM) $(OBJ) output.* build/main