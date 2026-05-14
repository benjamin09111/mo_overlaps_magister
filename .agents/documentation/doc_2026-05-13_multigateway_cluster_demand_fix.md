# Ajuste Multi-Gateway: Demand Por Cluster

## Fecha
2026-05-13

## Problema Observado
La primera corrida de la fase multi-gateway genero valores de `W.C. Network demand` demasiado altos y dificiles de comparar con el paper.

## Causa
La implementacion inicial calculaba conflict demand entre todos los flujos de la red, incluso si pertenecian a gateways/clusters distintos. Eso sobreestima la demanda en un escenario multi-gateway, porque el paper evalua la carga por gateway o cluster.

## Correccion
Se ajusto el modelo multi-gateway para:

- Guardar `flows.assigned_gateways`.
- Contar conflict demand solo entre flujos asignados al mismo gateway.
- Evaluar schedulability por gateway/cluster.
- Reportar como demanda global el peor cluster/gateway en cada ventana temporal.

Formula implementada:

```text
D_g(ell) = contention_g(ell) + conflict_g(ell)
D_system(ell) = max_g D_g(ell)
Schedulable si para todo g y ell: D_g(ell) <= ell
```

## Archivos Modificados
- `mo_sp_gateways/experiments/run_single_trial_gateway_multigw_paper.m`
- `mo_sp_gateways/metrics/compute_multigateway_conflict_demand_window.m`
- `mo_sp_gateways/metrics/compute_multigateway_schedulability_status.m`
- `mo_sp_gateways/metrics/compute_multigateway_network_demand_curve.m`
- `mo_sp_gateways/plots/plot_gateway_multigw_topology_clusters.m`

## Impacto Esperado
Los graficos de multi-gateway deben bajar de escala en network demand y ser mas coherentes con el paper. La figura topologica ahora marca explicitamente los gateways con estrella/pentagono y etiqueta `GW`.
