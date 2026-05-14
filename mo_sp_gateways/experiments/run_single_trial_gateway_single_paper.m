function trial = run_single_trial_gateway_single_paper(cfg, density, n, m, trial_idx, gateway_method, sensors, T_common, gateway_override)
% Trial single-gateway para replicar Degree/Random/Deviation del paper.
% Usa SP routing porque el bloque objetivo compara metodos de gateway, no MO.

topo = get_gateway_paper_topology(cfg, density, trial_idx);
G = topo.Graph;

if nargin >= 9 && ~isempty(gateway_override)
    gateway = gateway_override;
else
    gateway = select_gateway(G, gateway_method);
end

if nargin < 7 || isempty(sensors)
    sensors = select_sensors(G, gateway, n);
end

if nargin < 8 || isempty(T_common)
    T_common = generate_periods_harmonic(n, cfg);
end

sp_paths = run_shortest_path_routing(G, sensors, gateway);
sp_flows = build_flow_set(sp_paths, cfg, T_common);

[sched_sp, sched_details] = compute_schedulability_status(sp_flows, gateway, m, cfg.H);

trial = struct();
trial.gateway_method = char(gateway_method);
trial.gateway = gateway;
trial.sensors = sensors;
trial.sched_sp = sched_sp;
trial.sched_details = sched_details;
trial.avg_hops_sp = compute_average_hops(sp_paths);
trial.omega_sp = compute_total_overlaps(sp_paths, gateway);
trial.conflict_sp = compute_conflict_demand(sp_flows, gateway, cfg.H);
trial.contention_sp = compute_contention_demand(sp_flows, m, cfg.H);
end
