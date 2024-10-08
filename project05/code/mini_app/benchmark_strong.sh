#!/bin/bash
#SBATCH --job-name=out/mini_strong                          # Job name    (default: sbatch)
#SBATCH --output=out/mini_strong.out                        # Output file (default: slurm-%j.out)
#SBATCH --error=out/mini_strong.err                         # Error file  (default: slurm-%j.out)
#SBATCH --nodes=1                                       # Number of nodes
#SBATCH --ntasks=16                                     # Number of tasks
#SBATCH --constraint=EPYC_7763                          # Select node with CPU
#SBATCH --cpus-per-task=1                               # Number of CPUs per task
#SBATCH --mem-per-cpu=1024                              # Memory per CPU
#SBATCH --time=10:00:00                                 # Wall clock time limit
#SBATCH --mail-user=benedict.armstrong@inf.ethz.ch
#SBATCH --mail-type=END

# Load some modules & list loaded modules
module load gcc openmpi
module list

make clean
make

runs=10

# add header to the output file
echo "cpus,res,time,run" >out/results_strong.csv

#
for cpus in 1 2 4 8 16; do
    for res in 64 128 256 512 1024; do
        echo "Running with $cpus workers and size n=$res"
        for j in $(seq 1 $runs); do
            time=$(mpirun -np $cpus ./build/mini_app $res 100 0.005 | grep "simulation took" | awk '{print $3}')
            echo "$cpus,$res,$time,$j" >>out/results_strong.csv
        done
    done
done

deactivate
echo "Done"
