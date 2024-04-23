import argparse
import json
import re
import subprocess
from typing import Tuple


def run(n_processes: int, test_case: int = 3, n: int = 10_000, niter: int = 3000, tol: float = -1e-6) -> Tuple[float, float]:
    """
    Run the benchmark (binary in /build) for the given type and number of iterations (first arg)

    One line of output of the benchmark looks like this:
    ```
    ### 8, 1004, 100, 125.969533, 0.020900 ###
    ```

    1. no. of processes
    2. size of matrix (n)
    3. number of iterations
    4. final value (theta)
    5. time taken in seconds

    return (time, theta)

    """

    # run the benchmark with the given type and number of iterations set
    # n_processes, test_case, n, niter, tol
    try:
        output = subprocess.check_output(
            [
                "mpirun",
                "-np",
                str(n_processes),
                "./build/powermethod_rows",
                str(test_case),
                str(n),
                str(niter),
                str(tol)
            ]
        ).decode("utf-8")
    except subprocess.CalledProcessError as e:
        print(f"Error running the benchmark: {e}")
        return -1

    # parse the output using regex and return the time
    try:
        match = re.match(
            r"### (\d+), (\d+), (\d+), ([\d.]+), ([\d.]+) ###", output)
        processes = int(match.group(1))
        size = int(match.group(2))
        niter = int(match.group(3))
        theta = float(match.group(4))
        time = float(match.group(5))
    except Exception as e:
        print(f"Error parsing the benchmark output: {e}")
        return -1

    if processes != n_processes:
        print(
            f"Error running the benchmark: expected {n_processes} threads, got {processes}")
        return -1

    return time, theta


if __name__ == "__main__":

    argparser = argparse.ArgumentParser()

    argparser.add_argument(
        "--runs", help="Number of runs", type=int, default=3)
    argparser.add_argument(
        "--processes", help="Number of processes to run the benchmark for", type=int, nargs="+", default=[1, 2, 4, 8])

    args = argparser.parse_args()

    processes = args.processes
    runs = args.runs

    # print config
    print(f"Running benchmark for processes: {processes}")
    print(f"Number of runs: {runs}")

    times = []

    for p in processes:
        r = []
        for _ in range(runs):
            r.append(run(p))
        times.append(r)

    # save time results to a json file
    data = {
        "processes": processes,
        "runs": runs,
        "times": times,
    }
    json.dump(data, open("strong_scaling.json", "w"))
