function trial = run_single_trial_ngres(cfg, lambda, n, m)
% Trial completo SP vs MO:
% overlaps, hops, conflict, contention, schedulability

Lambda = lambda / cfg.N;
psi = Lambda;

G = generate_random_topology(cfg.N, Lambda);
gateway = select_gateway_by_betweenness(G);
sensors = select_sensors(cfg.N, gateway, n);

% Periodos iguales para SP y MO
T_common = generate_periods_harmonic(n, cfg);

% SP
sp_paths = run_shortest_path_routing(G, sensors, gateway);
sp_flows = build_flow_set(sp_paths, cfg, T_common);

omega_sp = compute_total_overlaps(sp_paths, gateway);
avg_hops_sp = compute_average_hops(sp_paths);
conflict_sp = compute_conflict_demand(sp_flows, gateway, cfg.H);
contention_sp = compute_contention_demand(sp_flows, m, cfg.H);
sched_sp = compute_schedulability_status(sp_flows, gateway, m, cfg.H);

% MO
[mo_paths, omega_mo] = run_minimal_overlap_routing(G, sp_paths, sensors, gateway, psi, cfg.k_max);
mo_flows = build_flow_set(mo_paths, cfg, T_common);

avg_hops_mo = compute_average_hops(mo_paths);
conflict_mo = compute_conflict_demand(mo_flows, gateway, cfg.H);
contention_mo = compute_contention_demand(mo_flows, m, cfg.H);
sched_mo = compute_schedulability_status(mo_flows, gateway, m, cfg.H);

trial.omega_sp = omega_sp;
trial.omega_mo = omega_mo;

trial.avg_hops_sp = avg_hops_sp;
trial.avg_hops_mo = avg_hops_mo;

trial.conflict_sp = conflict_sp;
trial.conflict_mo = conflict_mo;

trial.contention_sp = contention_sp;
trial.contention_mo = contention_mo;

trial.sched_sp = sched_sp;
trial.sched_mo = sched_mo;
end