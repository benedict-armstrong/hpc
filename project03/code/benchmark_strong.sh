#!/bin/bash
#SBATCH --job-name=mini_pde_strong      # Job name
#SBATCH --output=out/mini_pde_strong.out # Output file
#SBATCH --error=out/mini_pde_strong.err  # Error file
#SBATCH --ntasks=1               # Number of tasks
#SBATCH --constraint=EPYC_7763   # Select node with CPU
#SBATCH --cpus-per-task=16        # Number of CPUs per task
#SBATCH --mem-per-cpu=1000       # Memory per CPU
#SBATCH --time=02:00:00          # Wall clock time limit

# Load some modules & list loaded modules
module load gcc python
module list

# Compile
mkdir -p build
mkdir -p out

make clean
make

# Run the program
srun python3 strong_benchmark.py --sizes 64 128 256 512 1024 --threads 1 2 4 8 16 --runs 20
