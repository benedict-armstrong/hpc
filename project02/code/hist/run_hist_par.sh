#!/bin/bash
#SBATCH --job-name=hist_seq      # Job name
#SBATCH --output=hist_seq-%j.out # Output file
#SBATCH --error=hist_seq-%j.err  # Error file
#SBATCH --ntasks=1               # Number of tasks
#SBATCH --constraint=EPYC_7763   # Select node with CPU
#SBATCH --cpus-per-task=128        # Number of CPUs per task
#SBATCH --mem-per-cpu=1024       # Memory per CPU
#SBATCH --time=00:05:00          # Wall clock time limit

# Load some modules & list loaded modules
module load gcc
module list

# Compile
make clean
make

# Run the program for OMP_NUM_THREADS equal to 1, 2, 4, 8, ..., 64
for ((i = 0; i <= 6; i++)); do
    OMP_NUM_THREADS=$((2 ** i))
    echo "Running with OMP_NUM_THREADS=$OMP_NUM_THREADS"
    export OMP_NUM_THREADS
    ./hist_omp
done
