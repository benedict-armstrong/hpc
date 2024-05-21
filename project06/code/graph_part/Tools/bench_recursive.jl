# M.L. for High Performance Computing Lab @USI & @ETHZ - malik.lechekhab@usi.ch 
"""
    benchmark_recursive()

Run a benchmark of different meshes with different recursive partitioning
method.

# Examples
```julia-repl
julia> function benchmark_recursive()
()
```
"""
function benchmark_recursive()
    # List the meshes to compare
    meshes = ["mesh3e1", "airfoil1", "netz4504_dual", "stufe", "3elt", "barth4",
        "ukerbe1", "crack"]

    # List the algorithms to recursively run and compare
    algs = ["Coordinate", "Coordinate", "Metis (KWAY)", "Metis(KWAY)",
        "Metis (RECURSIVE)", "Metis(RECURSIVE)",
        "Inertial", "Inertial", "Spectral", "Spectral"]

    # Init comparison table
    pAll = Array{Any}(undef, length(meshes), length(algs) + 1)

    # Loop through meshes
    for (i, mesh) in enumerate(meshes)
        print("Benchmarking $mesh mesh...\n")

        # Read data
        A, coords = getData(mesh)

        # 1st row
        pAll[i, 1] = mesh

        # 1. Coordinate
        pCoordinate08 = rec_bisection(coordinate_part, 3, A, coords)
        pCoordinate16 = rec_bisection(coordinate_part, 4, A, coords)
        pAll[i, 2] = count_edge_cut(A, pCoordinate08)
        pAll[i, 3] = count_edge_cut(A, pCoordinate16)

        # 2. METIS (KWAY)
        pMetis_kway08 = metis_part(A, 8, :KWAY)
        pMetis_kway16 = metis_part(A, 16, :KWAY)
        pAll[i, 4] = count_edge_cut(A, pMetis_kway08)
        pAll[i, 5] = count_edge_cut(A, pMetis_kway16)

        # 3. METIS (RECURSIVE)
        pMetis_recursive08 = metis_part(A, 8, :RECURSIVE)
        pMetis_recursive16 = metis_part(A, 16, :RECURSIVE)
        pAll[i, 6] = count_edge_cut(A, pMetis_recursive08)
        pAll[i, 7] = count_edge_cut(A, pMetis_recursive16)

        # 4. Inertial
        pInertial08 = rec_bisection(inertial_part, 3, A, coords)
        pInertial16 = rec_bisection(inertial_part, 4, A, coords)
        pAll[i, 8] = count_edge_cut(A, pInertial08)
        pAll[i, 9] = count_edge_cut(A, pInertial16)

        # 5. Spectral
        pSpectral08 = rec_bisection(spectral_part, 3, A)
        pSpectral16 = rec_bisection(spectral_part, 4, A)
        pAll[i, 10] = count_edge_cut(A, pSpectral08)
        pAll[i, 11] = count_edge_cut(A, pSpectral16)

    end

    # Print result table
    header = (vcat(["Mesh"], algs), ["", "8 parts", "16 parts",
        "8 parts", "16 parts",
        "8 parts", "16 parts",
        "8 parts", "16 parts",
        "8 parts", "16 parts"])
    pretty_table(pAll; header=header, crop=:none,
        header_crayon=crayon"bold cyan")
end
