# M.L. for High Performance Computing Lab @USI & @ETHZ - malik.lechekhab@usi.ch 
"""
    spectral_part(A, fiedler=false)

Compute the bi-partions of graph `A` using spectral method.

If `fiedler` is true, return the entries of the fiedler vector.

# Examples
```julia-repl
julia> spectral_part(A)
 1
 ⋮
 2
```
"""
function spectral_part(A; fiedler=false)
    n = size(A)[1]

    if n > 4 * 10^4
        @warn "graph is large. Computing eigen values may take too long."
    end

    # 1. Construct the Laplacian matrix.
    L = laplacian(A)

    # 2. Compute its eigendecomposition.
    _, U = Arpack.eigs(L, nev=2, which=:SR, ritzvec=true)

    # 3. Label the vertices with the entries of the Fiedler vector.
    if fiedler
        p = U[:, 2] .> mean(U[:, 2])
    else
        p = U[:, 2] .> 0
    end

    # 4. Partition them around their median value, or 0.

    # 5. Return the indicator vector
    return Int.(p) .+ 1
end

function laplacian(A)
    return diagm(sum(A, dims=1)[:]) - A
end