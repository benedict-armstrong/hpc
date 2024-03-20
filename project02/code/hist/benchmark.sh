#!/bin/bash
#SBATCH --job-name=hist_par      # Job name
#SBATCH --output=hist_par.out # Output file
#SBATCH --error=hist_par.err  # Error file
#SBATCH --ntasks=1               # Number of tasks
#SBATCH --constraint=EPYC_7763   # Select node with CPU
#SBATCH --cpus-per-task=42        # Number of CPUs per task
#SBATCH --mem-per-cpu=1000       # Memory per CPU
#SBATCH --time=00:20:00          # Wall clock time limit

# Load some modules & list loaded modules
module load gcc python
module list

# Compile
mkdir -p build
make clean
make

# Run the program
srun python3 benchmark.py --max_threads 42
