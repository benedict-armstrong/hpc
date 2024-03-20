import argparse
import subprocess
import matplotlib.pyplot as plt


def run(n_threads: int) -> float:
    """
    Run the benchmark (binary in /build) for the given type and number of iterations (first arg)

    Output of the benchmark looks like this:
    ```
    Max. iterations:            1000
    Number of threads:          1
    Total time:                 10.4584 seconds
    Image size:                 4096 x 4096 = 16777216 Pixels
    Total number of iterations: 16777216000
    Avg. time per pixel:        6.23369e-07 seconds
    Avg. time per iteration:    inf seconds
    Iterations/second:          1.605e+08
    MFlop/s:                    123
    ```

    """

    # run the benchmark with the given type and number of iterations set
    # OMP_NUM_THREADS env variable is set to the number of threads
    try:
        output = subprocess.check_output(
            [f"./build/mandel_par", f"images/mandel_par_{n_threads}.png"],
            env={"OMP_NUM_THREADS": str(n_threads)}
        ).decode("utf-8")

    except subprocess.CalledProcessError as e:
        print(f"Error running the benchmark: {e}")
        return -1

    # parse the output and return the total time

    time = float(output.split("\n")[2].split()[-2])
    threads = int(output.split("\n")[1].split()[-1])

    if threads != n_threads:
        print(
            f"Error running the benchmark: expected {n_threads} threads, got {threads}")
        return -1

    return time


def main():
    parser = argparse.ArgumentParser(prog='Scaling Benchmark')
    parser.add_argument(
        '-t', '--max_threads',
        type=int,
        default=8,
        help='Maximum number of threads'
    )

    args = parser.parse_args()

    n_threads = list(range(1, args.max_threads + 1, 2))

    times = []
    for i in n_threads:
        print(f"Running benchmark for {i} threads")
        time = run(i)
        if time == -1:
            print(f"Error running the benchmark for {i} threads")
            times.append(0)
        else:
            times.append(time)

    plt.plot(n_threads, times)

    plt.title("Mandelbrot benchmark")
    plt.xlabel("Number of threads")
    plt.ylabel("Total time (s)")
    plt.yscale('log')

    plt.savefig("benchmark.png")

    for i in range(len(n_threads)):
        print(f"{n_threads[i]} {times[i]}\n")


if __name__ == "__main__":
    main()
