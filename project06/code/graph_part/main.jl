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
mesh = "mesh2e1" # see the mesh folder (e.g., "mesh3e1", "CH-4468", ...)
A, coords = getData(mesh);

# Draw the mesh
save("images/$mesh.pdf", draw_graph(A, coords));

# Partitioning: Coordinate bisection
# p = coordinate_part(A, coords);
# print("Edge-cut of $mesh mesh with coordinate bisection: " *
#       "$(count_edge_cut(A, p))\n\n");
# save("images/bisection/$(mesh)_coordinate.pdf", draw_graph(A, coords, p));

# # Partitioning: METIS
# p = metis_part(A, 4, :KWAY);
# # p = metis_part(A, 4, :RECURSIVE);
# print("Edge-cut of $mesh mesh with METIS: $(count_edge_cut(A, p))\n\n");
# save("images/bisection/$(mesh)_metis.pdf", draw_graph(A, coords, p));

# # Partitioning: Inertial bisection
# p = inertial_part(A, coords);
# print("Edge-cut of $mesh mesh with inertial bisection: " *
#       "$(count_edge_cut(A, p))\n\n");
# save("images/bisection/$(mesh)_inertial.pdf", draw_graph(A, coords, p));

# # Partitioning: Spectral bisection (Fiedler false)
# p = spectral_part(A);
# print("Edge-cut of $mesh mesh with spectral bisection: " *
#       "$(count_edge_cut(A, p))\n\n");
# save("images/bisection/$(mesh)_spectral.pdf", draw_graph(A, coords, p));

# # Partitioning: Spectral bisection (Fiedler true)
# p = spectral_part(A, fiedler=true);
# print("Edge-cut of $mesh mesh with spectral bisection (Fiedler): " *
#       "$(count_edge_cut(A, p))\n\n");
# save("images/bisection/$(mesh)_spectral_fiedler.pdf", draw_graph(A, coords, p));

# Recursive partitioning: Spectral
divisions = 3;
p = rec_bisection(spectral_part, divisions, A);
print("Edge-cut of $mesh mesh with recursive spectral partitioning: " *
      "$(count_edge_cut(A, p))\n\n");
save("images/recursive/$(mesh)_$(divisions)_spectral.pdf", draw_graph(A, coords, p));

