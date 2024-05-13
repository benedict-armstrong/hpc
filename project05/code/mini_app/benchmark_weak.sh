#!/bin/bash
#SBATCH --job-name=mini_weak                            # Job name    (default: sbatch)
#SBATCH --output=out/mini_weak.out                          # Output file (default: slurm-%j.out)
#SBATCH --error=out/mini_weak.err                           # Error file  (default: slurm-%j.out)
#SBATCH --nodes=1                                       # Number of nodes
#SBATCH --ntasks=64                                     # Number of tasks
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

runs=3

# add header to the output file
echo "cpus,res,base_res,time,run" >out/results_weak.csv

#
for base_res in 64 128 256; do
    echo "Running with base size n=$base_res"
    for cpus in 1 4 16 64; do
        # res = base_res * sqrt(cpus)
        res=$(echo "sqrt($cpus) * $base_res" | bc)
        echo "Running with $cpus workers and size n=$res"
        for j in $(seq 1 $runs); do
            time=$(mpirun -np $cpus ./build/mini_app $res 100 0.005 | grep "simulation took" | awk '{print $3}')
            echo "$cpus,$res,$base_res,$time,$j" >>out/results_weak.csv
            mv out/output.bin "out/output_weak_${cpus}_${res}_${j}.bin"
        done
    done
done

deactivate
echo "Done"
