function conflict = compute_multigateway_conflict_demand_window(flows, gateways, ell)
% Conflict demand para multiples gateways.
% Solo considera conflictos entre flujos asignados al mismo gateway/cluster.

paths = flows.paths;
n = length(paths);
conflict = 0;
gateways = unique(gateways(:)');
if isfield(flows, 'assigned_gateways')
    assigned_gateways = flows.assigned_gateways(:);
else
    assigned_gateways = repmat(gateways(1), n, 1);
end

for i = 1:n
    pi = setdiff(paths{i}, gateways, 'stable');
    for j = i+1:n
        if assigned_gateways(i) ~= assigned_gateways(j)
            continue;
        end

        pj = setdiff(paths{j}, gateways, 'stable');
        delta = numel(intersect(pi, pj));
        if delta == 0
            continue;
        end

        activations = max(ceil(ell / flows.T(i)), ceil(ell / flows.T(j)));
        if isfield(flows, 'conflict_pair_mode') && strcmp(flows.conflict_pair_mode, 'paper_double')
            conflict = conflict + 2 * delta * activations;
        else
            conflict = conflict + delta * activations;
        end
    end
end
end
