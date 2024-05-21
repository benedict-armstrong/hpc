# M.L. for High Performance Computing Lab @USI & @ETHZ - malik.lechekhab@usi.ch 
# Main file of Project 6

# I/O packages
using DelimitedFiles, MAT
# Math packages
using Arpack, LinearAlgebra, Metis, Random, SparseArrays, Statistics
# Plot packages
using Graphs, SGtSNEpi, Colors, CairoMakie, PrettyTables

# Tools
include("./Tools/add_paths.jl");

# Run benchmark
print("Benchmarking bisection methods...\n")
benchmark_bisection()
print("\nBenchmarking recursive bisection...\n")
benchmark_recursive()
