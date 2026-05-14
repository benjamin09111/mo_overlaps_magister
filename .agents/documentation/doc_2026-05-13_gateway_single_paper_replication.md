# Gateway Single-Paper Replication Documentation

## Fecha
2026-05-13

## Proposito
Agregar en `mo_sp_gateways` una replica incremental del bloque de graficos de centrality gateway con `N = 80`, densidades `0.1`, `0.5`, `1`, `m = 16`, comparando `Degree` vs `Random` y deviations de otras centralidades respecto de `Degree`.

## Que Dice El Paper
El bloque de figuras adjunto evalua como cambia el schedulability ratio al seleccionar el gateway con `Degree centrality` frente a una seleccion `Random`. Luego compara deviations de otras centralidades (`Betweenness`, `Closeness`, `Eigenvector`) respecto de `Degree`.

## Que Hace El Codigo
El codigo nuevo usa el pipeline existente de MATLAB:

```text
Topologia -> Gateway -> Sensores -> SP routing -> Flujos -> Demand EDF -> Schedulability
```

Para cada densidad, cantidad de flujos y trial:
- Carga la misma topologia.
- Calcula gateways por cada metodo.
- Selecciona sensores comunes para todos los gateways.
- Usa los mismos periodos armonicos.
- Calcula schedulability bajo shortest path.

## Diferencias Documentadas
| Aspecto | Paper | Implementacion |
|---|---|---|
| N | 80 | 80 |
| Densidades | 0.1, 0.5, 1 | 0.1, 0.5, 1 usando `sprand` |
| Canales | m = 16 | m = 16 |
| Flujos | 1:10 | 1:10 |
| Degree vs Random | Si | Si |
| Deviation BC/CC/EC | Si | Si |
| Modelo temporal exacto | No completamente especificado en notas locales | EDF/DBF del pipeline NG-RES |

## Formula Deviation Usada
Para replicar la escala visual del paper se usa diferencia absoluta de schedulability ratio:

```text
Dev(method) = SR(method) - SR(degree)
```

No se usa porcentaje en estos plots porque los graficos adjuntos muestran deviation en escala cercana a `0.0-0.2`.

## Archivos Nuevos
- `mo_sp_gateways/config/config_gateway_single_paper.m`
- `mo_sp_gateways/main/main_gateway_single_paper_replication.m`
- `mo_sp_gateways/topology/generate_gateway_paper_dataset.m`
- `mo_sp_gateways/topology/get_gateway_paper_topology.m`
- `mo_sp_gateways/experiments/run_single_trial_gateway_single_paper.m`
- `mo_sp_gateways/experiments/run_experiment_suite_gateway_single_paper.m`
- `mo_sp_gateways/plots/plot_gateway_single_degree_random.m`
- `mo_sp_gateways/plots/plot_gateway_single_deviation_density.m`

## Estado
Implementacion inicial del flujo single-gateway. Falta validar visualmente contra las figuras del paper con una corrida completa `num_tests = 100`.

## Como Ejecutar
Desde MATLAB, ejecutar:

```matlab
run('mo_sp_gateways/main/main_gateway_single_paper_replication.m')
```

Salida esperada:
- `mo_sp_gateways/results_gateway_single_paper.mat`
- `mo_sp_gateways/figures/gateway_single_degree_random.pdf`
- `mo_sp_gateways/figures/gateway_single_degree_random.png`
- `mo_sp_gateways/figures/gateway_single_deviation_density.pdf`
- `mo_sp_gateways/figures/gateway_single_deviation_density.png`

## Validacion Pendiente
Se intento una corrida reducida desde terminal, pero MATLAB fallo antes de iniciar por servicios MathWorks:

```text
Unable to communicate with required MathWorks services (error 5201)
```

Este bloqueo es externo al codigo. La validacion runtime queda pendiente cuando MATLAB este disponible.
