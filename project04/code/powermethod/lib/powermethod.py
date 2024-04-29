import re
import subprocess
from typing import Tuple


def run(n_processes: int, test_case: int = 3, n: int = 1_000, niter: int = 3000, tol: float = -1e-6) -> Tuple[float, float]:
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

    print(
        f"\t\tRunning benchmark for {n_processes} processes, {n} size, {niter} iterations, tol={tol}")

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
        match = re.findall(
            r"### (\d+), (\d+), (\d+), ([\d.]+), ([\d.]+) ###", output)

        if len(match) != 1:
            print(f"Error parsing the benchmark output: {output}")
            return -1

        match = match[0]

        processes = int(match[0])
        size = int(match[1])
        niter = int(match[2])
        theta = float(match[3])
        time = float(match[4])

    except Exception as e:
        print(f"Error parsing the benchmark output: {e}")
        return -1

    if processes != n_processes:
        print(
            f"Error running the benchmark: expected {n_processes} threads, got {processes}")
        return -1

    return time, theta
