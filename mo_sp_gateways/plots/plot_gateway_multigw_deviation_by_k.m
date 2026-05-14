function plot_gateway_multigw_deviation_by_k(results, cfg)
% Figura tipo paper: deviation BC/CC/EC respecto de Degree para cada k.

fig = figure('Color', 'w', 'Position', [100, 500, 900, 320]);
x = results.n_range;
styles = method_styles();

for k_idx = 1:length(results.k_gateways)
    ax = subplot(1, length(results.k_gateways), k_idx, 'Parent', fig);
    hold(ax, 'on'); grid(ax, 'on');
    setup_axes(ax, 'Number of flows (n)', 'Deviation');
    plot(ax, [min(x), max(x)], [0, 0], ':', 'Color', [0.35 0.35 0.35], 'LineWidth', 0.8);

    legend_labels = cell(1, length(results.deviation_methods));
    for idx = 1:length(results.deviation_methods)
        method = results.deviation_methods{idx};
        method_idx = results.deviation_method_idx(idx);
        y = squeeze(results.dev_vs_degree_abs.sched_sp(method_idx, k_idx, :));
        st = styles.(method);
        plot(ax, x, y, st.LineStyle, 'Color', st.Color, 'LineWidth', 1.2, ...
            'Marker', st.Marker, 'MarkerFaceColor', 'white', 'MarkerSize', 4);
        legend_labels{idx} = st.Label;
    end

    ax.XLim = [min(x), max(x)];
    title(ax, sprintf('k = %d, d = %.1f, m = %d, N = %d', ...
        results.k_gateways(k_idx), results.density, results.m_fixed, results.N), ...
        'FontName', 'Times New Roman', 'FontSize', 10, 'FontWeight', 'bold');
    legend(ax, legend_labels, 'Location', 'NorthWest', 'FontSize', 8, ...
        'FontName', 'Times New Roman', 'Box', 'on', 'EdgeColor', [0.73 0.73 0.73]);
end

save_gateway_paper_figure(fig, 'gateway_multigw_deviation_by_k');
end

function styles = method_styles()
styles = struct();
styles.betweenness = struct('Label', 'BC', 'Color', [0 0.447 0.741], 'Marker', 's', 'LineStyle', '-');
styles.closeness = struct('Label', 'CC', 'Color', [0.850 0.325 0.098], 'Marker', '*', 'LineStyle', '-');
styles.eigenvector = struct('Label', 'EC', 'Color', [0.929 0.694 0.125], 'Marker', 'o', 'LineStyle', '-');
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
