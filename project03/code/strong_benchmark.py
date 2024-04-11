import argparse
import re
import subprocess
from typing import List
import matplotlib.pyplot as plt


def run(n_threads: int, size=128, times_steps=100, final_time=0.005) -> float:
    """
    Run the benchmark (binary in /build) for the given type and number of iterations (first arg)

    Output of the benchmark looks like this:
    ```
    ================================================================================
                        Welcome to mini-stencil!
    version   :: C++ OpenMP
    threads   :: 4
    mesh      :: 128 * 128 dx = 0.00787402
    time      :: 100 time steps from 0 .. 0.005
    iteration :: CG 300, Newton 50, tolerance 1e-06
    ================================================================================
    --------------------------------------------------------------------------------
    simulation took 0.147727 seconds
    1514 conjugate gradient iterations, at rate of 10248.6 iters/second
    300 newton iterations
    --------------------------------------------------------------------------------
    ### 4, 128, 100, 1514, 300, 0.147727 ###
    Goodbye!
    ```

    """

    # run the benchmark with the given type and number of iterations set
    # OMP_NUM_THREADS env variable is set to the number of threads
    try:
        output = subprocess.check_output(
            [f"./build/main", str(size), str(times_steps), str(final_time)],
            env={"OMP_NUM_THREADS": str(n_threads)}
        ).decode("utf-8")

    except subprocess.CalledProcessError as e:
        print(f"Error running the benchmark: {e}")
        return -1

    # parse the output using regex and return the time
    try:
        time = float(re.search(
            r"simulation took (\d+\.\d+) seconds", output).group(1))
        threads = int(re.search(r"threads\s*::\s*(\d+)", output).group(1))
    except Exception as e:
        print(f"Error parsing the benchmark output: {e}")
        return -1

    if threads != n_threads:
        print(
            f"Error running the benchmark: expected {n_threads} threads, got {threads}")
        return -1

    return time


if __name__ == "__main__":

    argparser = argparse.ArgumentParser()

    argparser.add_argument(
        "--sizes", help="List of sizes to run the benchmark for", type=int, nargs="+", default=[128, 256, 512, 1024])
    argparser.add_argument(
        "--runs", help="Number of runs", type=int, default=3)
    argparser.add_argument(
        "--threads", help="Number of threads to run the benchmark for", type=int, nargs="+", default=[1, 2, 4, 8])
    argparser.add_argument(
        "--plot_from", help="Plot from the given file", type=str, default=None)

    args = argparser.parse_args()

    threads = args.threads
    sizes = args.sizes
    runs = args.runs

    if not args.plot_from:
        # print config
        print(f"Running benchmark for sizes: {sizes}")
        print(f"Running benchmark for threads: {threads}")
        print(f"Number of runs: {runs}")

        times = []

        for size in sizes:
            temp = []
            print(f"Running benchmark for size {size}")
            for thread in threads:
                r = []
                for _ in range(runs):
                    r.append(run(thread, size))
                temp.append(r)
            times.append(temp)

        # save time results to a file
        with open("strong_scaling_results.csv", "w") as f:
            f.write(f"size,{','.join(map(str, threads))}\n")
            for i, size in enumerate(sizes):
                f.write(f"{size},{','.join(map(str, times[i]))}\n")

    else:

        print(f"Plotting from {args.plot_from}")

        times = []
        with open(args.plot_from, "r") as f:
            f.readline()
            for line in f:
                size, *t = map(float, line.strip().split(","))
                times.append(t)

    # plot each threadcount as a line (different color) and each size as a point with error bars
    for i, size in enumerate(sizes):
        plt.errorbar(threads, [sum(t) / len(t) for t in times[i]],
                     yerr=[max(t) - min(t) for t in times[i]], label=f"size {size}")

    plt.xlabel("Number of threads")
    plt.ylabel("Time (s)")
    plt.legend()

    plt.savefig("strong_scaling_plot.svg")

    plt.show()
