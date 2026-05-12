function topology = get_topology_from_dataset(cfg, lambda, trial_idx)
% Carga una topologia especifica del dataset generado previamente.

persistent loaded_data;
this_file = mfilename('fullpath');
this_dir = fileparts(this_file);
project_root = fileparts(this_dir);
dataset_path = fullfile(project_root, 'dataset_topologies.dat');

if isempty(loaded_data)
    if exist(dataset_path, 'file')
        loaded_data = load(dataset_path, '-mat');
    else
        error('Dataset %s no encontrado. Ejecuta generate_topology_dataset primero.', dataset_path);
    end
end

lambda_idx = find(loaded_data.lambdas == lambda, 1);
if isempty(lambda_idx)
    error('Lambda %d no encontrado en el dataset.', lambda);
end

topology = loaded_data.topologies_data{lambda_idx, trial_idx};
end
