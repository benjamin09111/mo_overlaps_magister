function sensors = select_sensors(N, gateway, n)
% Selecciona n sensores aleatorios distintos del gateway

potential = find((1:N) ~= gateway);
sensors = potential(randperm(length(potential), n));
end