function plot_contention_demand_results(results, cfg)
% Figura estilo NG-RES: Avg. worst-case contention demand
% Variando m = {4,8,12}, con lambda = 4

figure('Color', 'w', 'Position', [140, 140, 800, 600]);
hold on; grid on;

num_m = length(results.m_values);

for m_idx = 1:num_m
    c = cfg.colors{m_idx};

    plot(results.n_range, results.mean_contention_sp(m_idx, :), ':', ...
        'Color', c, 'LineWidth', 1.2);

    plot(results.n_range, results.mean_contention_mo(m_idx, :), '-s', ...
        'Color', c, 'LineWidth', 1.5, ...
        'MarkerFaceColor', c, 'MarkerSize', 5);
end

xlabel('Number of flows (n)');
ylabel('Avg. worst-case contention demand');
title(sprintf('N = %d, \\lambda = %d, m = {4,8,12}', results.N, 4));

legend('m=4 SP','m=4 MO', ...
       'm=8 SP','m=8 MO', ...
       'm=12 SP','m=12 MO', ...
       'Location', 'NorthWest');
end