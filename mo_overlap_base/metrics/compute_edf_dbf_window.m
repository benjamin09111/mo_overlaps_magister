function [dbf_total, jobs] = compute_edf_dbf_window(flows, ell)
% Calcula la demand bound function EDF clásica en una ventana ell.
%
% dbf_i(ell) = max(0, floor((ell - D_i)/T_i) + 1) * C_i
%
% Retorna:
% - dbf_total: suma de demanda de transmisión
% - jobs: número de jobs considerados por flujo

n = flows.n;
C = flows.C(:);
D = flows.D(:);
T = flows.T(:);

jobs = zeros(n, 1);
dbf_total = 0;

for i = 1:n
    if ell >= D(i)
        jobs(i) = floor((ell - D(i)) / T(i)) + 1;
    else
        jobs(i) = 0;
    end

    dbf_total = dbf_total + jobs(i) * C(i);
end
end