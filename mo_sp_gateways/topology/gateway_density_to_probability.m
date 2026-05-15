function edge_probability = gateway_density_to_probability(cfg, density)
% Interpreta la densidad visible del paper como probabilidad de arista.
% El modo calibrado evita que density=1 genere un grafo casi completo.

if isfield(cfg, 'gateway_density_mode')
    mode = cfg.gateway_density_mode;
else
    mode = 'direct';
end

switch lower(mode)
    case 'direct'
        edge_probability = density;

    case 'calibrated_probability'
        densities = cfg.gateway_paper_densities;
        probabilities = cfg.gateway_density_edge_probabilities;
        idx = find(abs(densities - density) < 1e-12, 1);
        if isempty(idx)
            error('Density %.4f no tiene probabilidad calibrada.', density);
        end
        edge_probability = probabilities(idx);

    otherwise
        error('gateway_density_mode no soportado: %s', mode);
end
end
