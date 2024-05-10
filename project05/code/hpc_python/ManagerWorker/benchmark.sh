#!/bin/bash
#SBATCH --job-name=manager_worker                       # Job name    (default: sbatch)
#SBATCH --output=manager_worker.out                     # Output file (default: slurm-%j.out)
#SBATCH --error=manager_worker.err                      # Error file  (default: slurm-%j.out)
#SBATCH --nodes=1                                       # Number of nodes
#SBATCH --ntasks=33                                     # Number of tasks
#SBATCH --constraint=EPYC_7763                          # Select node with CPU
#SBATCH --cpus-per-task=1                               # Number of CPUs per task
#SBATCH --mem-per-cpu=1024                              # Memory per CPU
#SBATCH --time=00:10:00                                 # Wall clock time limit
#SBATCH --mail-user=benedict.armstrong@inf.ethz.ch
#SBATCH --mail-type=END

# Load some modules & list loaded modules
module load gcc openmpi python
module list

# Create a virtual environment
python3 -m venv --system-site-packages project05-env
source project05-env/bin/activate # activates the virtual environment

# install required packages
pip install numpy scipy matplotlib mpi4py

# list installed packages
pip list

runs=10

# add header to the output file
# echo "workers,tasks,time,run" >out/results.csv

# run with 3-33 workers and 100/50 tasks
for task in 100 50; do
    for i in {2..3}; do
        echo "Running with $i workers and $task tasks and $runs runs"
        for j in $(seq 1 $runs); do
            time=$(mpirun -np $i python3 manager_worker.py 4001 4001 $task | grep "Run took" | awk '{print $3}')
            echo "$i,$task,$time,$j" >>out/results.csv
        done
    done
done

deactivate
echo "Done"

