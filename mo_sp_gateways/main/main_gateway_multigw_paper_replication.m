%% main_gateway_multigw_paper_replication.m
% Replica aislada del bloque multi-gateway k=1/3/5.
% Genera sched ratio, W.C. network demand, topologia y deviation por k.

clear; clc; close all;

this_file = mfilename('fullpath');
this_dir = fileparts(this_file);
project_root = fileparts(this_dir);

addpath(genpath(project_root));

cfg = config_gateway_multigw_paper();

run_experiments = true;
run_plots = true;
save_results = true;
regenerate_dataset = false;

fprintf('\n=========================================\n');
fprintf('GATEWAY MULTI-GATEWAY PAPER REPLICATION\n');
fprintf('=========================================\n');
fprintf('N = %d\n', cfg.N);
fprintf('density = %.3g\n', cfg.gateway_multigw_density);
fprintf('n range = [%s]\n', num2str(cfg.n_range));
fprintf('m = %d\n', cfg.gw_m_fixed);
fprintf('k gateways = [%s]\n', num2str(cfg.k_gateways));
fprintf('num_tests = %d\n', cfg.num_tests);
fprintf('methods = [%s]\n', strjoin(cfg.gateway_methods, ', '));
fprintf('baseline = %s\n', cfg.baseline_gateway_method);
fprintf('=========================================\n');

dataset_path = fullfile(project_root, cfg.gateway_multigw_dataset_name);
needs_dataset_regen = regenerate_dataset || ~isfile(dataset_path);

if ~needs_dataset_regen
    try
        loaded_dataset = load(dataset_path, '-mat');
        if ~isfield(loaded_dataset, 'K') || ~isfield(loaded_dataset, 'N') || ~isfield(loaded_dataset, 'density') || ...
                loaded_dataset.K ~= cfg.num_tests || ...
                loaded_dataset.N ~= cfg.N || ...
                abs(loaded_dataset.density - cfg.gateway_multigw_density) > 1e-12
            needs_dataset_regen = true;
        end
    catch
        needs_dataset_regen = true;
    end
end

if needs_dataset_regen
    fprintf('Generando dataset gateway multi-gateway...\n');
    generate_gateway_multigw_dataset(cfg);
    clear get_gateway_multigw_topology;
end

gw_multigw_results = struct();
if run_experiments
    gw_multigw_results = run_experiment_suite_gateway_multigw_paper(cfg);
end

if run_plots && ~isempty(fieldnames(gw_multigw_results))
    plot_gateway_multigw_sched_ratio(gw_multigw_results, cfg);
    plot_gateway_multigw_network_demand(gw_multigw_results, cfg);
    plot_gateway_multigw_topology_clusters(gw_multigw_results, cfg);
    plot_gateway_multigw_deviation_by_k(gw_multigw_results, cfg);
end

if save_results && ~isempty(fieldnames(gw_multigw_results))
    out_path = fullfile(project_root, 'results_gateway_multigw_paper.mat');
    save(out_path, 'cfg', 'gw_multigw_results');
    fprintf('Resultados guardados en %s\n', out_path);
end

fprintf('Listo.\n');
