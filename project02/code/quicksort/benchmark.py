import argparse
import subprocess
import matplotlib.pyplot as plt


def run(n_threads: int, n: int = 10000000) -> float:
    """
    Run the benchmark (binary in /build) for the given type and number of iterations (first arg)

    Output of the benchmark looks like this:
    ```
    Size of dataset: 10000000, elapsed time[s] 4.454490e-01 
    ```

    """

    # run the benchmark with the given type and number of iterations set
    # OMP_NUM_THREADS env variable is set to the number of threads
    try:
        output = subprocess.check_output(
            [f"./build/quicksort", str(n)],
            env={"OMP_NUM_THREADS": str(n_threads)}
        ).decode("utf-8")

    except subprocess.CalledProcessError as e:
        print(f"Error running the benchmark: {e}")
        return -1

    # parse the output and return the total time
    time = float(output.split()[-1])

    return time


if __name__ == "__main__":
    parser = argparse.ArgumentParser(prog='Scaling Benchmark')
    parser.add_argument(
        '-t', '--max_threads',
        type=int,
        default=8,
        help='Maximum number of threads'
    )
    parser.add_argument(
        '-n', '--n',
        type=int,
        default=10000000,
        help='Size of the dataset'
    )

    args = parser.parse_args()

    n_threads = list(range(1, args.max_threads + 1))

    times = []
    for threads in n_threads:
        print(f"Running benchmark for {threads} threads")
        time = run(threads, args.n)
        times.append((time, threads))

    plt.plot([i[1] for i in times], [i[0] for i in times])

    plt.title("Quicksort benchmark")
    plt.xlabel("Number of threads")
    plt.ylabel("Total time (s)")

    plt.savefig("benchmark.png")

    for i in range(len(n_threads)):
        print(f"Threads: {[i[1] for i in times]}")
        print(f"Times: {[i[0] for i in times]}")
