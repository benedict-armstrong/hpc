#!/bin/bash
#SBATCH --job-name=mem_phase_1      # Job name    (default: sbatch)
#SBATCH --output=mem_phase_1.out # Output file (default: slurm-%j.out)
#SBATCH --error=mem_phase_1.err  # Error file  (default: slurm-%j.out)
#SBATCH --time=00:01:00               # Wall clock time limit
#SBATCH --nodes=1                    # Number of tasks
#SBATCH --ntasks=1                    # Number of tasks
#SBATCH --cpus-per-task=1             # Number of CPUs per task
#SBATCH --constraint=EPYC_7763

srun ./mem.sh EPYC_7763.fig
