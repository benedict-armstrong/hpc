#!/bin/bash
#SBATCH --job-name=matrixmult
#SBATCH --output=matrixmult-%j.out
#SBATCH --error=matrixmult-%j.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --constraint=EPYC_7763
#SBATCH --time=00:20:00

# load some modules & list loaded modules
module load gcc openblas
# module load intel
module list

# set some environment variables
export OMP_NUM_THREADS=1
export MKL_NUM_THREADS=1

# compile
make clean

for BLOCK_SIZE in $(seq 64 8 256); do
    make BLOCK_SIZE=${BLOCK_SIZE} TEST_SMALL=1
    echo "==== benchmark-blocked (BLOCK_SIZE=${BLOCK_SIZE}) ====================="
    # mkdir if not exists
    mkdir -p BLOCKSIZE_RUNS
    ./benchmark-blocked-${BLOCK_SIZE} | tee BLOCKSIZE_RUNS/timing_blocked_${BLOCK_SIZE}_dgemm.data
    echo
    rm -f dgemm-blocked.o
    rm -f benchmark-blocked-${BLOCK_SIZE}
done