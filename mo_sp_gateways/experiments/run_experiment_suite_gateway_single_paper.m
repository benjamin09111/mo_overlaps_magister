function results = run_experiment_suite_gateway_single_paper(cfg)
% Replica single-gateway: Degree vs Random y Deviation respecto de Degree.
% Diseno paired/nested: para cada topologia se fijan gateways, sensores y
% periodos maximos; cada valor de n usa el prefijo 1:n.

methods = cfg.gateway_methods;
densities = cfg.gateway_paper_densities;
n_range = cfg.n_range;

num_methods = length(methods);
num_densities = length(densities);
num_n = length(n_range);
max_n = max(n_range);

results = struct();
results.gateway_methods = methods;
results.deviation_methods = cfg.deviation_methods;
if isfield(cfg, 'deviation_mode')
    results.deviation_mode = cfg.deviation_mode;
else
    results.deviation_mode = 'absolute';
end
results.baseline_gateway_method = cfg.baseline_gateway_method;
results.densities = densities;
results.n_range = n_range;
results.N = cfg.N;
results.num_tests = cfg.num_tests;
results.m_fixed = cfg.gw_m_fixed;
results.ratio_sched_sp = zeros(num_methods, num_densities, num_n);
results.mean_hops_sp = zeros(num_methods, num_densities, num_n);
results.mean_overlaps_sp = zeros(num_methods, num_densities, num_n);
results.mean_conflict_sp = zeros(num_methods, num_densities, num_n);
results.mean_contention_sp = zeros(num_methods, num_densities, num_n);

rng_state = rng;

for d_idx = 1:num_densities
    density = densities(d_idx);
    fprintf('\n====================================================\n');
    fprintf('GATEWAY SINGLE PAPER: density = %.3g, N = %d, m = %d\n', density, cfg.N, cfg.gw_m_fixed);
    fprintf('====================================================\n');

    for t = 1:cfg.num_tests
        topo = get_gateway_paper_topology(cfg, density, t);
        G = topo.Graph;

        gateways = zeros(num_methods, 1);
        for method_idx = 1:num_methods
            if strcmp(methods{method_idx}, 'random')
                rng(cfg.random_gateway_rng_seed + 100000*d_idx + t, 'twister');
            end
            gateways(method_idx) = select_gateway_single_paper(G, methods{method_idx});
        end

        rng(cfg.gateway_paper_rng_seed + 200000*d_idx + t, 'twister');
        sensors_pool = select_common_sensors_for_gateways(G, gateways, max_n);
        rng(cfg.gateway_paper_rng_seed + 300000*d_idx + t, 'twister');
        T_pool = generate_periods_harmonic(max_n, cfg);

        for n_idx = 1:num_n
            n = n_range(n_idx);
            sensors = sensors_pool(1:n);
            T_common = T_pool(1:n);

            for method_idx = 1:num_methods
                trial = run_single_trial_gateway_single_paper( ...
                    cfg, density, n, cfg.gw_m_fixed, t, methods{method_idx}, sensors, T_common, gateways(method_idx));

                results.ratio_sched_sp(method_idx, d_idx, n_idx) = results.ratio_sched_sp(method_idx, d_idx, n_idx) + trial.sched_sp;
                results.mean_hops_sp(method_idx, d_idx, n_idx) = results.mean_hops_sp(method_idx, d_idx, n_idx) + trial.avg_hops_sp;
                results.mean_overlaps_sp(method_idx, d_idx, n_idx) = results.mean_overlaps_sp(method_idx, d_idx, n_idx) + trial.omega_sp;
                results.mean_conflict_sp(method_idx, d_idx, n_idx) = results.mean_conflict_sp(method_idx, d_idx, n_idx) + trial.conflict_sp;
                results.mean_contention_sp(method_idx, d_idx, n_idx) = results.mean_contention_sp(method_idx, d_idx, n_idx) + trial.contention_sp;
            end
        end

        fprintf('trial=%d/%d | density=%.3g\n', t, cfg.num_tests, density);
    end
end

results.ratio_sched_sp = results.ratio_sched_sp / cfg.num_tests;
results.mean_hops_sp = results.mean_hops_sp / cfg.num_tests;
results.mean_overlaps_sp = results.mean_overlaps_sp / cfg.num_tests;
results.mean_conflict_sp = results.mean_conflict_sp / cfg.num_tests;
results.mean_contention_sp = results.mean_contention_sp / cfg.num_tests;

rng(rng_state);
results = compute_single_gateway_deviations(results);
end

function sensors = select_common_sensors_for_gateways(G, gateways, n)
N = numnodes(G);
all_nodes = 1:N;
excluded = unique(gateways(:));

for idx = 1:length(gateways)
    excluded = unique([excluded; neighbors(G, gateways(idx))]); %#ok<AGROW>
end

potential = setdiff(all_nodes, excluded(:)');
if numel(potential) < n
    potential = setdiff(all_nodes, unique(gateways(:))');
end

if numel(potential) < n
    error('No hay suficientes sensores comunes. n=%d, disponibles=%d', n, numel(potential));
end

idx = randperm(numel(potential), n);
sensors = potential(idx);
end

function results = compute_single_gateway_deviations(results)
methods = results.gateway_methods;
baseline_idx = find(strcmp(methods, results.baseline_gateway_method), 1);
if isempty(baseline_idx)
    error('Baseline gateway method no encontrado: %s', results.baseline_gateway_method);
end

results.baseline_idx = baseline_idx;
baseline_sched = results.ratio_sched_sp(baseline_idx, :, :);
baseline_full = repmat(baseline_sched, [length(methods), 1, 1]);
if isfield(results, 'deviation_mode')
    deviation_mode = results.deviation_mode;
else
    deviation_mode = 'absolute';
end

switch lower(deviation_mode)
    case 'method_minus_degree'
        results.dev_vs_degree_abs.sched_sp = results.ratio_sched_sp - baseline_full;
    case 'degree_minus_method'
        results.dev_vs_degree_abs.sched_sp = baseline_full - results.ratio_sched_sp;
    case 'absolute'
        results.dev_vs_degree_abs.sched_sp = abs(results.ratio_sched_sp - baseline_full);
    otherwise
        error('deviation_mode no soportado: %s', deviation_mode);
end

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

function gateway = select_gateway_single_paper(G, method)
method = lower(char(method));

switch method
    case 'betweenness'
        scores = centrality(G, 'betweenness');
    case 'degree'
        scores = centrality(G, 'degree');
    case 'eigenvector'
        scores = centrality(G, 'eigenvector');
    case 'closeness'
        scores = centrality(G, 'closeness');
    case 'random'
        gateway = randi(numnodes(G));
        return;
    otherwise
        error('Metodo de gateway no soportado en single-paper: %s', method);
end

scores(~isfinite(scores)) = -inf;
[~, gateway] = max(scores);
end
