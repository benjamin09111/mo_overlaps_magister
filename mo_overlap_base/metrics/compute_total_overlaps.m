function omega = compute_total_overlaps(paths, gateway)
% Calcula Omega = suma de overlaps por nodos entre pares de rutas
% Excluye el gateway, tal como en tu código original

omega = 0;

for i = 1:length(paths)
    for j = i+1:length(paths)
        shared = intersect(paths{i}(1:end-1), paths{j}(1:end-1));
        omega = omega + length(shared);
    end
end
end