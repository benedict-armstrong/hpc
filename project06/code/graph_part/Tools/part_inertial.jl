# M.L. for High Performance Computing Lab @USI & @ETHZ - malik.lechekhab@usi.ch 
"""
    inertial_part(A, coords)

Compute the bi-partions of graph `A` using inertial method based on the
`coords` of the graph.

# Examples
```julia-repl
julia> inertial_part(A, coords)
 1
 ⋮
 2
```
"""
function inertial_part(A, coords)

    # 1. Compute the center of mass.
    com = mean(coords, dims=1)
    # 2. Construct the matrix M. (see pdf of the assignment)
    M = zeros(2, 2)
    M[1, 1] = sum((coords[:, 2] .- com[2]) .^ 2)
    M[2, 2] = sum((coords[:, 1] .- com[1]) .^ 2)
    M[1, 2] = sum((coords[:, 1] .- com[1]) .* (coords[:, 2] .- com[2]))
    M[2, 1] = M[1, 2]

    # 3. Compute the eigenvector associated with the smallest eigenvalue of M.
    _, eigv = Arpack.eigs(M, nev=1, which=:SR, ritzvec=true)
    # 4. Partition the nodes around line L 
    #    (use may use the function partition(coords, eigv))
    p1, p2 = partition(coords, eigv)

    # 5. Return the indicator vector
    p = ones(Int, size(coords)[1])
    p[p1] .= 1
    p[p2] .= 2

    # RANDOM PARTITIONING - REMOVE AFTER COMPLETION OF THE EXERCISE
    # n = size(A)[1]
    # rng = MersenneTwister(1234)
    # p = Int.(bitrand(rng, n))
    return p

end
