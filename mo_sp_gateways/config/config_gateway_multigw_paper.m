function cfg = config_gateway_multigw_paper()
% Configuracion para replicar el bloque multi-gateway k=1/3/5.

cfg = config_ngres();

cfg.N = 75;
cfg.gateway_multigw_density = 0.1;
cfg.n_range = 1:30;
cfg.num_tests = 100;
cfg.m_fixed = 16;
cfg.gw_m_fixed = 16;
cfg.k_gateways = [1, 3, 5];

cfg.gateway_methods = {'degree', 'random', 'betweenness', 'closeness', 'eigenvector'};
cfg.baseline_gateway_method = 'degree';
cfg.deviation_methods = {'betweenness', 'closeness', 'eigenvector'};

cfg.network_demand_n = 25;
cfg.network_demand_time_grid = 0:80:1280;
cfg.network_demand_scale = 0.06;
cfg.topology_plot_k = 3;
cfg.topology_plot_method = 'degree';

cfg.k_max = 100;
cfg.w = 2;
cfg.eta_min = 4;
cfg.eta_max = 7;
cfg.period_values = 2.^(cfg.eta_min:cfg.eta_max);
cfg.H = 128;
cfg.use_implicit_deadlines = true;
cfg.conflict_pair_mode = 'unique';

cfg.gateway_multigw_dataset_name = 'dataset_gateway_multigw_paper.dat';
cfg.gateway_multigw_rng_seed = 3501;
cfg.random_gateway_rng_seed = 11927;
end
