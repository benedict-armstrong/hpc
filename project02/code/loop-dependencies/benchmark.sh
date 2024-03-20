#!/bin/bash
#SBATCH --job-name=loop-dep
#SBATCH --output=loop-dep.out
#SBATCH --error=loop-dep.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=47
#SBATCH --constraint=EPYC_7763
#SBATCH --time=00:20:00

# load some modules & list loaded modules
module load gcc python
# module load intel
module list

# compile
mkdir -p build
make clean
make

srun python3 benchmark.py --max_threads 47
