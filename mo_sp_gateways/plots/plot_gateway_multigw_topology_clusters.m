function plot_gateway_multigw_topology_clusters(results, cfg)
% Plot 12: Topologia con clusters y gateways para k=3, metodo Degree.
% Muestra el grado real de cada gateway en la topologia generada.

if ~isfield(results, 'sample_topology') || ~isfield(results.sample_topology, 'Graph')
    warning('No hay sample_topology disponible para graficar.');
    return;
end

G = results.sample_topology.Graph;
clusters = results.sample_topology.clusters;
gateways = results.sample_topology.gateways;

fig = figure('Color', 'w', 'Position', [160, 160, 680, 420]);
ax = axes('Parent', fig);
p = plot(ax, G, 'Layout', 'force');
p.NodeCData = clusters;
p.MarkerSize = 4;
p.EdgeAlpha = 0.25;
p.LineWidth = 0.6;
colormap(ax, cluster_colors());
axis(ax, 'off');
hold(ax, 'on');

gw_colors = {[0.635 0.078 0.184], [0 0.447 0.741], [0.850 0.325 0.098]};
gw_method = results.sample_topology.method;
for idx = 1:length(gateways)
    gw_node = gateways(idx);
    gw_degree = degree(G, gw_node);
    color = gw_colors{min(idx, length(gw_colors))};
    x = p.XData(gw_node);
    y = p.YData(gw_node);
    plot(ax, x, y, 'p', 'MarkerSize', 15, 'MarkerFaceColor', color, ...
        'MarkerEdgeColor', 'k', 'LineWidth', 1.0);
    text(ax, x, y + 0.08 * max(p.YData), sprintf('GW%d\nDegree=%d', idx, gw_degree), ...
        'FontName', 'Times New Roman', 'FontSize', 10, 'FontWeight', 'bold', ...
        'Color', color, 'BackgroundColor', 'w', 'Margin', 1, ...
        'HorizontalAlignment', 'center');
end

title(ax, sprintf('%s, k=%d, d=%.1f, m=%d, N=%d', ...
    gw_method, results.sample_topology.k_gateways, results.density, results.m_fixed, results.N), ...
    'FontName', 'Times New Roman', 'FontSize', 10, 'FontWeight', 'bold', ...
    'Interpreter', 'none');

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
