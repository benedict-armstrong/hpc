#!/bin/bash
#SBATCH --job-name=quicksort      # Job name    (default: sbatch)
#SBATCH --output=quicksort.out    # Output file (default: slurm-%j.out)
#SBATCH --error=quicksort.err     # Error file  (default: slurm-%j.out)
#SBATCH --ntasks=1                # Number of tasks
#SBATCH --constraint=EPYC_7763    # Select node with CPU
#SBATCH --cpus-per-task=47         # Number of CPUs per task
#SBATCH --mem-per-cpu=1024        # Memory per CPU
#SBATCH --time=00:05:00           # Wall clock time limit

# Load some modules & list loaded modules
module load gcc python
module list

# Compile
mkdir -p build
make clean
make

# Run
srun python3 benchmark.py --max_threads 47
