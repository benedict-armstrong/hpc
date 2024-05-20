# M.L. for High Performance Computing Lab @USI & @ETHZ - malik.lechekhab@usi.ch 
"""
    rec_bisection(method, levels, A, coords=zeros(0), vn=zeros(0))

Compute recursive partitioning of graph `A` using a specified `method` and
number of `levels`.

If the `method` is `coords`-based, coordinates must be passed.

# Examples
```julia-repl
julia> rec_bisection("spectralPart", 3, A)
 5
 ⋮
 2

julia> rec_bisection("coordinatePart", 3, A, coords)
 1
 ⋮
 8
```
"""
function rec_bisection(method, levels, A, coords=zeros(0), vn=zeros(0))

    if 2^levels % 2 != 0
        return ones(size(A)[1])
    end

    if isempty(vn)
        n = size(A)[1]
        vn = collect(1:n)
    end

    if coords == zeros(0)
        p = method(A)
    else
        p = method(A, coords)
    end

    ids_1 = findall(x -> x == 1, p)
    ids_2 = findall(x -> x == 2, p)

    if coords == zeros(0)
        coords1 = zeros(0)
        coords2 = zeros(0)
    else
        coords1 = coords[ids_1, :]
        coords2 = coords[ids_2, :]
    end

    A1 = A[ids_1, ids_1]
    A2 = A[ids_2, ids_2]

    levels_new = levels - 1

    p1 = rec_bisection(method, levels_new, A1, coords1, vn[ids_1])
    p2 = rec_bisection(method, levels_new, A2, coords2, vn[ids_2]) .+ maximum(p1)

    return Int.(vcat(p1, p2)[sortperm(
        vcat(vn[ids_1], vn[ids_2])
    )])

end
