%% main_gateway_single_paper_replication.m
% Replica aislada del bloque single-gateway centrality paper.
% Genera Degree vs Random y Deviation BC/CC/EC para N=80, density={0.1,0.5,1}, m=16.

clear; clc; close all;

this_file = mfilename('fullpath');
this_dir = fileparts(this_file);
project_root = fileparts(this_dir);

addpath(genpath(project_root));

cfg = config_gateway_single_paper();

run_experiments = true;
run_plots = true;
save_results = true;
regenerate_dataset = false;

fprintf('\n=========================================\n');
fprintf('GATEWAY SINGLE-PAPER REPLICATION\n');
fprintf('=========================================\n');
fprintf('N = %d\n', cfg.N);
fprintf('density = [%s]\n', num2str(cfg.gateway_paper_densities));
fprintf('n range = [%s]\n', num2str(cfg.n_range));
fprintf('m = %d\n', cfg.gw_m_fixed);
fprintf('num_tests = %d\n', cfg.num_tests);
fprintf('methods = [%s]\n', strjoin(cfg.gateway_methods, ', '));
fprintf('baseline = %s\n', cfg.baseline_gateway_method);
fprintf('=========================================\n');

dataset_path = fullfile(project_root, cfg.gateway_paper_dataset_name);
needs_dataset_regen = regenerate_dataset || ~isfile(dataset_path);

if ~needs_dataset_regen
    try
        loaded_dataset = load(dataset_path, '-mat');
        if ~isfield(loaded_dataset, 'K') || ~isfield(loaded_dataset, 'N') || ~isfield(loaded_dataset, 'densities') || ...
                loaded_dataset.K ~= cfg.num_tests || ...
                loaded_dataset.N ~= cfg.N || ...
                ~isequal(loaded_dataset.densities, cfg.gateway_paper_densities)
            needs_dataset_regen = true;
        end
    catch
        needs_dataset_regen = true;
    end
end

if needs_dataset_regen
    fprintf('Generando dataset gateway single-paper...\n');
    generate_gateway_paper_dataset(cfg);
    clear get_gateway_paper_topology;
end

gw_single_results = struct();
if run_experiments
    gw_single_results = run_experiment_suite_gateway_single_paper(cfg);
end

if run_plots && ~isempty(fieldnames(gw_single_results))
    plot_gateway_single_degree_random(gw_single_results, cfg);
    plot_gateway_single_deviation_density(gw_single_results, cfg);
end

if save_results && ~isempty(fieldnames(gw_single_results))
    out_path = fullfile(project_root, 'results_gateway_single_paper.mat');
    save(out_path, 'cfg', 'gw_single_results');
    fprintf('Resultados guardados en %s\n', out_path);
end

fprintf('Listo.\n');
