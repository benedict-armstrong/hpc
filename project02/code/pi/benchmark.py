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


def main():

    # run the benchmark for each type and number of iterations
    # and plot the results
    # create three plots

    fig, axs = plt.subplots(3, sharex=True)

    # set space between plots
    # plt.subplots_adjust(hspace=0.5)

    # y axis log scale
    axs[0].set_yscale("log")
    axs[1].set_yscale("log")
    axs[2].set_yscale("log")

    types = ["pi_serial", "pi_omp_critical", "pi_omp_reduction"]
    threads = [1, 2, 3, 4, 5, 6, 7, 8]
    iterations = [10**i for i in range(3, 10, 2)]

    for t, type in enumerate(types):
        for i, n in enumerate(iterations):
            times = []
            for n_threads in threads:
                times.append(run(type, n, n_threads))
            # set line thickness
            if i == len(iterations) - 1:
                axs[t].plot(threads, times, label=f"N = {n}", linewidth=1)
            else:
                axs[t].plot(threads, times,
                            label=f"N = {n}", linewidth=1, alpha=0.5)
            axs[t].set_title(type)
            axs[t].set_ylabel("Time (s)")

            if t == 0:
                axs[t].legend()
            if t == len(types) - 1:
                axs[t].set_xlabel("Number of threads")

    # global legend
    axs[0].legend(loc="upper right")

    plt.savefig("benchmark.png")


if __name__ == "__main__":
    main()
