function trial = run_single_trial_mo_vs_moaco(cfg, lambda, n)
% Ejecuta una prueba completa para comparar MO vs MO+ACO

Lambda = lambda / cfg.N;
psi = Lambda;

% 1) Topología
G = generate_random_topology(cfg.N, Lambda);

% 2) Gateway
gateway = select_gateway_by_betweenness(G);

% 3) Sensores
sensors = select_sensors(cfg.N, gateway, n);

% 4) SP inicial
sp_paths = run_shortest_path_routing(G, sensors, gateway);

% 5) MO
[mo_paths, omega_mo] = run_minimal_overlap_routing(G, sp_paths, sensors, gateway, psi, cfg.k_max);
avg_hops_mo = compute_average_hops(mo_paths);

% 6) MO + ACO
[moaco_paths, omega_moaco] = run_mo_aco_routing(G, mo_paths, sensors, gateway, cfg);
avg_hops_moaco = compute_average_hops(moaco_paths);

trial.omega_mo = omega_mo;
trial.omega_moaco = omega_moaco;
trial.avg_hops_mo = avg_hops_mo;
trial.avg_hops_moaco = avg_hops_moaco;
end