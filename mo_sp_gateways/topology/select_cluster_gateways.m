function gateways = select_cluster_gateways(G, clusters, method)
% Selecciona un gateway por cluster usando una centralidad o random.

method = lower(char(method));
k = max(clusters);
gateways = zeros(k, 1);

if ~strcmp(method, 'random')
    scores = compute_gateway_scores(G, method);
else
    scores = [];
end

for c = 1:k
    nodes = find(clusters == c);
    if isempty(nodes)
        error('Cluster vacio detectado: %d', c);
    end

    if strcmp(method, 'random')
        gateways(c) = nodes(randi(numel(nodes)));
    else
        cluster_scores = scores(nodes);
        cluster_scores(~isfinite(cluster_scores)) = -inf;
        [~, idx] = max(cluster_scores);
        gateways(c) = nodes(idx);
    end
end
end

function scores = compute_gateway_scores(G, method)
switch method
    case 'betweenness'
        scores = centrality(G, 'betweenness');
    case 'degree'
        scores = centrality(G, 'degree');
    case 'eigenvector'
        scores = centrality(G, 'eigenvector');
    case 'closeness'
        scores = centrality(G, 'closeness');
    otherwise
        error('Metodo de gateway no soportado: %s', method);
end
end
