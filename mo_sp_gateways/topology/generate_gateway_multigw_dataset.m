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
    G = generate_random_topology(N, density);
    s = struct();
    s.Graph = G;
    s.Density = density;
    s.N = N;
    s.Trial = k;
    topologies_data{k} = s;
end

save(dataset_path, 'topologies_data', 'N', 'K', 'density', '-mat');
end
