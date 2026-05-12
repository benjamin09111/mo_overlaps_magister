function sensors = select_sensors(G, gateway, n)
% Selecciona n sensores excluyendo gateway y sus vecinos directos.
% En la referencia, esos vecinos se interpretan como APs; los sensores
% deben ser field devices, no nodos adyacentes al gateway.

N = numnodes(G);
neighbors_gw = neighbors(G, gateway);
all_nodes = 1:N;
potential = setdiff(all_nodes, [gateway; neighbors_gw(:)]);

% Si la restriccion deja pocos candidatos, relajar a excluir solo gateway.
if numel(potential) < n
    potential = setdiff(all_nodes, gateway);
end

idx = randperm(numel(potential), n);
sensors = potential(idx);
end
