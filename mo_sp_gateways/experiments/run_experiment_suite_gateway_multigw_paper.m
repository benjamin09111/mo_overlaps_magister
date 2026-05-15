function results = run_experiment_suite_gateway_multigw_paper(cfg)
% Replica multi-gateway k=1/3/5 con Degree, Random y deviations.
% Diseno paired/nested: por topologia y k se fijan clusters, gateways,
% sensores y periodos maximos; cada n usa el prefijo 1:n.

methods = cfg.gateway_methods;
k_values = cfg.k_gateways;
n_range = cfg.n_range;
time_grid = cfg.network_demand_time_grid;

num_methods = length(methods);
num_k = length(k_values);
num_n = length(n_range);
num_t = length(time_grid);
max_n = max(n_range);

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
if isfield(cfg, 'network_demand_scale')
    results.network_demand_scale = cfg.network_demand_scale;
else
    results.network_demand_scale = 1;
end
results.ratio_sched_sp = zeros(num_methods, num_k, num_n);
results.mean_hops_sp = zeros(num_methods, num_k, num_n);
results.mean_demand_curve = zeros(num_methods, num_k, num_t);
results.sample_topology = struct();
results.sample_topology.best_degree_score = inf;

rng_state = rng;

for k_idx = 1:num_k
    k_gateways = k_values(k_idx);
    fprintf('\n====================================================\n');
    fprintf('GATEWAY MULTI PAPER: k = %d, N = %d, d = %.3g, m = %d\n', ...
        k_gateways, cfg.N, cfg.gateway_multigw_density, cfg.gw_m_fixed);
    fprintf('====================================================\n');

    demand_counts = zeros(num_methods, 1);

    for t = 1:cfg.num_tests
        topo = get_gateway_multigw_topology(cfg, t);
        G = topo.Graph;
        clusters = partition_topology_spectral(G, k_gateways);

        gateways_by_method = zeros(num_methods, k_gateways);
        for method_idx = 1:num_methods
            if strcmp(methods{method_idx}, 'random')
                rng(cfg.random_gateway_rng_seed + 100000*k_idx + t, 'twister');
            end
            gateways_by_method(method_idx, :) = select_cluster_gateways(G, clusters, methods{method_idx})';
        end

        rng(cfg.gateway_multigw_rng_seed + 200000*k_idx + t, 'twister');
        sensors_pool = select_common_sensors(G, gateways_by_method(:), max_n);
        rng(cfg.gateway_multigw_rng_seed + 300000*k_idx + t, 'twister');
        T_pool = generate_periods_harmonic(max_n, cfg);

        for n_idx = 1:num_n
            n = n_range(n_idx);
            sensors = sensors_pool(1:n);
            T_common = T_pool(1:n);

            for method_idx = 1:num_methods
                gateways = gateways_by_method(method_idx, :)';
                trial = run_single_trial_gateway_multigw_paper( ...
                    cfg, n, k_gateways, t, methods{method_idx}, clusters, gateways, sensors, T_common);

                results.ratio_sched_sp(method_idx, k_idx, n_idx) = results.ratio_sched_sp(method_idx, k_idx, n_idx) + trial.sched_sp;
                results.mean_hops_sp(method_idx, k_idx, n_idx) = results.mean_hops_sp(method_idx, k_idx, n_idx) + trial.avg_hops_sp;

                if n == cfg.network_demand_n
                    current_curve = squeeze(results.mean_demand_curve(method_idx, k_idx, :));
                    results.mean_demand_curve(method_idx, k_idx, :) = reshape(current_curve + trial.demand_curve(:), [1, 1, num_t]);
                    demand_counts(method_idx) = demand_counts(method_idx) + 1;
                end

                if n == cfg.network_demand_n && k_gateways == cfg.topology_plot_k && strcmp(methods{method_idx}, cfg.topology_plot_method)
                    degree_score = gateway_degree_match_score(G, gateways);
                    if degree_score < results.sample_topology.best_degree_score
                        results.sample_topology.best_degree_score = degree_score;
                        results.sample_topology.gateway_degrees = degree(G, gateways(:));
                        results.sample_topology.trial_idx = t;
                        results.sample_topology.Graph = G;
                        results.sample_topology.clusters = clusters;
                        results.sample_topology.gateways = gateways;
                        results.sample_topology.method = methods{method_idx};
                        results.sample_topology.k_gateways = k_gateways;
                    end
                end
            end
        end

        fprintf('trial=%d/%d | k=%d\n', t, cfg.num_tests, k_gateways);
    end

    results.ratio_sched_sp(:, k_idx, :) = results.ratio_sched_sp(:, k_idx, :) / cfg.num_tests;
    results.mean_hops_sp(:, k_idx, :) = results.mean_hops_sp(:, k_idx, :) / cfg.num_tests;

    for method_idx = 1:num_methods
        if demand_counts(method_idx) > 0
            results.mean_demand_curve(method_idx, k_idx, :) = results.mean_demand_curve(method_idx, k_idx, :) / demand_counts(method_idx);
        end
    end
end

rng(rng_state);
results = compute_multigw_deviations(results);
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

function score = gateway_degree_match_score(G, gateways)
target_degrees = sort([10; 12; 13]);
gw_degrees = sort(degree(G, gateways(:)));
if length(gw_degrees) ~= length(target_degrees)
    score = inf;
else
    score = sum(abs(gw_degrees(:) - target_degrees(:)));
end
end
