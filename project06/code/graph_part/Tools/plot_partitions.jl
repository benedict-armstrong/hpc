# M.L. for High Performance Computing Lab @USI & @ETHZ - malik.lechekhab@usi.ch 
"""
    draw_graph(A, coords, p)

Plot the partitions `p` of graph `A`.
"""
function draw_graph(A, coords, p)
    CairoMakie.activate!()

    show_embedding(coords, p;
                   A = A,                     # show edges on embedding
                   mrk_size = 0,              # vertices marker sizes
                   lwd_in = 1, lwd_out = 0.3, # edge widths
                   edge_alpha = 1,            # alpha channel for the edges
                   clr_out=colorant"gray")    # color of inter-cluster edges
end


"""
    draw_graph(A, coords)

Plot the graph based on its adjacency matrix `A`.
"""
function draw_graph(A, coords)
    n = size(A)[1]
    p = ones(Int, n)
    draw_graph(A, coords, p)
end
