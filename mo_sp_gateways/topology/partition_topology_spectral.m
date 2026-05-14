function clusters = partition_topology_spectral(G, k)
% Particiona la topologia usando spectral clustering con Laplacian normalizado.

N = numnodes(G);
if k <= 1
    clusters = ones(N, 1);
    return;
end

A = full(adjacency(G));
degrees = sum(A, 2);
degrees(degrees == 0) = eps;
D_inv_sqrt = diag(1 ./ sqrt(degrees));
L_sym = eye(N) - D_inv_sqrt * A * D_inv_sqrt;

[V, E] = eig(L_sym);
[~, order] = sort(diag(E), 'ascend');
embedding = V(:, order(1:k));
row_norm = sqrt(sum(embedding.^2, 2));
row_norm(row_norm == 0) = 1;
embedding = embedding ./ row_norm;

try
    clusters = kmeans(embedding, k, 'Replicates', 5, 'MaxIter', 200, 'Display', 'off');
catch
    clusters = deterministic_embedding_partition(embedding, k);
end

clusters = ensure_nonempty_clusters(clusters, embedding, k);
end

function clusters = deterministic_embedding_partition(embedding, k)
% Fallback simple si kmeans no esta disponible.
[~, order] = sort(embedding(:, 2), 'ascend');
clusters = ones(size(embedding, 1), 1);
edges = round(linspace(1, size(embedding, 1) + 1, k + 1));
for c = 1:k
    idx = order(edges(c):edges(c + 1) - 1);
    clusters(idx) = c;
end
end

function clusters = ensure_nonempty_clusters(clusters, embedding, k)
for c = 1:k
    if any(clusters == c)
        continue;
    end

    counts = zeros(k, 1);
    for j = 1:k
        counts(j) = sum(clusters == j);
    end
    [~, donor] = max(counts);
    donor_nodes = find(clusters == donor);
    donor_center = mean(embedding(donor_nodes, :), 1);
    distances = sum((embedding(donor_nodes, :) - donor_center).^2, 2);
    [~, move_idx] = max(distances);
    clusters(donor_nodes(move_idx)) = c;
end
end
