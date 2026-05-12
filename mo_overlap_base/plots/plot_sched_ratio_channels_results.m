function plot_sched_ratio_channels_results(sched, cfg)
% Schedulability ratio varying number of channels

figure('Color', 'w', 'Position', [180, 180, 800, 600]);
hold on; grid on;

for m_idx = 1:length(sched.m_values)
    c = cfg.colors{m_idx};

    plot(sched.n_range, sched.ratio_channels_sp(m_idx, :), ':', ...
        'Color', c, 'LineWidth', 1.4);

    plot(sched.n_range, sched.ratio_channels_mo(m_idx, :), '-s', ...
        'Color', c, 'LineWidth', 1.6, ...
        'MarkerFaceColor', c, 'MarkerSize', 5);
end

xlabel('Number of flows (n)');
ylabel('Schedulability ratio');
ylim([0 1.05]);
title(sprintf('N = %d, \\lambda = %d, m = {2,8,16}', sched.N, sched.lambda_fixed));

legend('m=2 SP','m=2 MO', ...
       'm=8 SP','m=8 MO', ...
       'm=16 SP','m=16 MO', ...
       'Location', 'SouthWest');
end