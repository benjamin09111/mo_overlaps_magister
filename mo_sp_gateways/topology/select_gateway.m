function gateway = select_gateway(G, method)
% Selecciona gateway segun una metrica de centralidad.
% Metodos soportados: betweenness, degree, eigenvector, closeness, random.

if nargin < 2 || isempty(method)
    method = 'betweenness';
end

method = lower(char(method));

switch method
    case 'betweenness'
        scores = centrality(G, 'betweenness');

    case 'degree'
        scores = centrality(G, 'degree');

    case 'eigenvector'
        scores = centrality(G, 'eigenvector');

    case 'closeness'
        scores = centrality(G, 'closeness');

    case 'random'
        gateway = randi(numnodes(G));
        return;

    otherwise
        error('Metodo de gateway no soportado: %s', method);
end

scores(~isfinite(scores)) = -inf;
[~, gateway] = max(scores);
end
