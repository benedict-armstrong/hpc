import argparse
import subprocess
import matplotlib.pyplot as plt


def run(type: str, n: int, n_threads: int) -> float:
    """
    Run the benchmark (binary in /build) for the given type and number of iterations (first arg)

    Output of the benchmark looks like this:
    ```
    pi = 3.141592653589871, N =   1000000, time = 0.00077000 secs
    ```

    We are specifically interested in the time, which is the last value in the line.
    """

    # run the benchmark with the given type and number of iterations set
    # OMP_NUM_THREADS env variable is set to the number of threads
    output = subprocess.check_output(
        [f"./build/{type}", str(n)],
        env={"OMP_NUM_THREADS": str(n_threads)}
    ).decode("utf-8")

    # split the output by spaces
    # last value is the time
    time = float(output.split()[-2])

    return time


def run_weak_scaling(type: str, n_per_processor: int, n_threads: int) -> float:
    return run(type, n_per_processor * n_threads, n_threads)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(prog='Scaling Benchmark')
    parser.add_argument(
        '-t', '--max_threads',
        type=int,
        default=8,
        help='Maximum number of threads'
    )
    parser.add_argument(
        '-n',
        '--problem_size',
        type=int,
        default=1000000,
        help='Problem size'
    )
    parser.add_argument(
        '-m',
        '--problem_pp',
        type=int,
        default=100000,
        help='Problem size per Processor'
    )
    args = parser.parse_args()

    fig, axs = plt.subplots(nrows=2, ncols=2, sharex=True, figsize=(12, 10))

    # run the benchmark for each type and number of iterations
    types = ["pi_serial", "pi_omp_critical", "pi_omp_reduction"]
    threads = list(range(1, args.max_threads + 1))

    # run strong and weak scaling
    data = {}

    for t, type in enumerate(types):
        times = []
        for n_threads in threads:
            times.append(run(type, args.problem_size, n_threads))
        axs[0, 0].plot(threads, times, label=type, linewidth=1)
        axs[0, 0].set_title(f"Strong scaling (N={args.problem_size:.1e})")
        axs[0, 0].set_ylabel("Time (s)")

        # plot speedup below
        speedup = [times[0] / t for t in times]
        axs[1, 0].plot(threads, speedup, label=type, linewidth=1)
        axs[1, 0].set_ylabel("Speedup")
        axs[1, 0].set_xlabel("Threads")
        data[type + "_strong"] = times
        print(f"{type} strong scaling: {times}")

    for t, type in enumerate(types):
        times = []
        for n_threads in threads:
            if type == "pi_serial":
                times.append(run_weak_scaling(type, args.problem_pp, 1))
            else:
                times.append(run_weak_scaling(
                    type, args.problem_pp, n_threads))
        axs[0, 1].plot(threads, times, label=type, linewidth=1)
        axs[0, 1].set_title(
            f"Weak scaling (N per processor={args.problem_pp:.1e})")
        axs[0, 1].set_ylabel("Time (s)")

        data[type + "_weak"] = times
        print(f"{type} weak scaling: {times}")

        if type == "pi_serial":
            continue

        # plot efficiency below
        efficiency = [times[0] / (t * n) for t, n in zip(times, threads)]
        axs[1, 1].plot(threads, efficiency, label=type, linewidth=1)
        axs[1, 1].set_ylabel("Efficiency")
        axs[1, 1].set_xlabel("Threads")

    # global legend
    axs[0, 1].legend(loc="upper right")
    # set axis log
    axs[0, 0].set_yscale("log")
    axs[0, 1].set_yscale("log")

    print("## Data")
    print(data)

    plt.savefig("benchmark.png", dpi=300)
    # plt.show()
