function plot_gateway_single_degree_random(results, cfg)
% Plots 1-3: Schedulability ratio: Degree vs Random por densidad.
% 3 subplots en fila. N=80, m=16, density=0.1/0.5/1.

fig = figure('Color', 'w', 'Position', [80, 80, 960, 340]);
x = results.n_range;
degree_idx = find(strcmp(results.gateway_methods, 'degree'), 1);
random_idx = find(strcmp(results.gateway_methods, 'random'), 1);

for d_idx = 1:length(results.densities)
    ax = subplot(1, length(results.densities), d_idx, 'Parent', fig);
    hold(ax, 'on'); grid(ax, 'on');
    setup_paper_axes(ax, 'n', 'Schedulability Ratio');

    y_degree = squeeze(results.ratio_sched_sp(degree_idx, d_idx, :));
    y_random = squeeze(results.ratio_sched_sp(random_idx, d_idx, :));

    plot(ax, x, y_degree, '-s', 'Color', [0 0 1], 'LineWidth', 2.0, ...
        'MarkerFaceColor', 'white', 'MarkerSize', 6);
    plot(ax, x, y_random, '--o', 'Color', [0 0 0], 'LineWidth', 1.2, ...
        'MarkerFaceColor', 'white', 'MarkerSize', 6);

    ax.XLim = [min(x), max(x)];
    ax.YLim = [0, 1.02];
    title(ax, sprintf('d = %.3g, m = %d, N = %d', ...
        results.densities(d_idx), results.m_fixed, results.N), ...
        'FontName', 'Times New Roman', 'FontSize', 10, 'FontWeight', 'bold');

    if d_idx == 1
        legend(ax, {'Degree', 'Random'}, 'Location', 'SouthWest', ...
            'FontSize', 8, 'FontName', 'Times New Roman', 'Box', 'on', ...
            'EdgeColor', [0.73 0.73 0.73]);
    end
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
