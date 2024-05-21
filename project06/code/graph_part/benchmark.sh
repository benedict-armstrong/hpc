#!/bin/bash
#SBATCH --job-name=graph_julia                            # Job name    (default: sbatch)
#SBATCH --output=out/graph_julia.out                      # Output file (default: slurm-%j.out)
#SBATCH --error=out/graph_julia.err                       # Error file  (default: slurm-%j.out)
#SBATCH --constraint=EPYC_7763                            # Select node with CPU
#SBATCH --mem-per-cpu=8G                                  # Memory per CPU
#SBATCH --time=10:00:00                                   # Wall clock time limit
#SBATCH --mail-user=benedict.armstrong@inf.ethz.ch
#SBATCH --mail-type=END

# Load some modules & list loaded modules
module load gcc julia eth_proxy
module list

export JULIA_DEPOT_PATH="$HOME/.julia:/cluster/work/math/hpclab/julia:$JULIA_DEPOT_PATH"

srun julia --project=. ./main_bench.jl

echo "Done"
