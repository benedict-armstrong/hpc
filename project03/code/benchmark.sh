#!/bin/bash
#SBATCH --job-name=mini_pde      # Job name
#SBATCH --output=mini_pde.out # Output file
#SBATCH --error=mini_pde.err  # Error file
#SBATCH --ntasks=1               # Number of tasks
#SBATCH --constraint=EPYC_7763   # Select node with CPU
#SBATCH --cpus-per-task=16        # Number of CPUs per task
#SBATCH --mem-per-cpu=1000       # Memory per CPU
#SBATCH --time=01:00:00          # Wall clock time limit

# Load some modules & list loaded modules
module load gcc python
module list

# Compile
mkdir -p build
make clean
make

# Run the program
srun python3 strong_benchmark.py
