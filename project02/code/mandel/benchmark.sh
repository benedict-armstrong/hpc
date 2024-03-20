#!/bin/bash
#SBATCH --job-name=mandel
#SBATCH --output=mandel.out
#SBATCH --error=mandel.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=47
#SBATCH --constraint=EPYC_7763
#SBATCH --time=00:30:00

# load some modules & list loaded modules
module load gcc python
# module load intel
module list

# compile
mkdir -p build
mkdir -p images
make clean
make

srun python3 benchmark.py --max_threads 47
