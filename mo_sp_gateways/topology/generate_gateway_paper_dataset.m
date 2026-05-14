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
    for k = 1:K
        G = generate_random_topology(N, density);

        s = struct();
        s.Graph = G;
        s.Density = density;
        s.N = N;
        s.Trial = k;

        topologies_data{d_idx, k} = s;
    end
end

save(dataset_path, 'topologies_data', 'N', 'K', 'densities', '-mat');
end
