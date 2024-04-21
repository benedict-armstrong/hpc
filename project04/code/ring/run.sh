#!/bin/bash
#SBATCH --job-name=mpi_ring       # Job name
#SBATCH --output=out/mpi_ring.out # Output file
#SBATCH --error=out/mpi_ring.err  # Error file
#SBATCH --ntasks=16               # Number of tasks
#SBATCH --constraint=EPYC_7763    # Select node with CPU
#SBATCH --cpus-per-task=1         # Number of CPUs per task
#SBATCH --mem-per-cpu=200         # Memory per CPU
#SBATCH --time=00:20:00           # Wall clock time limit

# Load some modules & list loaded modules
module load gcc openmpi
module list

# Compile
mkdir -p build

make clean
make

# Run the program
mpirun -np 16 ./build/ring_sum
