function [paths, assigned_gateways] = run_multigateway_shortest_path_routing(G, sensors, clusters, gateways)
% Rutea cada sensor hacia el gateway de su cluster usando shortest path.

n = length(sensors);
paths = cell(n, 1);
assigned_gateways = zeros(n, 1);

for i = 1:n
    sensor = sensors(i);
    cluster_id = clusters(sensor);
    gateway = gateways(cluster_id);
    assigned_gateways(i) = gateway;
    paths{i} = shortestpath(G, sensor, gateway);
end
end
