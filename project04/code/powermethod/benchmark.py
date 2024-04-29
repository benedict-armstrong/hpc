import argparse
import json
import math
import os
from lib import powermethod

N_ITER = 3000
TOL = -1e-6
TEST_CASE = 3

if __name__ == "__main__":

    argparser = argparse.ArgumentParser()

    argparser.add_argument(
        "--runs", help="Number of runs", type=int, default=20)
    argparser.add_argument(
        "--processes", help="Number of processes to run the benchmark for", type=int, nargs="+", default=[1, 2, 4, 8, 16, 32, 64])
    argparser.add_argument(
        "--type", help="Type of benchmark to run", choices=["strong", "weak"], default="strong"
    )
    argparser.add_argument(
        "--base_size", help="Base size", type=int, default=3_000
    )

    args = argparser.parse_args()

    processes = args.processes
    runs = args.runs
    benchmark_type = args.type
    base_size = args.base_size

    # print config
    print(f"Running {benchmark_type} benchmark for processes: {processes}")
    print(f"Number of runs: {runs}")

    times = []
    sizes = []

    for p in processes:
        r = []

        if benchmark_type == "weak":
            size = math.ceil(math.sqrt(p) * base_size)
        else:
            size = base_size
        print(f"{p} processes ({runs} runs) and size {size} ({size//p} per process) host: {os.uname().nodename}")

        for i in range(runs):
            time, theta = powermethod.run(
                n_processes=p,
                n=size,
                niter=N_ITER,
                tol=TOL,
                test_case=TEST_CASE
            )
            r.append(time)
            print(f"\t{i}: time: {time}")
        times.append(r)
        sizes.append(size)

        # write to intermediate file
        data = {
            "processes": p,
            "times": r,
            "size": size
        }
        json.dump(data, open(f"out/{benchmark_type}_{p}.json", "w"))

    # save time results to a json file
    data = {
        "processes": processes,
        "runs": runs,
        "times": times,
        "sizes": sizes,
        "host": os.uname().nodename,
        "base_size": base_size,
        "type": benchmark_type
    }
    json.dump(data, open(f"out/{benchmark_type}_scaling.json", "w"))
