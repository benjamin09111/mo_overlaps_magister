%% main_replot_gateway_deviation_pp.m
% Regenera solo los plots de gateway deviation usando puntos porcentuales.
% Util para reinterpretar resultados ya guardados sin repetir experimentos.

clear; clc; close all;

this_file = mfilename('fullpath');
this_dir = fileparts(this_file);
project_root = fileparts(this_dir);

addpath(genpath(project_root));

results_path = fullfile(project_root, 'results_control.mat');
if ~isfile(results_path)
    error('No se encontro results_control.mat en %s', project_root);
end

loaded = load(results_path, '-mat');
if ~isfield(loaded, 'gw_results') || isempty(fieldnames(loaded.gw_results))
    error('results_control.mat no contiene gw_results valido.');
end

if isfield(loaded, 'cfg')
    cfg = loaded.cfg;
else
    cfg = config_ngres();
end

gw_results = loaded.gw_results;
plot_gateway_centrality_deviation(gw_results, cfg);
plot_gateway_mo_improvement(gw_results, cfg);

fprintf('Plots gateway deviation regenerados con puntos porcentuales.\n');
