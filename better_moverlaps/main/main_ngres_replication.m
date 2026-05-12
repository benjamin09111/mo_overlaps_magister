%% main_ngres_replication.m
% Réplica NG-RES 2021 completa:
% SP vs MO

clear; clc; close all;

this_file = mfilename('fullpath');
this_dir = fileparts(this_file);
project_root = fileparts(this_dir);

addpath(genpath(project_root));

cfg = config_ngres();

fprintf('\n=========================================\n');
fprintf('NG-RES 2021 - FULL REPLICATION\n');
fprintf('=========================================\n');
fprintf('Project root: %s\n', project_root);
fprintf('N = %d\n', cfg.N);
fprintf('lambda = [%s]\n', num2str(cfg.lambdas));
fprintf('n range = [%s]\n', num2str(cfg.n_range));
fprintf('num_tests = %d\n', cfg.num_tests);
fprintf('H = %d\n', cfg.H);
fprintf('w = %d\n', cfg.w);
fprintf('use_topology_dataset = %d\n', cfg.use_topology_dataset);
fprintf('=========================================\n');

dataset_path = fullfile(project_root, 'dataset_topologies.dat');
if cfg.use_topology_dataset && ~isfile(dataset_path)
    fprintf('Generando dataset de topologias...\n');
    generate_topology_dataset(cfg);
end

% 1) Overlaps, hops, conflict, contention
results = run_experiment_suite_ngres(cfg);

% 2) Schedulability ratio
sched = run_experiment_suite_schedulability(cfg);

fprintf('\nGenerando gráficos...\n');

plot_overlaps_results(results, cfg);
plot_hops_results(results, cfg);
plot_conflict_demand_results(results, cfg);
plot_contention_demand_results(results, cfg);
plot_sched_ratio_density_results(sched, cfg);
plot_sched_ratio_channels_results(sched, cfg);

fprintf('Listo.\n');
