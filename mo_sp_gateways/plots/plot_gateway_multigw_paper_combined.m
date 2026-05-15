function plot_gateway_multigw_paper_combined(results, cfg)
% Figura combinada estilo paper: sched, demand, topology y deviations k=1/3/5.

fig = figure('Color', 'w', 'Position', [40, 80, 1500, 560]);

plot_sched_subplot(subplot(2, 3, 1, 'Parent', fig), results);
plot_demand_subplot(subplot(2, 3, 2, 'Parent', fig), results);
plot_topology_subplot(subplot(2, 3, 3, 'Parent', fig), results);

for k_idx = 1:length(results.k_gateways)
    plot_deviation_subplot(subplot(2, 3, 3 + k_idx, 'Parent', fig), results, k_idx);
end

save_gateway_paper_figure(fig, 'gateway_multigw_paper_combined');
end

function plot_sched_subplot(ax, results)
hold(ax, 'on'); grid(ax, 'on');
setup_axes(ax, 'Number of flows (n)', 'Schedulability Ratio');
x = results.n_range;
degree_idx = find(strcmp(results.gateway_methods, 'degree'), 1);
random_idx = find(strcmp(results.gateway_methods, 'random'), 1);
colors = paper_k_colors();
styles = {'--', '-.', '-'};

for k_idx = 1:length(results.k_gateways)
    y = squeeze(results.ratio_sched_sp(random_idx, k_idx, :));
    plot(ax, x, y, ':', 'Color', colors{k_idx}, 'LineWidth', 1.0);
end
for k_idx = 1:length(results.k_gateways)
    y = squeeze(results.ratio_sched_sp(degree_idx, k_idx, :));
    plot(ax, x, y, styles{k_idx}, 'Color', colors{k_idx}, 'LineWidth', 2.0);
end
ax.XLim = [min(x), max(x)];
ax.YLim = [0, 1.02];
title(ax, sprintf('d = %.1f, m = %d, N = %d', results.density, results.m_fixed, results.N), ...
    'FontName', 'Times New Roman', 'FontSize', 10, 'FontWeight', 'bold');
legend(ax, build_k_labels(results.k_gateways), 'Location', 'SouthEast', ...
    'FontSize', 7, 'FontName', 'Times New Roman', 'Box', 'on');
end

function plot_demand_subplot(ax, results)
hold(ax, 'on'); grid(ax, 'on');
setup_axes(ax, 'Time (ms)', 'W.C. Network demand (ms)');
x = results.time_grid;
degree_idx = find(strcmp(results.gateway_methods, 'degree'), 1);
random_idx = find(strcmp(results.gateway_methods, 'random'), 1);
colors = paper_k_colors();
styles = {'--', '-.', '-'};
scale = 1;
if isfield(results, 'network_demand_scale')
    scale = results.network_demand_scale;
end
for k_idx = 1:length(results.k_gateways)
    y = scale * squeeze(results.mean_demand_curve(random_idx, k_idx, :));
    stairs(ax, x, y, ':', 'Color', colors{k_idx}, 'LineWidth', 1.0);
end
for k_idx = 1:length(results.k_gateways)
    y = scale * squeeze(results.mean_demand_curve(degree_idx, k_idx, :));
    stairs(ax, x, y, styles{k_idx}, 'Color', colors{k_idx}, 'LineWidth', 2.0);
end
ax.XLim = [min(x), max(x)];
ax.YLim(1) = 0;
title(ax, sprintf('n=%d, d = %.1f, m = %d, N = %d', ...
    results.network_demand_n, results.density, results.m_fixed, results.N), ...
    'FontName', 'Times New Roman', 'FontSize', 10, 'FontWeight', 'bold');
legend(ax, build_k_labels(results.k_gateways), 'Location', 'NorthWest', ...
    'FontSize', 7, 'FontName', 'Times New Roman', 'Box', 'on');
end

function plot_topology_subplot(ax, results)
if ~isfield(results, 'sample_topology') || ~isfield(results.sample_topology, 'Graph')
    axis(ax, 'off');
    text(ax, 0.5, 0.5, 'No topology sample', 'HorizontalAlignment', 'center');
    return;
end
G = results.sample_topology.Graph;
clusters = results.sample_topology.clusters;
gateways = results.sample_topology.gateways;
p = plot(ax, G, 'Layout', 'force');
p.NodeLabel = {};
p.NodeCData = clusters;
p.MarkerSize = 4;
p.EdgeAlpha = 0.22;
p.LineWidth = 0.55;
colormap(ax, cluster_colors());
axis(ax, 'off');
hold(ax, 'on');
gw_colors = {[0.635 0.078 0.184], [0 0.447 0.741], [0.850 0.325 0.098]};
for idx = 1:length(gateways)
    gw = gateways(idx);
    color = gw_colors{min(idx, length(gw_colors))};
    x = p.XData(gw);
    y = p.YData(gw);
    plot(ax, x, y, 'p', 'MarkerSize', 12, 'MarkerFaceColor', color, 'MarkerEdgeColor', 'k');
    text(ax, x, y, sprintf('GW%d\nDegree=%d', idx, degree(G, gw)), ...
        'FontName', 'Times New Roman', 'FontSize', 9, 'FontWeight', 'bold', ...
        'Color', color, 'BackgroundColor', 'w', 'Margin', 1, 'HorizontalAlignment', 'center');
end
title(ax, sprintf('%s, k=%d', results.sample_topology.method, results.sample_topology.k_gateways), ...
    'FontName', 'Times New Roman', 'FontSize', 10, 'FontWeight', 'bold', 'Interpreter', 'none');
end

function plot_deviation_subplot(ax, results, k_idx)
hold(ax, 'on'); grid(ax, 'on');
setup_axes(ax, 'Number of flows (n)', 'Deviation');
x = results.n_range;
plot(ax, [min(x), max(x)], [0, 0], ':', 'Color', [0.35 0.35 0.35], 'LineWidth', 0.8);
styles = deviation_styles();
legend_labels = cell(1, length(results.deviation_methods));
for idx = 1:length(results.deviation_methods)
    method = results.deviation_methods{idx};
    method_idx = results.deviation_method_idx(idx);
    y = squeeze(results.dev_vs_degree_abs.sched_sp(method_idx, k_idx, :));
    st = styles.(method);
    plot(ax, x, y, st.LineStyle, 'Color', st.Color, 'LineWidth', 1.5, ...
        'Marker', st.Marker, 'MarkerFaceColor', 'white', 'MarkerSize', 4);
    legend_labels{idx} = st.Label;
end
ax.XLim = [min(x), max(x)];
title(ax, sprintf('k = %d, d = %.1f, m = %d, N = %d', ...
    results.k_gateways(k_idx), results.density, results.m_fixed, results.N), ...
    'FontName', 'Times New Roman', 'FontSize', 10, 'FontWeight', 'bold');
if k_idx == 1
    legend(ax, legend_labels, 'Location', 'NorthWest', 'FontSize', 8, ...
        'FontName', 'Times New Roman', 'Box', 'on');
end
end

function labels = build_k_labels(k_values)
labels = cell(1, 2 * length(k_values));
for idx = 1:length(k_values)
    labels{idx} = sprintf('Random k=%d', k_values(idx));
end
for idx = 1:length(k_values)
    labels{length(k_values) + idx} = sprintf('Degree k=%d', k_values(idx));
end
end

function colors = paper_k_colors()
colors = {[0.929 0.694 0.125], [0.850 0.325 0.098], [0 0.447 0.741]};
end

function styles = deviation_styles()
styles = struct();
styles.betweenness = struct('Label', 'BC', 'Color', [0 0.447 0.741], 'Marker', 's', 'LineStyle', '-');
styles.closeness = struct('Label', 'CC', 'Color', [0.850 0.325 0.098], 'Marker', '*', 'LineStyle', '-');
styles.eigenvector = struct('Label', 'EC', 'Color', [0.929 0.694 0.125], 'Marker', 'o', 'LineStyle', '-');
end

function cmap = cluster_colors()
cmap = [0.70 0.70 0.70; 0.30 0.75 0.93; 0.85 0.33 0.10; 0.49 0.18 0.56; 0.47 0.67 0.19];
end

function setup_axes(ax, xlabel_text, ylabel_text)
set(ax, 'FontName', 'Times New Roman', 'FontSize', 10);
ax.XLabel.String = xlabel_text;
ax.YLabel.String = ylabel_text;
ax.XGrid = 'on';
ax.YGrid = 'on';
ax.GridLineStyle = '--';
ax.GridAlpha = 0.6;
ax.GridColor = [0.82 0.82 0.82];
ax.Box = 'on';
end
