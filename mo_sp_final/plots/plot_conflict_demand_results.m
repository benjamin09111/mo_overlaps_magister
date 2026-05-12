function plot_conflict_demand_results(results, cfg)
% Figura estilo NG-RES: Avg. worst-case conflict demand
% Variando lambda = {4,8,12}, con N = 66 y m = 8

figure('Color', 'w', 'Position', [120, 120, 800, 600]);
hold on; grid on;

for l_idx = 1:length(results.lambdas)
    c = cfg.colors{l_idx};

    plot(results.n_range, results.mean_conflict_sp(l_idx, :), ':', ...
        'Color', c, 'LineWidth', 1.2);

    plot(results.n_range, results.mean_conflict_mo(l_idx, :), '-s', ...
        'Color', c, 'LineWidth', 1.5, ...
        'MarkerFaceColor', c, 'MarkerSize', 5);
end

xlabel('Number of flows (n)');
ylabel('Avg. worst-case conflict demand');
title(sprintf('N = %d, m = %d, \\lambda = {4,8,12}', results.N, 8));

legend('\lambda=4 SP','\lambda=4 MO', ...
       '\lambda=8 SP','\lambda=8 MO', ...
       '\lambda=12 SP','\lambda=12 MO', ...
       'Location', 'NorthWest');
end