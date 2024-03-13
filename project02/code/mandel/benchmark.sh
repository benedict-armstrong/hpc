#!/bin/bash
#SBATCH --job-name=benchmark_mandel
#SBATCH --output=benchmark_mandel.out
#SBATCH --error=benchmark_mandel.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=48
#SBATCH --constraint=EPYC_7763
#SBATCH --time=00:20:00

# load some modules & list loaded modules
module load gcc
# module load intel
module list

# compile
make clean

mkdir -p build
mkdir -p images

make

python3 benchmark.py
