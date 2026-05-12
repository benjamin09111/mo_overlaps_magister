function conflict_demand = compute_conflict_demand(flows, gateway, H)
% Calcula una aproximación del worst-case conflict demand en el hyperperiod H
%
% Basado en la idea del paper:
% la componente de transmission conflicts depende de los overlaps Delta(i,j)
% y del número de activaciones de los flujos en el intervalo.
%
% Usamos:
%   conflict_demand = sum_{i<j} Delta(i,j) * max(H/T_i, H/T_j)
%
% Esta aproximación mantiene la lógica del documento:
% más overlaps => más conflict demand
% más activaciones => más conflict demand

paths = flows.paths;
T = flows.T(:);

n = flows.n;
Delta = compute_pairwise_overlap_matrix(paths, gateway);

conflict_demand = 0;

for i = 1:n
    for j = i+1:n
        overlap_ij = Delta(i, j);

        if overlap_ij > 0
            num_i = ceil(H / T(i));
            num_j = ceil(H / T(j));

            conflict_demand = conflict_demand + overlap_ij * max(num_i, num_j);
        end
    end
end
end