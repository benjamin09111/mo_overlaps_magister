function demand_curve = compute_multigateway_network_demand_curve(flows, gateways, m, time_grid)
% Calcula la peor demanda por gateway/cluster en cada punto temporal.

demand_curve = zeros(size(time_grid));
for idx = 1:length(time_grid)
    ell = time_grid(idx);
    demand_curve(idx) = compute_worst_gateway_demand(flows, gateways, m, ell);
end
end

function worst_total = compute_worst_gateway_demand(flows, gateways, m, ell)
gateways = unique(gateways(:)');
if isfield(flows, 'assigned_gateways')
    assigned_gateways = flows.assigned_gateways(:);
else
    assigned_gateways = repmat(gateways(1), flows.n, 1);
end

worst_total = 0;
for g_idx = 1:length(gateways)
    gateway = gateways(g_idx);
    flow_idx = find(assigned_gateways == gateway);
    if isempty(flow_idx)
        continue;
    end

    subflows = subset_flows(flows, flow_idx);
    contention = compute_contention_demand_window(subflows, m, ell);
    conflict = compute_multigateway_conflict_demand_window(subflows, gateway, ell);
    worst_total = max(worst_total, contention + conflict);
end
end

function subflows = subset_flows(flows, idx)
subflows = flows;
subflows.n = length(idx);
subflows.C = flows.C(idx);
subflows.T = flows.T(idx);
subflows.D = flows.D(idx);
if isfield(flows, 'phi')
    subflows.phi = flows.phi(idx);
end
subflows.paths = flows.paths(idx);
if isfield(flows, 'assigned_gateways')
    subflows.assigned_gateways = flows.assigned_gateways(idx);
end
end
