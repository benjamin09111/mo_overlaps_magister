function plot_gateway_multigw_sched_ratio(results, cfg)
% Plot 4: Schedulability ratio para Random y Degree con k=1/3/5.
% Una sola figura con 6 curvas. N=75, d=0.1, m=16.

fig = figure('Color', 'w', 'Position', [100, 100, 680, 420]);
ax = axes('Parent', fig);
hold(ax, 'on'); grid(ax, 'on');
setup_axes(ax, 'Number of flows (n)', 'Schedulability Ratio');

x = results.n_range;
degree_idx = find(strcmp(results.gateway_methods, 'degree'), 1);
random_idx = find(strcmp(results.gateway_methods, 'random'), 1);

degree_colors = {[0 0.447 0.741], [0.850 0.325 0.098], [0.929 0.694 0.125]};
random_colors = {[0 0.447 0.741], [0.850 0.325 0.098], [0.929 0.694 0.125]};
degree_styles = {'-', '-.', '--'};

for k_idx = 1:length(results.k_gateways)
    y_random = squeeze(results.ratio_sched_sp(random_idx, k_idx, :));
    plot(ax, x, y_random, ':', 'Color', random_colors{k_idx}, 'LineWidth', 1.0);
end

for k_idx = 1:length(results.k_gateways)
    y_degree = squeeze(results.ratio_sched_sp(degree_idx, k_idx, :));
    plot(ax, x, y_degree, degree_styles{k_idx}, 'Color', degree_colors{k_idx}, 'LineWidth', 2.0);
end

ax.XLim = [min(x), max(x)];
ax.YLim = [0, 1.02];
text(ax, 0.05, 0.92, sprintf('d = %.1f, m = %d, N = %d', results.density, results.m_fixed, results.N), ...
    'Units', 'normalized', 'FontName', 'Times New Roman', 'FontSize', 11, 'FontWeight', 'bold');
text(ax, 0.02, 0.18, 'Random', 'Units', 'normalized', 'FontName', 'Times New Roman', 'FontSize', 8);
text(ax, 0.70, 0.83, 'Degree', 'Units', 'normalized', 'FontName', 'Times New Roman', 'FontSize', 8);

legend_labels = build_k_labels(results.k_gateways);
legend(ax, legend_labels, 'Location', 'SouthEast', 'FontSize', 7, ...
    'FontName', 'Times New Roman', 'Box', 'on', 'EdgeColor', [0.73 0.73 0.73]);

save_gateway_paper_figure(fig, 'gateway_multigw_sched_ratio');
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
