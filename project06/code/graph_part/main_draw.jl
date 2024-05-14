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

# List the meshes to draw
meshes = ["CH-4468", "CL-13042", "GB-5946", "GR-3117", "NO-9935", "VN-4031",
          "mesh1e1", "mesh2e1", "mesh3e1", "airfoil1", "netz4504_dual",
          "stufe", "3elt", "barth4", "ukerbe1", "crack"]

# Draw meshes
for (i, mesh) in enumerate(meshes)
    # Read data
    A, coords = getData(mesh);

    # Draw
    save("images/meshes/$(mesh).pdf", draw_graph(A, coords));
end
