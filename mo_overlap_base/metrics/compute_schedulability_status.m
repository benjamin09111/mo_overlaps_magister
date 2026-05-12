function is_schedulable = compute_schedulability_status(flows, gateway, m, H)
% Test EDF multi-window más fiel al paper.
%
% Antes:
%   contention(H) + conflict(H) <= H
%
% Ahora:
%   Para cada ventana crítica ell:
%   contention(ell) + conflict(ell) <= ell
%
% Donde:
% - contention(ell) usa DBF EDF clásica normalizada por m canales.
% - conflict(ell) usa overlaps Delta_ij y activaciones en ventana ell.
%
% Si falla en alguna ventana, no es schedulable.

windows = generate_sched_windows(flows, H);

is_schedulable = true;

for w_idx = 1:length(windows)
    ell = windows(w_idx);

    contention = compute_contention_demand_window(flows, m, ell);
    conflict = compute_conflict_demand_window(flows, gateway, ell);

    total_demand = contention + conflict;

    if total_demand > ell
        is_schedulable = false;
        return;
    end
end
end