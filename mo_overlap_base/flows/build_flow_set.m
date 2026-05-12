function flows = build_flow_set(paths, cfg, T)
% Construye flujos F = {C_i, D_i, T_i, phi_i}

n = length(paths);

C = compute_route_costs(paths, cfg);

if nargin < 3 || isempty(T)
    T = generate_periods_harmonic(n, cfg);
end

if cfg.use_implicit_deadlines
    D = T;
else
    D = T;
end

flows = struct();
flows.n = n;
flows.C = C(:);
flows.T = T(:);
flows.D = D(:);
flows.paths = paths(:);
flows.H = cfg.H;
flows.w = cfg.w;
end