#!/bin/bash
#SBATCH --job-name=quicksort      # Job name    (default: sbatch)
#SBATCH --output=quicksort.out    # Output file (default: slurm-%j.out)
#SBATCH --error=quicksort.err     # Error file  (default: slurm-%j.out)
#SBATCH --ntasks=1                # Number of tasks
#SBATCH --constraint=EPYC_7763    # Select node with CPU
#SBATCH --cpus-per-task=128       # Number of CPUs per task
#SBATCH --mem-per-cpu=1024        # Memory per CPU
#SBATCH --time=00:05:00           # Wall clock time limit

# Load some modules & list loaded modules
module load gcc
module list

# Compile
make clean

# Run
for ((i = 3; i <= 20; i++)); do
  make clean
  make CC=gcc-13 MIN_SIZE=$((2 ** i))
  echo "MIN_SIZE=$((2 ** i))"
  ./build/quicksort
done
