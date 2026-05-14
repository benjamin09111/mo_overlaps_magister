function demand_curve = compute_multigateway_network_demand_curve(flows, gateways, m, time_grid)
% Calcula contention + conflict_multi en cada punto temporal.

demand_curve = zeros(size(time_grid));
for idx = 1:length(time_grid)
    ell = time_grid(idx);
    contention = compute_contention_demand_window(flows, m, ell);
    conflict = compute_multigateway_conflict_demand_window(flows, gateways, ell);
    demand_curve(idx) = contention + conflict;
end
end
