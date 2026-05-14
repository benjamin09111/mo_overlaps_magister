function plot_gateway_single_degree_random(results, cfg)
% Figura tipo paper: schedulability ratio para Degree vs Random por densidad.

fig = figure('Color', 'w', 'Position', [100, 100, 900, 320]);
x = results.n_range;
degree_idx = find(strcmp(results.gateway_methods, 'degree'), 1);
random_idx = find(strcmp(results.gateway_methods, 'random'), 1);

for d_idx = 1:length(results.densities)
    ax = subplot(1, length(results.densities), d_idx, 'Parent', fig);
    hold(ax, 'on'); grid(ax, 'on');
    setup_paper_axes(ax, 'Number of flows', 'Schedulability ratio');

    y_degree = squeeze(results.ratio_sched_sp(degree_idx, d_idx, :));
    y_random = squeeze(results.ratio_sched_sp(random_idx, d_idx, :));

    plot(ax, x, y_degree, '-s', 'Color', [0 0 1], 'LineWidth', 1.4, ...
        'MarkerFaceColor', 'white', 'MarkerSize', 4);
    plot(ax, x, y_random, '--o', 'Color', [0 0 0], 'LineWidth', 1.1, ...
        'MarkerFaceColor', 'white', 'MarkerSize', 4);

    ax.XLim = [min(x), max(x)];
    ax.YLim = [0, 1.02];
    title(ax, sprintf('density = %.3g, m = %d, N = %d', ...
        results.densities(d_idx), results.m_fixed, results.N), ...
        'FontName', 'Times New Roman', 'FontSize', 10, 'FontWeight', 'bold');

    legend(ax, {'Degree', 'Random'}, 'Location', 'SouthWest', ...
        'FontSize', 8, 'FontName', 'Times New Roman', 'Box', 'on', ...
        'EdgeColor', [0.73 0.73 0.73]);
end

save_gateway_paper_figure(fig, 'gateway_single_degree_random');
end

function setup_paper_axes(ax, xlabel_text, ylabel_text)
set(ax, 'FontName', 'Times New Roman', 'FontSize', 10);
ax.XLabel.String = xlabel_text;
ax.YLabel.String = ylabel_text;
ax.XGrid = 'on';
ax.YGrid = 'on';
ax.GridLineStyle = '--';
ax.GridAlpha = 0.6;
ax.GridColor = [0.82 0.82 0.82];
ax.TickLength = [0.02 0.02];
ax.Box = 'on';
end
