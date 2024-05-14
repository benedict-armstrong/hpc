# M.L. for High Performance Computing Lab @USI & @ETHZ - malik.lechekhab@usi.ch 
# Data extraction method
"""
    listFiles()

List the files available in the meshes folder.

# Examples
```julia-repl
julia> listFiles()
Dict{Any, Any} with 28 entries:
  "VN-4031-pts.csv" => "./Meshes/Countries/csv/VN-4031-pts.csv"
  ⋮                 => ⋮
```
"""
function listFiles()
    root = string(dirname(@__DIR__))
    root = joinpath(root, "Meshes")
    itr = collect(walkdir(root))
    filePaths = Dict()

    for i in itr
        path = i[1]
        files = i[3]
        if !isempty(files)
            for file in files
                filePaths[file] = joinpath(path, file)
            end
        end
    end

    return filePaths
end


"""
    getPath(files, request)

Get path of a `request`ed file among a list of `files`.
"""
function getPath(files, request)
    for k in keys(files)
        if occursin(request, k)
            ext = last(split(files[k], '.'))
            return files[k], ext
        end
    end

    @warn "file not found in the folder of Meshes"
end


"""
    getCSVFilesPath(path)

Get the CSV files paths available in a folder.
"""
function getCSVFilesPath(path)
    fullPath = split(path, '/')
    fileName = last(fullPath)
    splitName = split(fileName, '-')
    prefixName = splitName[1]*'-'*splitName[2]
    adjFileName = prefixName*"-adj.csv"
    coordFileName = prefixName*"-pts.csv"
    adjFilePath = "/"*string(joinpath(joinpath(fullPath[1:end-1]), adjFileName))
    coordFilePath = "/"*joinpath(joinpath(fullPath[1:end-1]), coordFileName)

    return adjFilePath, coordFilePath
end


"""
    buildAdjMat(edges, n)

Compute adjacency matrix based on the `edges` of a `n` by `n` graph.
"""
function buildAdjMat(edges, n)
    m = size(edges)[1]
    A = spzeros(n, n)
    for i in 1:m
        dst = edges[i, 1]
        src = edges[i, 2]

        A[dst, src] = 1
        A[src, dst] = 1 
    end
    
    return A
end


"""
    getData(request)

Extract the data from a `requested` MAT or CSV file.
"""
function getData(request)
    files = listFiles()
    path, ext = getPath(files, request)

    if ext == "mat"
        file = matopen(path)
        data = read(file)
        if haskey(data, "Problem")
            A = data["Problem"]["A"]
            coords = data["Problem"]["aux"]["coord"]
        else
            A = sparse(data["CH_adj"])
            coords = data["CH_coords"]
        end
    elseif ext == "csv"

        adjFilePath, coordFilePath = getCSVFilesPath(path)

        coords = readdlm(coordFilePath, ',', skipstart=1, '\n')

        edges = readdlm(adjFilePath, ',', Int32, skipstart=1, '\n')
        n = size(coords)[1]
        
        A = buildAdjMat(edges, n)  
    end

    if !issymmetric(A)
        A = (A + transpose(A))
    end

    return A, coords
end


"""
    testAdj(type)

Create small adjacency matrix of testing.

It is possible to choose between network `type` or triangles `type`.

# Examples
```julia-repl
julia> A = testAdj("network");
julia> A = testAdj("triangles");
```
"""
function testAdj(type)
    if type=="network"
        A = [[0. 1. 1. 0. 0. 1. 0. 0. 1. 1.]
            [1. 0. 1. 0. 0. 0. 0. 0. 0. 0.]
            [1. 1. 0. 0. 0. 0. 0. 0. 0. 0.]
            [0. 0. 0. 0. 1. 1. 0. 0. 0. 0.]
            [0. 0. 0. 1. 0. 1. 0. 0. 0. 0.]
            [1. 0. 0. 1. 1. 0. 1. 1. 0. 0.]
            [0. 0. 0. 0. 0. 1. 0. 1. 0. 0.]
            [0. 0. 0. 0. 0. 1. 1. 0. 0. 0.]
            [1. 0. 0. 0. 0. 0. 0. 0. 0. 1.]
            [1. 0. 0. 0. 0. 0. 0. 0. 1. 0.]]
        A = sparse(A)
        x = [3 1 2 4 5 3 2 1 5 4]
        y = [2 1 1 5 5 4 5 5 1 1]
    elseif type=="triangles"
        A = [   [0. 1. 1. 1. 0. 0. ]
                [1. 0. 1. 0. 1. 0. ]
                [1. 1. 0. 0. 0. 1. ]
                [1. 0. 0. 0. 1. 1. ]
                [0. 1. 0. 1. 0. 1. ]
                [0. 0. 1. 1. 1. 0. ]]
        A = sparse(A)
        x = [2 4 4 0 6 6]
        y = [3 2 4 3 0 6]
    end
    
    
    coords = hcat(vec(x), vec(y))

    return A, coords
    
end
