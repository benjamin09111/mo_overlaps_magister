function generate_gateway_paper_dataset(cfg)
% Genera topologias fijas para la replica single-gateway centrality paper.
% La densidad se interpreta como probabilidad usada por sprand antes de forzar conectividad.

this_file = mfilename('fullpath');
this_dir = fileparts(this_file);
project_root = fileparts(this_dir);
dataset_path = fullfile(project_root, cfg.gateway_paper_dataset_name);

N = cfg.N;
densities = cfg.gateway_paper_densities;
K = cfg.num_tests;

topologies_data = cell(length(densities), K);
rng(cfg.gateway_paper_rng_seed, 'twister');

for d_idx = 1:length(densities)
    density = densities(d_idx);
    edge_probability = gateway_density_to_probability(cfg, density);
    for k = 1:K
        G = generate_gateway_random_topology(N, edge_probability);

        s = struct();
        s.Graph = G;
        s.Density = density;
        s.EdgeProbability = edge_probability;
        s.N = N;
        s.Trial = k;

        topologies_data{d_idx, k} = s;
    end
end

edge_probabilities = zeros(size(densities));
for idx = 1:length(densities)
    edge_probabilities(idx) = gateway_density_to_probability(cfg, densities(idx));
end
save(dataset_path, 'topologies_data', 'N', 'K', 'densities', 'edge_probabilities', '-mat');
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
