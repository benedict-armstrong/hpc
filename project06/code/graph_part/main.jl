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

# Read mesh, generate adjacency matrices and vertices coordinates
mesh = "airfoil1" # see the mesh folder (e.g., "mesh3e1", "CH-4468", ...)
A, coords = getData(mesh);

# Draw the mesh
save("images/$mesh.pdf", draw_graph(A, coords));

# Partitioning: Coordinate bisection
p = coordinate_part(A, coords); 
print("Edge-cut of $mesh mesh with coordinate bisection: " *
      "$(count_edge_cut(A, p))\n\n");
save("images/$(mesh)_coordinate.pdf", draw_graph(A, coords, p));

# Partitioning: METIS
p = metis_part(A, 4, :KWAY);
# p = metis_part(A, 4, :RECURSIVE);
print("Edge-cut of $mesh mesh with METIS: $(count_edge_cut(A, p))\n\n");
save("images/$(mesh)_metis.pdf", draw_graph(A, coords, p));
