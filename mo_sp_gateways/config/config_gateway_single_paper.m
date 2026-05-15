function cfg = config_gateway_single_paper()
% Configuracion para replicar el bloque single-gateway centrality paper.
% Objetivo: N=80, density={0.1,0.5,1}, m=16, Degree vs Random + Deviation.

cfg = config_ngres();

cfg.N = 80;
cfg.gateway_paper_densities = [0.1, 0.5, 1.0];
cfg.gateway_density_mode = 'calibrated_probability';
cfg.gateway_density_edge_probabilities = [0.025, 0.045, 0.065];
cfg.n_range = 1:10;
cfg.num_tests = 100;
cfg.m_fixed = 16;
cfg.gw_m_fixed = 16;

cfg.gateway_methods = {'degree', 'random', 'betweenness', 'closeness', 'eigenvector'};
cfg.baseline_gateway_method = 'degree';
cfg.deviation_methods = {'betweenness', 'closeness', 'eigenvector'};
cfg.deviation_mode = 'absolute';

cfg.k_max = 100;
cfg.w = 4;
cfg.eta_min = 4;
cfg.eta_max = 7;
cfg.period_values = 2.^(cfg.eta_min:cfg.eta_max);
cfg.H = 128;
cfg.use_implicit_deadlines = true;
cfg.conflict_pair_mode = 'paper_double';

cfg.use_gateway_paper_dataset = true;
cfg.gateway_paper_dataset_name = 'dataset_gateway_single_paper_calibrated.dat';
cfg.gateway_paper_rng_seed = 2401;
cfg.random_gateway_rng_seed = 9173;
end
