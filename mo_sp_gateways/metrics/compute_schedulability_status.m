function [is_schedulable, details] = compute_schedulability_status(flows, gateway, m, H)
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
details = struct();
details.windows = windows;
details.contention = zeros(size(windows));
details.conflict = zeros(size(windows));
details.total_demand = zeros(size(windows));
details.slack = zeros(size(windows));
details.failing_window = [];

for w_idx = 1:length(windows)
    ell = windows(w_idx);

    contention = compute_contention_demand_window(flows, m, ell);
    conflict = compute_conflict_demand_window(flows, gateway, ell);

    total_demand = contention + conflict;
    slack = ell - total_demand;

    details.contention(w_idx) = contention;
    details.conflict(w_idx) = conflict;
    details.total_demand(w_idx) = total_demand;
    details.slack(w_idx) = slack;

    if total_demand > ell
        is_schedulable = false;
        details.failing_window = ell;
        return;
    end
end

if ~isempty(windows)
    [~, best_idx] = min(details.slack);
    details.worst_window = windows(best_idx);
    details.worst_slack = details.slack(best_idx);
else
    details.worst_window = [];
    details.worst_slack = [];
end
end
