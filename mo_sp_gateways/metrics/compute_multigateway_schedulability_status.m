function [is_schedulable, details] = compute_multigateway_schedulability_status(flows, gateways, m, H)
% EDF multi-window para multiples gateways.
% Cada gateway/cluster se evalua por separado; el sistema falla si algun
% cluster supera la ventana ell.

windows = generate_sched_windows(flows, H);

is_schedulable = true;
details = struct();
details.windows = windows;
details.contention = zeros(size(windows));
details.conflict = zeros(size(windows));
details.total_demand = zeros(size(windows));
details.slack = zeros(size(windows));
details.failing_window = [];
details.failing_gateway = [];

for w_idx = 1:length(windows)
    ell = windows(w_idx);

    [total_demand, contention, conflict, worst_gateway] = compute_worst_gateway_demand(flows, gateways, m, ell);

    details.contention(w_idx) = contention;
    details.conflict(w_idx) = conflict;
    details.total_demand(w_idx) = total_demand;
    details.slack(w_idx) = ell - total_demand;

    if total_demand > ell
        is_schedulable = false;
        details.failing_window = ell;
        details.failing_gateway = worst_gateway;
        return;
    end
end

if ~isempty(windows)
    [~, best_idx] = min(details.slack);
    details.worst_window = windows(best_idx);
    details.worst_slack = details.slack(best_idx);
else
    details.worst_window = [];
    details.worst_slack = [];
end
end

function [worst_total, worst_contention, worst_conflict, worst_gateway] = compute_worst_gateway_demand(flows, gateways, m, ell)
gateways = unique(gateways(:)');
if isfield(flows, 'assigned_gateways')
    assigned_gateways = flows.assigned_gateways(:);
else
    assigned_gateways = repmat(gateways(1), flows.n, 1);
end

worst_total = 0;
worst_contention = 0;
worst_conflict = 0;
worst_gateway = gateways(1);

for g_idx = 1:length(gateways)
    gateway = gateways(g_idx);
    flow_idx = find(assigned_gateways == gateway);
    if isempty(flow_idx)
        continue;
    end

    subflows = subset_flows(flows, flow_idx);
    contention = compute_contention_demand_window(subflows, m, ell);
    conflict = compute_multigateway_conflict_demand_window(subflows, gateway, ell);
    total = contention + conflict;

    if total > worst_total
        worst_total = total;
        worst_contention = contention;
        worst_conflict = conflict;
        worst_gateway = gateway;
    end
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
