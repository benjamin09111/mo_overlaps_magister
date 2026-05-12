function trial = run_single_trial_routing(cfg, lambda, n)
% Ejecuta 1 prueba de routing SP vs MO
% Replica las métricas base:
% - overlaps
% - average hops

Lambda = lambda / cfg.N;
psi = Lambda;

% 1) Topología
G = generate_random_topology(cfg.N, Lambda);

% 2) Gateway
gateway = select_gateway_by_betweenness(G);

% 3) Sensores
sensors = select_sensors(cfg.N, gateway, n);

% 4) SP
sp_paths = run_shortest_path_routing(G, sensors, gateway);
omega_sp = compute_total_overlaps(sp_paths, gateway);
avg_hops_sp = compute_average_hops(sp_paths);

% 5) MO
[mo_paths, omega_mo] = run_minimal_overlap_routing(G, sp_paths, sensors, gateway, psi, cfg.k_max);
avg_hops_mo = compute_average_hops(mo_paths);

% 6) Guardar resultados
trial.omega_sp = omega_sp;
trial.omega_mo = omega_mo;
trial.avg_hops_sp = avg_hops_sp;
trial.avg_hops_mo = avg_hops_mo;
end