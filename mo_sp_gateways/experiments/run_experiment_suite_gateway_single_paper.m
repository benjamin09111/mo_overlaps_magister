function results = run_experiment_suite_gateway_single_paper(cfg)
% Replica single-gateway: Degree vs Random y Deviation respecto de Degree.
% Diseno paired: misma topologia, sensores y periodos para todos los metodos.

methods = cfg.gateway_methods;
densities = cfg.gateway_paper_densities;
n_range = cfg.n_range;

num_methods = length(methods);
num_densities = length(densities);
num_n = length(n_range);

results = struct();
results.gateway_methods = methods;
results.deviation_methods = cfg.deviation_methods;
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

    for n_idx = 1:num_n
        n = n_range(n_idx);
        totals = init_totals(num_methods);

        for t = 1:cfg.num_tests
            topo = get_gateway_paper_topology(cfg, density, t);
            G = topo.Graph;

            gateways = zeros(num_methods, 1);
            for method_idx = 1:num_methods
                if strcmp(methods{method_idx}, 'random')
                    rng(cfg.random_gateway_rng_seed + 100000*d_idx + 1000*n_idx + t, 'twister');
                end
                gateways(method_idx) = select_gateway_single_paper(G, methods{method_idx});
            end

            sensors = select_common_sensors_for_gateways(G, gateways, n);
            rng(cfg.gateway_paper_rng_seed + 200000*d_idx + 1000*n_idx + t, 'twister');
            T_common = generate_periods_harmonic(n, cfg);

            for method_idx = 1:num_methods
                trial = run_single_trial_gateway_single_paper( ...
                    cfg, density, n, cfg.gw_m_fixed, t, methods{method_idx}, sensors, T_common, gateways(method_idx));

                totals.sched_sp(method_idx) = totals.sched_sp(method_idx) + trial.sched_sp;
                totals.hops_sp(method_idx) = totals.hops_sp(method_idx) + trial.avg_hops_sp;
                totals.overlaps_sp(method_idx) = totals.overlaps_sp(method_idx) + trial.omega_sp;
                totals.conflict_sp(method_idx) = totals.conflict_sp(method_idx) + trial.conflict_sp;
                totals.contention_sp(method_idx) = totals.contention_sp(method_idx) + trial.contention_sp;
            end
        end

        for method_idx = 1:num_methods
            results.ratio_sched_sp(method_idx, d_idx, n_idx) = totals.sched_sp(method_idx) / cfg.num_tests;
            results.mean_hops_sp(method_idx, d_idx, n_idx) = totals.hops_sp(method_idx) / cfg.num_tests;
            results.mean_overlaps_sp(method_idx, d_idx, n_idx) = totals.overlaps_sp(method_idx) / cfg.num_tests;
            results.mean_conflict_sp(method_idx, d_idx, n_idx) = totals.conflict_sp(method_idx) / cfg.num_tests;
            results.mean_contention_sp(method_idx, d_idx, n_idx) = totals.contention_sp(method_idx) / cfg.num_tests;
        end

        fprintf('n=%d | methods=%d | baseline=%s\n', n, num_methods, cfg.baseline_gateway_method);
    end
end

rng(rng_state);
results = compute_single_gateway_deviations(results);
end

function totals = init_totals(num_methods)
totals.sched_sp = zeros(num_methods, 1);
totals.hops_sp = zeros(num_methods, 1);
totals.overlaps_sp = zeros(num_methods, 1);
totals.conflict_sp = zeros(num_methods, 1);
totals.contention_sp = zeros(num_methods, 1);
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
