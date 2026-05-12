function plot_overlaps_results(results, cfg)
% Figura estilo NG-RES: average number of overlaps

figure('Color', 'w', 'Position', [100, 100, 800, 600]);
hold on; grid on;

for l_idx = 1:length(results.lambdas)
    c = cfg.colors{l_idx};

    plot(results.n_range, results.mean_overlaps_sp(l_idx, :), ':', ...
        'Color', c, 'LineWidth', 1.2);

    plot(results.n_range, results.mean_overlaps_mo(l_idx, :), '-s', ...
        'Color', c, 'LineWidth', 1.5, ...
        'MarkerFaceColor', c, 'MarkerSize', 5);
end

xlabel('Number of flows (n)');
ylabel('Average number of overlaps');
title(sprintf('N = %d, m = %d, \\lambda = {4,8,12}', results.N, cfg.m_fixed));

legend('\lambda=4 SP','\lambda=4 MO', ...
       '\lambda=8 SP','\lambda=8 MO', ...
       '\lambda=12 SP','\lambda=12 MO', ...
       'Location', 'NorthWest');
end