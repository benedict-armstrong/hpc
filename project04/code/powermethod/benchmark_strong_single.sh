#!/bin/bash
#SBATCH --job-name=power_strong         # Job name
#SBATCH --output=out/power_strong.out   # Output file
#SBATCH --error=out/power_strong.err    # Error file
#SBATCH --ntasks=64                     # Number of tasks
#SBATCH --nodes=1                       # Number of nodes
#SBATCH --ntasks-per-node=64            # Number of tasks per node
#SBATCH --cpus-per-task=1               # Number of CPUs per task
#SBATCH --mem-per-cpu=1024              # Memory per CPU
#SBATCH --constraint=EPYC_7763          # Select node with CPU
#SBATCH --time=10:00:00                 # Wall clock time limit

# Load some modules & list loaded modules
module load gcc python openmpi
module list

# Compile
mkdir -p build
mkdir -p out

make clean
make

# Run the program
python3 benchmark.py --runs 5 --processes 1 2 4 8 16 32 64 --type strong --base_size 10000 --name single_node
