function results = run_experiment_suite_gateway_multigw_paper(cfg)
% Replica multi-gateway k=1/3/5 con Degree, Random y deviations.

methods = cfg.gateway_methods;
k_values = cfg.k_gateways;
n_range = cfg.n_range;
time_grid = cfg.network_demand_time_grid;

num_methods = length(methods);
num_k = length(k_values);
num_n = length(n_range);
num_t = length(time_grid);

results = struct();
results.gateway_methods = methods;
results.deviation_methods = cfg.deviation_methods;
results.baseline_gateway_method = cfg.baseline_gateway_method;
results.k_gateways = k_values;
results.n_range = n_range;
results.time_grid = time_grid;
results.N = cfg.N;
results.density = cfg.gateway_multigw_density;
results.num_tests = cfg.num_tests;
results.m_fixed = cfg.gw_m_fixed;
results.network_demand_n = cfg.network_demand_n;
results.ratio_sched_sp = zeros(num_methods, num_k, num_n);
results.mean_hops_sp = zeros(num_methods, num_k, num_n);
results.mean_demand_curve = zeros(num_methods, num_k, num_t);
results.sample_topology = struct();

rng_state = rng;

for k_idx = 1:num_k
    k_gateways = k_values(k_idx);
    fprintf('\n====================================================\n');
    fprintf('GATEWAY MULTI PAPER: k = %d, N = %d, d = %.3g, m = %d\n', ...
        k_gateways, cfg.N, cfg.gateway_multigw_density, cfg.gw_m_fixed);
    fprintf('====================================================\n');

    for n_idx = 1:num_n
        n = n_range(n_idx);
        totals = init_totals(num_methods, num_t);

        for t = 1:cfg.num_tests
            topo = get_gateway_multigw_topology(cfg, t);
            G = topo.Graph;
            clusters = partition_topology_spectral(G, k_gateways);

            gateways_by_method = zeros(num_methods, k_gateways);
            for method_idx = 1:num_methods
                if strcmp(methods{method_idx}, 'random')
                    rng(cfg.random_gateway_rng_seed + 100000*k_idx + 1000*n_idx + t, 'twister');
                end
                gateways_by_method(method_idx, :) = select_cluster_gateways(G, clusters, methods{method_idx})';
            end

            sensors = select_common_sensors(G, gateways_by_method(:), n);
            rng(cfg.gateway_multigw_rng_seed + 200000*k_idx + 1000*n_idx + t, 'twister');
            T_common = generate_periods_harmonic(n, cfg);

            for method_idx = 1:num_methods
                gateways = gateways_by_method(method_idx, :)';
                trial = run_single_trial_gateway_multigw_paper( ...
                    cfg, n, k_gateways, t, methods{method_idx}, clusters, gateways, sensors, T_common);

                totals.sched_sp(method_idx) = totals.sched_sp(method_idx) + trial.sched_sp;
                totals.hops_sp(method_idx) = totals.hops_sp(method_idx) + trial.avg_hops_sp;

                if n == cfg.network_demand_n
                    totals.demand_curve(method_idx, :) = totals.demand_curve(method_idx, :) + trial.demand_curve(:)';
                    totals.demand_count(method_idx) = totals.demand_count(method_idx) + 1;
                end

                if t == 1 && n == cfg.network_demand_n && k_gateways == cfg.topology_plot_k && strcmp(methods{method_idx}, cfg.topology_plot_method)
                    results.sample_topology.Graph = G;
                    results.sample_topology.clusters = clusters;
                    results.sample_topology.gateways = gateways;
                    results.sample_topology.method = methods{method_idx};
                    results.sample_topology.k_gateways = k_gateways;
                end
            end
        end

        for method_idx = 1:num_methods
            results.ratio_sched_sp(method_idx, k_idx, n_idx) = totals.sched_sp(method_idx) / cfg.num_tests;
            results.mean_hops_sp(method_idx, k_idx, n_idx) = totals.hops_sp(method_idx) / cfg.num_tests;
            if totals.demand_count(method_idx) > 0
                results.mean_demand_curve(method_idx, k_idx, :) = totals.demand_curve(method_idx, :) / totals.demand_count(method_idx);
            end
        end

        fprintf('n=%d | k=%d | methods=%d\n', n, k_gateways, num_methods);
    end
end

rng(rng_state);
results = compute_multigw_deviations(results);
end

function totals = init_totals(num_methods, num_t)
totals.sched_sp = zeros(num_methods, 1);
totals.hops_sp = zeros(num_methods, 1);
totals.demand_curve = zeros(num_methods, num_t);
totals.demand_count = zeros(num_methods, 1);
end

function sensors = select_common_sensors(G, all_gateways, n)
N = numnodes(G);
all_nodes = 1:N;
excluded = unique(all_gateways(:));

for idx = 1:length(all_gateways)
    excluded = unique([excluded; neighbors(G, all_gateways(idx))]); %#ok<AGROW>
end

potential = setdiff(all_nodes, excluded(:)');
if numel(potential) < n
    potential = setdiff(all_nodes, unique(all_gateways(:))');
end

if numel(potential) < n
    error('No hay suficientes sensores comunes multi-gateway. n=%d, disponibles=%d', n, numel(potential));
end

idx = randperm(numel(potential), n);
sensors = potential(idx);
end

function results = compute_multigw_deviations(results)
methods = results.gateway_methods;
baseline_idx = find(strcmp(methods, results.baseline_gateway_method), 1);
if isempty(baseline_idx)
    error('Baseline gateway method no encontrado: %s', results.baseline_gateway_method);
end

results.baseline_idx = baseline_idx;
baseline_sched = results.ratio_sched_sp(baseline_idx, :, :);
results.dev_vs_degree_abs.sched_sp = results.ratio_sched_sp - repmat(baseline_sched, [length(methods), 1, 1]);

dev_method_idx = zeros(length(results.deviation_methods), 1);
for idx = 1:length(results.deviation_methods)
    method_idx = find(strcmp(methods, results.deviation_methods{idx}), 1);
    if isempty(method_idx)
        error('Deviation method no encontrado: %s', results.deviation_methods{idx});
    end
    dev_method_idx(idx) = method_idx;
end
results.deviation_method_idx = dev_method_idx;
end
