module load gcc # load a compiler (gcc/11.4.0)
gcc -O3 -march=native -DSTREAM_TYPE=double -DSTREAM_ARRAY_SIZE=10000000 \
    -DNTIMES=20 stream.c -o stream_c.exe        # compile
sbatch --mem-per-cpu=2G --wrap "./stream_c.exe" # submit to queue and run
