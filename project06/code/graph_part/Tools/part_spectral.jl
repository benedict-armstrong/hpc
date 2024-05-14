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
function spectral_part(A)
    n = size(A)[1]

    if n > 4*10^4
        @warn "graph is large. Computing eigen values may take too long."     
    end

    # 1. Construct the Laplacian matrix.

    # 2. Compute its eigendecomposition.

    # 3. Label the vertices with the entries of the Fiedler vector.

    # 4. Partition them around their median value, or 0.

    # 5. Return the indicator vector

    # RANDOM PARTITIONING - REMOVE AFTER COMPLETION OF THE EXERCISE
    n = size(A)[1];
    rng = MersenneTwister(1234);
    p = Int.(bitrand(rng, n));
    return p

end
