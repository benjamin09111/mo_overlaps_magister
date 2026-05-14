function conflict = compute_multigateway_conflict_demand_window(flows, gateways, ell)
% Conflict demand para multiples gateways, excluyendo todos los gateways del overlap.

paths = flows.paths;
n = length(paths);
conflict = 0;
gateways = unique(gateways(:)');

for i = 1:n
    pi = setdiff(paths{i}, gateways, 'stable');
    for j = i+1:n
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
