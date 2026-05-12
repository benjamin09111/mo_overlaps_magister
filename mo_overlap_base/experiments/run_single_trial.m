function trial = run_single_trial(N, lambda, n, k_max)
% Ejecuta 1 prueba completa para un lambda y n dados

Lambda = lambda / N;
psi = Lambda;

% Topología
G = generate_random_topology(N, Lambda);

% Gateway
gateway = select_gateway_by_betweenness(G);

% Sensores
sensors = select_sensors(N, gateway, n);

% SP
sp_paths = run_shortest_path_routing(G, sensors, gateway);
omega_sp = compute_total_overlaps(sp_paths, gateway);
avg_hops_sp = compute_average_hops(sp_paths);

% MO
[mo_paths, omega_mo] = run_minimal_overlap_routing(G, sp_paths, sensors, gateway, psi, k_max);
avg_hops_mo = compute_average_hops(mo_paths);

% Salida
trial.omega_sp = omega_sp;
trial.omega_mo = omega_mo;
trial.avg_hops_sp = avg_hops_sp;
trial.avg_hops_mo = avg_hops_mo;
end