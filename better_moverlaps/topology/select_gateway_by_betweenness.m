function gateway = select_gateway_by_betweenness(G)
% Gateway = nodo con máxima betweenness centrality
bc = centrality(G, 'betweenness');
[~, gateway] = max(bc);
end