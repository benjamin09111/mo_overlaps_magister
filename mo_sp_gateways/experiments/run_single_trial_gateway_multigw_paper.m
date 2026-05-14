function trial = run_single_trial_gateway_multigw_paper(cfg, n, k_gateways, trial_idx, gateway_method, clusters, gateways, sensors, T_common)
% Trial multi-gateway para un metodo de seleccion dentro de clusters.

topo = get_gateway_multigw_topology(cfg, trial_idx);
G = topo.Graph;

if nargin < 6 || isempty(clusters)
    clusters = partition_topology_spectral(G, k_gateways);
end

if nargin < 7 || isempty(gateways)
    gateways = select_cluster_gateways(G, clusters, gateway_method);
end

if nargin < 8 || isempty(sensors)
    sensors = select_sensors_multigateway_common(G, gateways, n);
end

if nargin < 9 || isempty(T_common)
    T_common = generate_periods_harmonic(n, cfg);
end

[paths, assigned_gateways] = run_multigateway_shortest_path_routing(G, sensors, clusters, gateways);
flows = build_flow_set(paths, cfg, T_common);
flows.assigned_gateways = assigned_gateways(:);

[sched_sp, sched_details] = compute_multigateway_schedulability_status(flows, gateways, cfg.gw_m_fixed, cfg.H);
demand_curve = compute_multigateway_network_demand_curve(flows, gateways, cfg.gw_m_fixed, cfg.network_demand_time_grid);

trial = struct();
trial.gateway_method = char(gateway_method);
trial.k_gateways = k_gateways;
trial.clusters = clusters;
trial.gateways = gateways;
trial.sensors = sensors;
trial.assigned_gateways = assigned_gateways;
trial.sched_sp = sched_sp;
trial.sched_details = sched_details;
trial.demand_curve = demand_curve;
trial.avg_hops_sp = compute_average_hops(paths);
end

function sensors = select_sensors_multigateway_common(G, gateways, n)
N = numnodes(G);
all_nodes = 1:N;
excluded = unique(gateways(:));

for idx = 1:length(gateways)
    excluded = unique([excluded; neighbors(G, gateways(idx))]); %#ok<AGROW>
end

potential = setdiff(all_nodes, excluded(:)');
if numel(potential) < n
    potential = setdiff(all_nodes, unique(gateways(:))');
end

if numel(potential) < n
    error('No hay suficientes sensores para multi-gateway. n=%d, disponibles=%d', n, numel(potential));
end

idx = randperm(numel(potential), n);
sensors = potential(idx);
end
