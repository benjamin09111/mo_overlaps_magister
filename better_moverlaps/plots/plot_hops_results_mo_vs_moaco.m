function plot_hops_results_mo_vs_moaco(results, cfg)
% Figura tipo paper: hops para MO vs MO+ACO

figure('Color', 'w', 'Position', [150, 150, 800, 600]);
hold on; grid on;

for l_idx = 1:length(results.lambdas)
    c = cfg.colors{l_idx};

    plot(results.n_range, results.mean_hops_mo(l_idx, :), ':', ...
        'Color', c, 'LineWidth', 1.2);

    plot(results.n_range, results.mean_hops_moaco(l_idx, :), '-s', ...
        'Color', c, 'LineWidth', 1.5, ...
        'MarkerFaceColor', c, 'MarkerSize', 5);
end

xlabel('Number of flows (n)');
ylabel('Number of hops');
title('MO vs MO+ACO: Average route length');
legend('\lambda=4 MO','\lambda=4 MO+ACO', ...
       '\lambda=8 MO','\lambda=8 MO+ACO', ...
       '\lambda=12 MO','\lambda=12 MO+ACO', ...
       'Location', 'NorthWest');
end