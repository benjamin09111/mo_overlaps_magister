function topology = get_gateway_paper_topology(cfg, density, trial_idx)
% Carga una topologia fija del dataset single-gateway centrality paper.

persistent cached_data cached_path

this_file = mfilename('fullpath');
this_dir = fileparts(this_file);
project_root = fileparts(this_dir);
dataset_path = fullfile(project_root, cfg.gateway_paper_dataset_name);

if isempty(cached_data) || isempty(cached_path) || ~strcmp(cached_path, dataset_path)
    cached_data = load(dataset_path, '-mat');
    cached_path = dataset_path;
end

density_idx = find(abs(cached_data.densities - density) < 1e-12, 1);
if isempty(density_idx)
    error('Density no encontrada en dataset gateway paper: %.4f', density);
end

if trial_idx < 1 || trial_idx > cached_data.K
    error('trial_idx fuera de rango: %d', trial_idx);
end

topology = cached_data.topologies_data{density_idx, trial_idx};
end
