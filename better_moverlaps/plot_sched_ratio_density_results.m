function plot_sched_ratio_density_results(sched, cfg)
% Schedulability ratio varying density

figure('Color', 'w', 'Position', [160, 160, 800, 600]);
hold on; grid on;

for l_idx = 1:length(sched.lambdas)
    c = cfg.colors{l_idx};

    plot(sched.n_range, sched.ratio_density_sp(l_idx, :), ':', ...
        'Color', c, 'LineWidth', 1.4);

    plot(sched.n_range, sched.ratio_density_mo(l_idx, :), '-s', ...
        'Color', c, 'LineWidth', 1.6, ...
        'MarkerFaceColor', c, 'MarkerSize', 5);
end

xlabel('Number of flows (n)');
ylabel('Schedulability ratio');
ylim([0 1.05]);
title(sprintf('N = %d, m = %d, \\lambda = {4,8,12}', sched.N, sched.m_fixed));

legend('\lambda=4 SP','\lambda=4 MO', ...
       '\lambda=8 SP','\lambda=8 MO', ...
       '\lambda=12 SP','\lambda=12 MO', ...
       'Location', 'SouthWest');
end