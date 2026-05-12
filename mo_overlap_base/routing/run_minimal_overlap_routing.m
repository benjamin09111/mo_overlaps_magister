function [best_paths, best_omega] = run_minimal_overlap_routing(G, initial_paths, sensors, gateway, psi, k_max)
% Implementa el algoritmo MO manteniendo la lógica del código original:
% - G_k acumulativo
% - penalización de aristas compartidas
% - recalcular shortestpath sobre G_k
% - quedarse con el mejor omega encontrado

n = length(sensors);

Phi = initial_paths;
G_k = G;
G_k.Edges.Weight = ones(numedges(G_k), 1);

best_paths = Phi;
best_omega = compute_total_overlaps(Phi, gateway);

for k = 1:k_max
    current_weights = G_k.Edges.Weight;

    for i = 1:n
        for j = i+1:n
            % nodos compartidos excluyendo gateway
            shared_nodes = intersect(Phi{i}(1:end-1), Phi{j}(1:end-1));
            delta_ij = length(shared_nodes);

            if delta_ij > 0
                % aristas de cada ruta
                edges_i = path_to_edges(Phi{i});
                edges_j = path_to_edges(Phi{j});

                % aristas comunes
                shared_edges = intersect(edges_i, edges_j, 'rows');

                if ~isempty(shared_edges)
                    for idx_edge = 1:size(shared_edges, 1)
                        u = shared_edges(idx_edge, 1);
                        v = shared_edges(idx_edge, 2);
                        e_id = findedge(G_k, u, v);

                        if e_id > 0
                            % Penalización acumulativa según Ec. 6
                            current_weights(e_id) = current_weights(e_id) + (delta_ij * psi);
                        end
                    end
                end
            end
        end
    end

    G_k.Edges.Weight = current_weights;

    % Recalcular Phi^k sobre el grafo modificado G^k
    new_paths = cell(n, 1);
    for i = 1:n
        new_paths{i} = shortestpath(G_k, sensors(i), gateway);
    end

    omega_k = compute_total_overlaps(new_paths, gateway);

    if omega_k < best_omega
        best_omega = omega_k;
        best_paths = new_paths;
    end

    Phi = new_paths;

    if omega_k == 0
        break;
    end
end
end