import argparse
import subprocess
import matplotlib.pyplot as plt


def run(n_threads: int) -> float:
    """
    Run the benchmark (binary in /build) for the given type and number of iterations (first arg)

    Output of the benchmark looks like this:
    ```
    OMP_NUM_THREADS=8
    dist[0]=93
    dist[1]=3285
    dist[2]=85350
    dist[3]=1260714
    dist[4]=10871742
    dist[5]=54586161
    dist[6]=159818704
    dist[7]=273378686
    dist[8]=273376192
    dist[9]=159818436
    dist[10]=54574834
    dist[11]=10876069
    dist[12]=1261215
    dist[13]=85045
    dist[14]=3397
    dist[15]=77
    Time: 0.244005 sec
    ```

    """

    # run the benchmark with the given type and number of iterations set
    # OMP_NUM_THREADS env variable is set to the number of threads
    try:
        output = subprocess.check_output(
            [f"./build/hist_omp"],
            env={"OMP_NUM_THREADS": str(n_threads)}
        ).decode("utf-8")

    except subprocess.CalledProcessError as e:
        print(f"Error running the benchmark: {e}")
        return -1

    # parse the output and return the total time

    time = float(output.split("\n")[-2].split()[-2])
    threads = int(output.split("\n")[0].split("=")[-1])

    if threads != n_threads:
        print(
            f"Error running the benchmark: expected {n_threads} threads, got {threads}")
        return -1

    return time


if __name__ == "__main__":
    parser = argparse.ArgumentParser(prog='Scaling Benchmark')
    parser.add_argument(
        '-t', '--max_threads',
        type=int,
        default=8,
        help='Maximum number of threads'
    )

    args = parser.parse_args()

    n_threads = list(range(1, args.max_threads + 1))

    times = []
    for threads in n_threads:
        print(f"Running benchmark for {threads} threads")
        time = run(threads)
        if time == -1:
            print(f"Error running the benchmark for {threads} threads")
        else:
            times.append((time, threads))

    plt.plot([i[1] for i in times], [i[0] for i in times])

    plt.title("Histogram benchmark")
    plt.xlabel("Number of threads")
    plt.ylabel("Total time (s)")
    plt.yscale('log')
    plt.savefig("benchmark.png")

    # plot speedup in seperate plot
    t_1 = times[0][0]
    speedup = [t_1 / t[0] for t in times]
    plt.clf()
    plt.plot(n_threads, speedup)
    plt.ylabel("Speedup")
    plt.xlabel("Threads")
    plt.savefig("speedup.png")

    print(f"Threads: {[i[1] for i in times]}")
    print(f"Times: {[i[0] for i in times]}")
