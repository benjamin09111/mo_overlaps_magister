# mo_overlaps_magister

Repositorio MATLAB para la réplica y análisis del paper **NG-RES 2021** sobre routing con `Shortest Path (SP)` y `Minimal Overlaps (MO)` en redes TSCH, con evaluación de `overlaps`, `hops`, `contention`, `conflict` y `schedulability` bajo EDF.

## Contexto

Este proyecto nace para comparar una implementación propia en MATLAB contra el comportamiento esperado del paper, sin asumir acceso al código original. La idea es obtener una base académica sólida, reproducible y fácil de defender ante profesores.

## Estructura Principal

El repositorio está dividido en 3 carpetas principales:

### 1. `mo_overlap_base/`
Base de referencia. No se modifica.
- Contiene la versión inicial usada como comparación.
- Sirve para validar tendencias y resultados previos.
- Útil cuando se quiere revisar qué cambió respecto a la línea base.

### 2. `better_moverlaps/`
Versión mejorada y editable.
- Aquí se aplicaron las primeras correcciones de fidelidad.
- Incluye topología por dataset, selección de sensores más fiel, métricas corregidas y análisis EDF más consistente.
- Sigue siendo una versión de trabajo.

### 3. `mo_sp_final/`
Versión final recomendada para ejecutar y probar.
- Centraliza la configuración.
- Permite activar o desactivar experimentos con flags simples.
- Es la carpeta pensada para que profesores puedan modificar parámetros rápido y ejecutar pruebas sin buscar archivos dispersos.

## Cómo Ejecutar

Recomendado: usar el main centralizado de `mo_sp_final`.

Archivo principal:

`mo_sp_final/main/main_experiments_control.m`

Nota: `mo_sp_final/main/main_ngres_replication.m` se mantiene como entrada legada y redirige al main central.

Pasos:
1. Abrir MATLAB.
2. Abrir el repositorio.
3. Ejecutar `mo_sp_final/main/main_experiments_control.m`.
4. Modificar los parámetros directamente al inicio del archivo.

## Qué Controla El Main Central

Se recomienda ejecutar como ya está configurado para obtener los resultados presentados.
Flags principales:

- `run_routing_only`: ejecuta solo routing SP vs MO.
- `run_sp_vs_mo`: ejecuta la réplica NG-RES principal (NO TERMINADA).
- `run_mo_vs_aco`: activa la extensión MO+ACO (NO TERMINADA).
- `run_schedulability`: calcula schedulability ratio.
- `run_plots`: genera gráficos.
- `use_topology_dataset`: usa dataset fijo de topologías.
- `regenerate_dataset`: recrea el dataset si hace falta.
- `conflict_pair_mode`: elige cómo contar conflicto (`paper_double` por defecto).

Parámetros principales editables:

- `N`
- `lambdas`
- `n_range`
- `num_tests`
- `k_max`
- `m_fixed`
- `m_contention_values`
- `m_sched_values`
- `w`
- `H`
- `eta_min`, `eta_max`

## Carpetas Importantes

### `topology/`
- `generate_random_topology.m`: genera grafos dispersos conectados.
- `generate_topology_dataset.m`: crea el dataset fijo de topologías.
- `get_topology_from_dataset.m`: carga topologías por `lambda` y `trial_idx`.
- `select_gateway_by_betweenness.m`: selecciona gateway.
- `select_sensors.m`: selecciona sensores evitando gateway y vecinos directos.

### `routing/`
- `run_shortest_path_routing.m`: rutas SP.
- `run_minimal_overlap_routing.m`: routing MO iterativo.
- `run_mo_aco_routing.m`: extensión MO+ACO.
- `path_to_edges.m`: conversión ruta-aristas.

### `flows/`
- `build_flow_set.m`: construye flujos `C_i, D_i, T_i, phi_i`.
- `compute_route_costs.m`: calcula costos por hops.
- `generate_periods_harmonic.m`: genera periodos armónicos.

### `metrics/`
- `compute_total_overlaps.m`: overlap total `Omega`.
- `compute_pairwise_overlap_matrix.m`: matriz `Delta_ij`.
- `compute_average_hops.m`: promedio de hops.
- `compute_contention_demand*.m`: contention por ventanas.
- `compute_conflict_demand*.m`: conflict por ventanas.
- `compute_edf_dbf_window.m`: DBF EDF.
- `generate_sched_windows.m`: ventanas críticas.
- `compute_schedulability_status.m`: condición final de factibilidad.

### `experiments/`
- `run_single_trial*.m`: ejecución por prueba.
- `run_experiment_suite_ngres.m`: comparación principal SP vs MO.
- `run_experiment_suite_schedulability.m`: schedulability ratio.
- `run_experiment_suite_mo_vs_moaco.m`: extensión MO+ACO.

### `plots/`
- Scripts de gráficos para overlaps, hops, contention, conflict y schedulability.

### `main/`
- `main_experiments_control.m`: main centralizado recomendado.
- `main_ngres_replication.m`: main clásico de réplica.
- `main_compare_sp_mo.m`: comparación SP vs MO.
- `main_compare_mo_moaco.m`: comparación MO vs MO+ACO.

## Reproducibilidad

- Las topologías se generan una vez y se reutilizan por `trial_idx`.
- SP y MO se evalúan sobre la misma red, con los mismos sensores y periodos por prueba.
- El dataset queda guardado como `dataset_topologies.dat`.

## Qué Es Fiel Al Paper

- Topología dispersa, conectada y no dirigida.
- Gateway por betweenness centrality.
- SP vs MO como comparación central.
- Cálculo de overlaps, hops, contention, conflict y schedulability.
- Evaluación sobre múltiples topologías y densidades.

## Qué Es Interpretación Necesaria

- La penalización exacta de MO.
- La forma práctica de `FF-DBF`.
- Algunas decisiones de implementación en `conflict demand` y `phi_i`.

## Archivos De Apoyo

- `context.txt`: contexto original del proyecto.
- `comparaciones.txt`: checklist de comparación paper vs implementación.
- `document.md`: documentación viva de decisiones y cambios.

## Recomendación De Uso

Para revisión rápida por parte de profesores:
1. Ejecutar `mo_sp_final/main/main_experiments_control.m`.
2. Revisar `document.md` para entender qué es fiel al paper y qué es interpretación.
3. Revisar `comparaciones.txt` si se quiere verificar punto por punto.
