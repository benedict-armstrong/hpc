#!/bin/bash
#SBATCH --job-name=mini_pde_weak      # Job name
#SBATCH --output=out/mini_pde_weak.out # Output file
#SBATCH --error=out/mini_pde_weak.err  # Error file
#SBATCH --ntasks=1               # Number of tasks
#SBATCH --constraint=EPYC_7763   # Select node with CPU
#SBATCH --cpus-per-task=64        # Number of CPUs per task
#SBATCH --mem-per-cpu=1000       # Memory per CPU
#SBATCH --time=10:00:00          # Wall clock time limit

# Load some modules & list loaded modules
module load gcc python
module list

# Compile
mkdir -p build
mkdir -p out

make clean
make

# Run the program
srun python3 weak_benchmark.py --sizes 64 128 256 --threads 1 4 16 64 --runs 20
