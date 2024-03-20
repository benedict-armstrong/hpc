import argparse
import subprocess
import matplotlib.pyplot as plt


def run(n_threads: int, exe: str) -> float:
    """
    Run the benchmark (binary in /build) for the given type and number of iterations (first arg)

    Output of the benchmark looks like this:
    ```
    [type] RunTime:  5.074952 seconds
    Final Result Sn   :  485165097.62511122 
    Result ||opt||^2_2 :  5884629305179575.000000
    ```

    """

    # run the benchmark with the given type and number of iterations set
    # OMP_NUM_THREADS env variable is set to the number of threads
    try:
        output = subprocess.check_output(
            [f"./build/{exe}", f"images/mandel_par_{n_threads}.png"],
            env={"OMP_NUM_THREADS": str(n_threads)}
        ).decode("utf-8")

    except subprocess.CalledProcessError as e:
        print(f"Error running the benchmark: {e}")
        return -1

    # parse the output and return the total time

    time = float(output.split("\n")[0].split()[-2])

    return time


def main():
    parser = argparse.ArgumentParser(prog='Scaling Benchmark')
    parser.add_argument(
        '-t', '--max_threads',
        type=int,
        default=8,
        help='Maximum number of threads'
    )
    parser.add_argument(
        '-r', '--runs',
        type=int,
        default=5,
        help='Number of runs'
    )

    args = parser.parse_args()

    n_threads = list(range(1, args.max_threads + 1))

    # run sequential version
    times = []
    for i in range(args.runs):
        time = run(1, "recur_seq")
        print(f"Sequential run {i + 1}: {time}")
        times.append(time)

    print(f"Sequential average: {sum(times) / len(times)}")

    times = []
    for threads in n_threads:
        time = run(i, "recur_omp")
        print(f"Parallel run {threads + 1}: {time}")
        times.append((time, threads))

    plt.plot([i[1] for i in times], [i[0] for i in times])

    plt.title("Loop dependencies benchmark")
    plt.xlabel("Number of threads")
    plt.ylabel("Total time (s)")

    plt.savefig("benchmark.png")


if __name__ == "__main__":
    main()
