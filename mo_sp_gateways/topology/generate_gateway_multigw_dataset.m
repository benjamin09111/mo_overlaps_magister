function generate_gateway_multigw_dataset(cfg)
% Genera topologias fijas para la replica multi-gateway.

this_file = mfilename('fullpath');
this_dir = fileparts(this_file);
project_root = fileparts(this_dir);
dataset_path = fullfile(project_root, cfg.gateway_multigw_dataset_name);

N = cfg.N;
density = cfg.gateway_multigw_density;
K = cfg.num_tests;

topologies_data = cell(1, K);
rng(cfg.gateway_multigw_rng_seed, 'twister');

for k = 1:K
    G = generate_gateway_random_topology(N, density);
    s = struct();
    s.Graph = G;
    s.Density = density;
    s.N = N;
    s.Trial = k;
    topologies_data{k} = s;
end

save(dataset_path, 'topologies_data', 'N', 'K', 'density', '-mat');
end

function G = generate_gateway_random_topology(N, p)
% Generador local para evitar dependencias de path durante la replicacion.

A = sprand(N, N, p);
A = spones(A);
A = triu(A, 1);
A = A + A';
G = graph(A);

bins = conncomp(G);
while max(bins) > 1
    comp_ids = unique(bins);
    main_comp_nodes = find(bins == comp_ids(1));

    for c = 2:length(comp_ids)
        disconnected_nodes = find(bins == comp_ids(c));
        u = main_comp_nodes(randi(numel(main_comp_nodes)));
        v = disconnected_nodes(randi(numel(disconnected_nodes)));
        G = addedge(G, u, v, 1);
    end

    bins = conncomp(G);
end
end
