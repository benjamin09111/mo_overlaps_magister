function topology = get_gateway_multigw_topology(cfg, trial_idx)
% Carga una topologia fija del dataset multi-gateway.

persistent cached_data cached_path

this_file = mfilename('fullpath');
this_dir = fileparts(this_file);
project_root = fileparts(this_dir);
dataset_path = fullfile(project_root, cfg.gateway_multigw_dataset_name);

if isempty(cached_data) || isempty(cached_path) || ~strcmp(cached_path, dataset_path)
    cached_data = load(dataset_path, '-mat');
    cached_path = dataset_path;
end

if trial_idx < 1 || trial_idx > cached_data.K
    error('trial_idx fuera de rango: %d', trial_idx);
end

topology = cached_data.topologies_data{trial_idx};
end
