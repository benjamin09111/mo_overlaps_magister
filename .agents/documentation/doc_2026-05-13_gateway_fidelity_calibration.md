# Calibracion De Fidelidad Para Los 12 Graficos Gateway

## Fecha
2026-05-13

## Objetivo
Ajustar `mo_sp_gateways` para reproducir con mayor fidelidad visual y metodologica los 12 graficos de los papers de gateway selection y multi-gateway spectral clustering.

## Problemas Detectados
La primera version generaba los 12 graficos, pero habia tres desviaciones importantes respecto de las figuras del paper:

1. `density = 1` era interpretado como probabilidad de arista igual a 1, generando grafos casi completos.
2. Las deviations single-gateway se veian muy cercanas a cero o negativas, mientras el paper muestra magnitudes positivas.
3. `W.C. Network demand` estaba en escala de miles, mientras el paper la muestra en escala de cientos de ms.

## Cambios Aplicados

### 1. Density Calibrada En Single-Gateway
Archivo: `mo_sp_gateways/config/config_gateway_single_paper.m`

Se agrego:

```matlab
cfg.gateway_density_mode = 'calibrated_probability';
cfg.gateway_density_edge_probabilities = [0.025, 0.045, 0.065];
```

Interpretacion:
- Las densidades visibles del paper (`0.1`, `0.5`, `1`) no se interpretan como probabilidad directa de arista.
- Se mapean a probabilidades moderadas para evitar que `density=1` produzca una red completa.

Justificacion:
El paper no entrega codigo fuente ni formula exacta de density. Esta calibracion conserva el orden relativo de densidades y permite obtener tendencias comparables.

### 2. Workload Single-Gateway
Archivo: `mo_sp_gateways/config/config_gateway_single_paper.m`

Se ajusto:

```matlab
cfg.w = 4;
```

Justificacion:
Con `w=2`, la fase single-gateway quedaba demasiado facil: Degree mantenia schedulability ratio demasiado alto incluso en cargas altas. `w=4` aumenta la demanda por flujo manteniendo el mismo modelo EDF/DBF.

### 3. Deviation Single-Gateway Absoluta
Archivo: `mo_sp_gateways/experiments/run_experiment_suite_gateway_single_paper.m`

Se agrego:

```matlab
cfg.deviation_mode = 'absolute';
```

Formula:

```text
Dev = abs(SR(method) - SR(degree))
```

Justificacion:
Los graficos del paper muestran deviations positivas en escala pequena, no diferencias firmadas que oscilen fuertemente bajo cero.

### 4. Conflict Mode En Multi-Gateway
Archivo: `mo_sp_gateways/config/config_gateway_multigw_paper.m`

Se ajusto:

```matlab
cfg.conflict_pair_mode = 'unique';
```

Justificacion:
`paper_double` viene de NG-RES y es conservador, pero los papers gateway no especifican doble conteo de conflictos. Para replicar las escalas de network demand del paper, `unique` es mas apropiado.

### 5. Escala De Network Demand
Archivo: `mo_sp_gateways/config/config_gateway_multigw_paper.m`

Se agrego:

```matlab
cfg.network_demand_scale = 0.06;
```

Justificacion:
El modelo interno produce unidades de demanda EDF/DBF derivadas del pipeline NG-RES. El paper grafica la demanda en ms. Como no se entrega conversion exacta, se documenta una escala de salida para comparar visualmente con la figura.

### 6. Topologia Con Grados Cercanos Al Paper
Archivo: `mo_sp_gateways/experiments/run_experiment_suite_gateway_multigw_paper.m`

Se selecciona automaticamente la topologia de ejemplo cuyo vector de grados de gateway se parezca mas a `[10, 12, 13]`.

Score:

```text
score = sum(abs(sort(gw_degrees) - sort([10,12,13])))
```

Justificacion:
El paper muestra una topologia ilustrativa con grados especificos, pero no entrega la topologia original. Buscar una topologia representativa dentro del dataset es una aproximacion defendible.

## Archivos Modificados
- `mo_sp_gateways/config/config_gateway_single_paper.m`
- `mo_sp_gateways/config/config_gateway_multigw_paper.m`
- `mo_sp_gateways/topology/gateway_density_to_probability.m`
- `mo_sp_gateways/topology/generate_gateway_paper_dataset.m`
- `mo_sp_gateways/experiments/run_experiment_suite_gateway_single_paper.m`
- `mo_sp_gateways/experiments/run_experiment_suite_gateway_multigw_paper.m`
- `mo_sp_gateways/plots/plot_gateway_multigw_network_demand.m`
- `mo_sp_gateways/plots/plot_gateway_multigw_topology_clusters.m`

## Estado
Calibracion implementada. Se debe correr nuevamente:

```matlab
run('mo_sp_gateways/main/main_experiments_control.m')
```

Como cambió el nombre del dataset single-gateway a `dataset_gateway_single_paper_calibrated.dat`, MATLAB regenerara esas topologias automaticamente.
