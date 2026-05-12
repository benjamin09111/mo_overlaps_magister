function G = generate_random_topology(N, Lambda)
% Genera topología aleatoria y fuerza conectividad exactamente como el código base

% 1. TOPOLOGÍA: Matriz dispersa uniforme
adj = rand(N, N) < Lambda;
adj = triu(adj, 1);
adj = adj + adj';
G = graph(adj);

% 2. CONECTIVIDAD FORZADA
bins = conncomp(G);
while max(bins) > 1
    nodes_c1 = find(bins == 1);
    nodes_other = find(bins ~= 1);

    u_rand = nodes_c1(randi(length(nodes_c1)));
    v_rand = nodes_other(randi(length(nodes_other)));

    G = addedge(G, u_rand, v_rand, 1);
    bins = conncomp(G);
end
end