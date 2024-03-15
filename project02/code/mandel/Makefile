CPATH  			?= /opt/homebrew/include
LIBRARY_PATH 	?= /opt/homebrew/lib
CC      		?= gcc
CFLAGS  		= -O3 -I$(CPATH) -fopenmp
LDFLAGS 		= -O3 -L$(LIBRARY_PATH) -lpng -fopenmp

all: build/mandel_seq build/mandel_par

build/mandel_seq: build/mandel_seq.o build/pngwriter.o build/walltime.o
	$(CC) $(LDFLAGS) $^ -o $@

build/mandel_par: build/mandel_par.o build/pngwriter.o build/walltime.o
	$(CC) $(LDFLAGS) $^ -o $@

build/mandel_seq.o: mandel_seq.c consts.h pngwriter.h walltime.h
	$(CC) -c $(CFLAGS) $< -o $@

build/mandel_par.o: mandel_par.c consts.h pngwriter.h walltime.h
	$(CC) -c $(CFLAGS) $< -o $@

build/pngwriter.o: pngwriter.c pngwriter.h
	$(CC) -c $(CFLAGS) $< -o $@

build/walltime.o: walltime.c walltime.h
	$(CC) -c $(CFLAGS) $< -o $@

.PHONY: clean
clean:
	$(RM) build/*.o build/mandel_seq
