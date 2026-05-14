function plot_gateway_multigw_topology_clusters(results, cfg)
% Figura tipo paper: topologia con clusters y gateways para k=3.

if ~isfield(results, 'sample_topology') || ~isfield(results.sample_topology, 'Graph')
    warning('No hay sample_topology disponible para graficar.');
    return;
end

G = results.sample_topology.Graph;
clusters = results.sample_topology.clusters;
gateways = results.sample_topology.gateways;

fig = figure('Color', 'w', 'Position', [160, 160, 650, 400]);
ax = axes('Parent', fig);
p = plot(ax, G, 'Layout', 'force');
p.NodeCData = clusters;
p.MarkerSize = 4;
p.EdgeAlpha = 0.25;
p.LineWidth = 0.6;
colormap(ax, cluster_colors());
axis(ax, 'off');
hold(ax, 'on');

gw_colors = {[0 0 0], [0 0.447 0.741], [0.850 0.325 0.098], [0.494 0.184 0.556], [0.466 0.674 0.188]};
for idx = 1:length(gateways)
    color = gw_colors{min(idx, length(gw_colors))};
    highlight(p, gateways(idx), 'Marker', 'p', 'MarkerSize', 10, 'NodeColor', color);
    x = p.XData(gateways(idx));
    y = p.YData(gateways(idx));
    text(ax, x, y, sprintf('  GW %d', idx), 'FontName', 'Times New Roman', ...
        'FontSize', 10, 'FontWeight', 'bold', 'Color', color);
end

title(ax, sprintf('k = %d, d = %.1f, m = %d, N = %d', ...
    results.sample_topology.k_gateways, results.density, results.m_fixed, results.N), ...
    'FontName', 'Times New Roman', 'FontSize', 10, 'FontWeight', 'bold');

save_gateway_paper_figure(fig, 'gateway_multigw_topology_clusters');
end

function cmap = cluster_colors()
cmap = [
    0.70 0.70 0.70
    0.30 0.75 0.93
    0.85 0.33 0.10
    0.49 0.18 0.56
    0.47 0.67 0.19
];
end
