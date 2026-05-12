function contention_demand = compute_contention_demand(flows, m, H)
% Calcula una aproximación del avg. worst-case contention demand
%
% Intuición:
% - la demanda total de slots depende de C_i y del número de activaciones
% - la contención disminuye al aumentar el número de canales m
%
% Usamos una aproximación simple y consistente con el documento:
%
% contention_demand = total_demand / m
%
% donde:
% total_demand = sum_i C_i * ceil(H / T_i)

total_demand = compute_hyperperiod_demand(flows, H);
contention_demand = total_demand / m;
end