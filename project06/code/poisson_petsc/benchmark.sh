#!/bin/bash
#SBATCH --job-name=poisson_py                            # Job name    (default: sbatch)
#SBATCH --output=out/poisson_py.out                      # Output file (default: slurm-%j.out)
#SBATCH --error=out/poisson_py.err                       # Error file  (default: slurm-%j.out)
#SBATCH --constraint=EPYC_7763                            # Select node with CPU
#SBATCH --mem-per-cpu=8G                                  # Memory per CPU
#SBATCH --time=1:00:00                                   # Wall clock time limit
#SBATCH --mail-user=benedict.armstrong@inf.ethz.ch
#SBATCH --mail-type=END

# Load some modules & list loaded modules
module load stack/2024-06 gcc/12.2.0 python/3.11.6 py-mpi4py/3.1.4
module list

mpirun -np 2 python3 poisson.py

echo "Done"
