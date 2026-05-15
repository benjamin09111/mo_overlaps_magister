function plot_gateway_single_deviation_density(results, cfg)
% Plots 5-7: Deviation BC/CC/EC vs Degree por densidad.
% 3 subplots en fila. N=80, m=16, density=0.1/0.5/1.

fig = figure('Color', 'w', 'Position', [80, 420, 960, 340]);
x = results.n_range;
styles = method_styles();

for d_idx = 1:length(results.densities)
    ax = subplot(1, length(results.densities), d_idx, 'Parent', fig);
    hold(ax, 'on'); grid(ax, 'on');
    setup_paper_axes(ax, 'Number of flows', 'Deviation');
    plot(ax, [min(x), max(x)], [0, 0], ':', 'Color', [0.35 0.35 0.35], 'LineWidth', 0.8);

    legend_labels = cell(1, length(results.deviation_methods));
    for idx = 1:length(results.deviation_methods)
        method = results.deviation_methods{idx};
        method_idx = results.deviation_method_idx(idx);
        y = squeeze(results.dev_vs_degree_abs.sched_sp(method_idx, d_idx, :));
        st = styles.(method);
        plot(ax, x, y, st.LineStyle, 'Color', st.Color, 'LineWidth', 2.0, ...
            'Marker', st.Marker, 'MarkerFaceColor', 'white', 'MarkerSize', 6);
        legend_labels{idx} = st.Label;
    end

    ax.XLim = [min(x), max(x)];
    title(ax, sprintf('d = %.3g, m = %d, N = %d', ...
        results.densities(d_idx), results.m_fixed, results.N), ...
        'FontName', 'Times New Roman', 'FontSize', 10, 'FontWeight', 'bold');

    if d_idx == 3
        legend(ax, legend_labels, 'Location', 'NorthWest', ...
            'FontSize', 8, 'FontName', 'Times New Roman', 'Box', 'on', ...
            'EdgeColor', [0.73 0.73 0.73]);
    end
end

save_gateway_paper_figure(fig, 'gateway_single_deviation_density');
end

function styles = method_styles()
styles = struct();
styles.betweenness = struct('Label', 'BC', 'Color', [0 0.447 0.741], ...
    'Marker', 's', 'LineStyle', '-');
styles.closeness = struct('Label', 'CC', 'Color', [0.850 0.325 0.098], ...
    'Marker', '^', 'LineStyle', '-');
styles.eigenvector = struct('Label', 'EC', 'Color', [0.929 0.694 0.125], ...
    'Marker', 'o', 'LineStyle', '-');
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
