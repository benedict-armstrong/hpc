MPICXX      = mpic++
MPICXXFLAGS = -O3

SOURCES = walltime.cpp stats.cpp data.cpp operators.cpp linalg.cpp main.cpp
HEADERS = walltime.h   stats.h   data.h   operators.h   linalg.h
OBJ     = build/walltime.o   build/stats.o   build/data.o   build/operators.o   build/linalg.o   build/main.o

all: build/main

build/walltime.o: walltime.cpp walltime.h
	mkdir -p build
	$(MPICXX) $(MPICXXFLAGS) -c $< -o $@

build/stats.o: stats.cpp stats.h
	$(MPICXX) $(MPICXXFLAGS) -c $< -o $@

build/data.o: data.cpp data.h
	$(MPICXX) $(MPICXXFLAGS) -c $< -o $@

build/operators.o: operators.cpp operators.h
	$(MPICXX) $(MPICXXFLAGS) -c $< -o $@

build/linalg.o: linalg.cpp linalg.h
	$(MPICXX) $(MPICXXFLAGS) -c $< -o $@

build/main.o: main.cpp $(HEADERS)
	$(MPICXX) $(MPICXXFLAGS) -c $< -o $@

build/main: $(OBJ)
	mkdir -p out
	$(MPICXX) $(MPICXXFLAGS) $(OBJ) -o $@

.PHONY: clean
clean:
	$(RM) build/main build/$(OBJ) output.*
