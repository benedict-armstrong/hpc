#!/bin/bash
#SBATCH --job-name=manager_worker      # Job name    (default: sbatch)
#SBATCH --output=manager_worker.out # Output file (default: slurm-%j.out)
#SBATCH --error=manager_worker.err  # Error file  (default: slurm-%j.out)
#SBATCH --nodes=1                 # Number of nodes
#SBATCH --ntasks=33               # Number of tasks
#SBATCH --constraint=EPYC_7763    # Select node with CPU
#SBATCH --cpus-per-task=1         # Number of CPUs per task
#SBATCH --mem-per-cpu=1024        # Memory per CPU
#SBATCH --time=00:10:00           # Wall clock time limit

# Load some modules & list loaded modules
module load gcc openmpi python
module list

python -m venv project05-env      # creates a virtual environment
source project05-env/bin/activate # activates the virtual environment
pip install numpy scipy matplotlib mpi4py

# run with 3-33 workers and 100/50 tasks

for i in {3..33}; do
    echo "Running with $i workers and 50 tasks"
    (mpirun -np $i python3 manager_worker.py 4001 4001 50) | grep "Run took" >>manager_worker_results_50.txt
done

for i in {3..33}; do
    echo "Running with $i workers and 100 tasks"
    (mpirun -np $i python3 manager_worker.py 4001 4001 100) | grep "Run took" >>manager_worker_results_100.txt
done

deactivate
echo "Done"
