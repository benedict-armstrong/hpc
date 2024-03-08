#!/bin/bash
#SBATCH --job-name=hello_euler        # Job name    (default: sbatch)
#SBATCH --output=hello_euler.out      # Output file (default: slurm-%j.out)
#SBATCH --error=hello_euler.err       # Error file  (default: slurm-%j.out)
#SBATCH --time=00:01:00               # Wall clock time limit
#SBATCH --nodes=1                     # Number of tasks
#SBATCH --ntasks=1                    # Number of tasks
#SBATCH --cpus-per-task=1             # Number of CPUs per task
#SBATCH --mem-per-cpu=1024            # Memory per CPU
#SBATCH --constraint=EPYC_9654

srun hello_euler
