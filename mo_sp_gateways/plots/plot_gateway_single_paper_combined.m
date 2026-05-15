function plot_gateway_single_paper_combined(results, cfg)
% Figura combinada estilo paper: fila superior sched ratio, fila inferior deviation.

fig = figure('Color', 'w', 'Position', [40, 80, 1500, 560]);
x = results.n_range;
degree_idx = find(strcmp(results.gateway_methods, 'degree'), 1);
random_idx = find(strcmp(results.gateway_methods, 'random'), 1);
styles = deviation_styles();

for d_idx = 1:length(results.densities)
    ax = subplot(2, 3, d_idx, 'Parent', fig);
    hold(ax, 'on'); grid(ax, 'on');
    setup_axes(ax, 'Number of flows', 'Schedulability ratio');

    y_degree = squeeze(results.ratio_sched_sp(degree_idx, d_idx, :));
    y_random = squeeze(results.ratio_sched_sp(random_idx, d_idx, :));

    plot(ax, x, y_degree, '-s', 'Color', [0 0 1], 'LineWidth', 1.5, ...
        'MarkerFaceColor', 'white', 'MarkerSize', 4);
    plot(ax, x, y_random, '--o', 'Color', [0 0 0], 'LineWidth', 1.1, ...
        'MarkerFaceColor', 'white', 'MarkerSize', 4);

    ax.XLim = [min(x), max(x)];
    ax.YLim = [0, 1.02];
    title(ax, sprintf('density = %.3g, m = %d, N = %d', ...
        results.densities(d_idx), results.m_fixed, results.N), ...
        'FontName', 'Times New Roman', 'FontSize', 10, 'FontWeight', 'bold');

    if d_idx == 1
        legend(ax, {'Degree', 'Random'}, 'Location', 'SouthWest', ...
            'FontSize', 8, 'FontName', 'Times New Roman', 'Box', 'on');
    end
end

for d_idx = 1:length(results.densities)
    ax = subplot(2, 3, 3 + d_idx, 'Parent', fig);
    hold(ax, 'on'); grid(ax, 'on');
    setup_axes(ax, 'Number of flows', 'Deviation');
    plot(ax, [min(x), max(x)], [0, 0], ':', 'Color', [0.35 0.35 0.35], 'LineWidth', 0.8);

    legend_labels = cell(1, length(results.deviation_methods));
    for idx = 1:length(results.deviation_methods)
        method = results.deviation_methods{idx};
        method_idx = results.deviation_method_idx(idx);
        y = squeeze(results.dev_vs_degree_abs.sched_sp(method_idx, d_idx, :));
        st = styles.(method);
        plot(ax, x, y, st.LineStyle, 'Color', st.Color, 'LineWidth', 1.5, ...
            'Marker', st.Marker, 'MarkerFaceColor', 'white', 'MarkerSize', 4);
        legend_labels{idx} = st.Label;
    end

    ax.XLim = [min(x), max(x)];
    title(ax, sprintf('density = %.3g, m = %d, N = %d', ...
        results.densities(d_idx), results.m_fixed, results.N), ...
        'FontName', 'Times New Roman', 'FontSize', 10, 'FontWeight', 'bold');

    if d_idx == 1
        legend(ax, legend_labels, 'Location', 'NorthWest', ...
            'FontSize', 8, 'FontName', 'Times New Roman', 'Box', 'on');
    end
end

save_gateway_paper_figure(fig, 'gateway_single_paper_combined');
end

function styles = deviation_styles()
styles = struct();
styles.betweenness = struct('Label', 'Betweenness', 'Color', [0 0 1], 'Marker', 's', 'LineStyle', '-');
styles.closeness = struct('Label', 'Closeness', 'Color', [0.850 0.325 0.098], 'Marker', '*', 'LineStyle', '-');
styles.eigenvector = struct('Label', 'Eigenvector', 'Color', [0.929 0.694 0.125], 'Marker', 'o', 'LineStyle', '-');
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
