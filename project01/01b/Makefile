# Some possible configs ########################################################

# Euler GCC config (module load gcc)
CC = gcc                         # compiler (& linker)
OPT = -O3 -DBLOCK_SIZE=$(BLOCK_SIZE) -DTEST_SMALL=${TEST_SMALL}  # optimization flags (you may add more)
CFLAGS = -Wall -std=gnu99 $(OPT) # standard compiler flags
LDLIBS = -L${OPENBLAS_ROOT} \
		 -lopenblas              # linker options


# Euler INTEL config (module load intel)
# CC = icx                           # compiler (& linker)
# OPT = -O3 -march=core-avx2         # optimization flags (you may add more)
# CFLAGS = -Wall -std=gnu99 $(OPT)   # standard compiler flags
# See the Intel oneAPI Math Kernel Library Link Line Advisor
# https://www.intel.com/content/www/us/en/developer/tools/oneapi/onemkl-link-line-advisor.html#gs.5jekhw
# CFLAGS += -I"${MKLROOT}/include"  # more header files
# LDLIBS = -L${MKLROOT}/lib/intel64 \
#          -lmkl_intel_lp64         \
#          -lmkl_sequential         \
#          -lmkl_core               \
#          -lpthread -lm -ldl       # linker options

################################################################################

targets = benchmark-naive benchmark-blocked-$(BLOCK_SIZE) benchmark-blas
objects = benchmark.o dgemm-naive.o dgemm-blocked.o dgemm-blas.o
results = timing_basic_dgemm.data   \
          timing_blas_dgemm.data    \
          timing_blocked_$(BLOCK_SIZE)_dgemm.data \
          timing.pdf

.PHONY: default
default: all

.PHONY: all
all: $(targets)

benchmark-naive: benchmark.o dgemm-naive.o 
	$(CC) -o $@ $^ $(LDLIBS)
benchmark-blocked-$(BLOCK_SIZE): benchmark.o dgemm-blocked.o
	$(CC) -o $@ $^ $(LDLIBS)
benchmark-blas: benchmark.o dgemm-blas.o
	$(CC) -o $@ $^ $(LDLIBS)

%.o: %.c
	$(CC) -c $(CFLAGS) $<

.PHONY: clean
clean:
	$(RM) $(targets) benchmark-blocked-*  $(objects)

.PHONY: cleanall
cleanall: clean
	$(RM) $(results)
