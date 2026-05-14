function plot_gateway_multigw_sched_ratio(results, cfg)
% Figura tipo paper: schedulability ratio para Random y Degree con k=1/3/5.

fig = figure('Color', 'w', 'Position', [100, 100, 650, 400]);
ax = axes('Parent', fig);
hold(ax, 'on'); grid(ax, 'on');
setup_axes(ax, 'Number of flows (n)', 'Schedulability Ratio');

x = results.n_range;
degree_idx = find(strcmp(results.gateway_methods, 'degree'), 1);
random_idx = find(strcmp(results.gateway_methods, 'random'), 1);
colors = paper_colors();

for k_idx = 1:length(results.k_gateways)
    y_random = squeeze(results.ratio_sched_sp(random_idx, k_idx, :));
    plot(ax, x, y_random, ':', 'Color', colors{k_idx}, 'LineWidth', 1.0);
end

for k_idx = 1:length(results.k_gateways)
    y_degree = squeeze(results.ratio_sched_sp(degree_idx, k_idx, :));
    if results.k_gateways(k_idx) == 1
        style = '--';
    elseif results.k_gateways(k_idx) == 3
        style = '-.';
    else
        style = '-';
    end
    plot(ax, x, y_degree, style, 'Color', colors{k_idx}, 'LineWidth', 2.0);
end

ax.XLim = [min(x), max(x)];
ax.YLim = [0, 1.02];
text(ax, 0.10, 0.92, sprintf('d = %.1f, m = %d, N = %d', results.density, results.m_fixed, results.N), ...
    'Units', 'normalized', 'FontName', 'Times New Roman', 'FontSize', 10, 'FontWeight', 'bold');
text(ax, 0.02, 0.18, 'Random', 'Units', 'normalized', 'FontName', 'Times New Roman', 'FontSize', 8);
text(ax, 0.83, 0.83, 'Degree', 'Units', 'normalized', 'FontName', 'Times New Roman', 'FontSize', 8);

legend_labels = build_k_labels(results.k_gateways);
legend(ax, legend_labels, 'Location', 'South', 'FontSize', 8, ...
    'FontName', 'Times New Roman', 'Box', 'on', 'EdgeColor', [0.73 0.73 0.73]);

save_gateway_paper_figure(fig, 'gateway_multigw_sched_ratio');
end

function labels = build_k_labels(k_values)
labels = cell(1, 2 * length(k_values));
idx = 1;
for k_idx = 1:length(k_values)
    labels{idx} = sprintf('Random k=%d', k_values(k_idx));
    idx = idx + 1;
end
for k_idx = 1:length(k_values)
    labels{idx} = sprintf('Degree k=%d', k_values(k_idx));
    idx = idx + 1;
end
end

function colors = paper_colors()
colors = {[0.929 0.694 0.125], [0.850 0.325 0.098], [0.000 0.447 0.741]};
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
