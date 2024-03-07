#!/bin/bash
#SBATCH --job-name=hello_euler_2      # Job name    (default: sbatch)
#SBATCH --output=hello_euler_2.out    # Output file (default: slurm-%j.out)
#SBATCH --error=hello_euler_2.err     # Error file  (default: slurm-%j.out)
#SBATCH --time=00:01:00               # Wall clock time limit
#SBATCH --nodes=2                     # Number of tasks
#SBATCH --ntasks=2                    # Number of tasks
#SBATCH --cpus-per-task=1             # Number of CPUs per task
#SBATCH --mem-per-cpu=1024            # Memory per CPU

srun hello_euler hello_euler
