# Gateway Multi-Gateway Replication Documentation

## Fecha
2026-05-13

## Proposito
Agregar una replica modular del bloque multi-gateway de los papers adjuntos usando `N = 75`, `d = 0.1`, `m = 16` y `k = 1, 3, 5` gateways.

## Que Dice El Paper
El paper multi-gateway propone particionar la red, designar gateways dentro de cada particion usando centralidad y evaluar mejoras de schedulability y demanda respecto de configuraciones menos optimizadas.

## Que Hace El Codigo
El codigo nuevo implementa:
- Topologias fijas con `N = 75`, `density = 0.1`.
- Spectral clustering para `k = 1, 3, 5`.
- Gateway por cluster usando Degree, Random, Betweenness, Closeness y Eigenvector.
- Routing shortest path hacia el gateway asignado por cluster.
- Schedulability ratio mediante el modelo EDF/DBF ya usado en NG-RES.
- Curva de network demand como `contention(ell) + conflict_multi(ell)`.
- Deviation absoluta respecto de Degree.

## Tabla Paper vs Implementacion
| Aspecto | Paper | Implementacion |
|---|---|---|
| N | 75 | 75 |
| d | 0.1 | 0.1 usando `sprand` |
| m | 16 | 16 |
| k | 1, 3, 5 | 1, 3, 5 |
| Particion | Spectral clustering | Spectral clustering Laplacian normalizado |
| Gateway | Centrality per cluster | Degree, Random, BC, CC, EC |
| Schedulability | Ratio | Ratio con EDF/DBF NG-RES |
| Network demand | W.C. demand vs time | contention + conflict_multi vs time |
| Topologia | clusters + GW | clusters + GW para k=3 |

## Formula Deviation
```text
Dev(method,k,n) = SR(method,k,n) - SR(degree,k,n)
```

Se usa deviation absoluta porque los graficos adjuntos muestran valores pequeños como `0.05`, no porcentajes.

## Como Ejecutar
Desde MATLAB:

```matlab
run('mo_sp_gateways/main/main_gateway_multigw_paper_replication.m')
```

O desde el main central con `num_tests=100`:

```matlab
run('mo_sp_gateways/main/main_experiments_control.m')
```

## Nota Sobre El Modelo De Demanda Multi-Gateway
El 2026-05-13 se corrigio el modelo para evaluar la demanda por gateway/cluster (no global entre todos los flujos). Cada gateway maneja solo los flujos de su cluster. La demanda global se reporta como el maximo entre todos los gateways. Esto es conceptualmente mas fiel al paper y reduce la escala de `W.C. Network demand` a valores mas cercanos a los esperados.

## Nota Sobre `conflict_pair_mode`
El modelo de conflicto usa `paper_double` heredado de NG-RES (cuenta cada par i,j con i!=j). Los papers de gateway no especifican su modelo, por lo que esta es una aproximacion documentada.

## Salidas Esperadas
- `mo_sp_gateways/results_gateway_multigw_paper.mat`
- `mo_sp_gateways/figures/gateway_multigw_sched_ratio.pdf`
- `mo_sp_gateways/figures/gateway_multigw_sched_ratio.png`
- `mo_sp_gateways/figures/gateway_multigw_network_demand.pdf`
- `mo_sp_gateways/figures/gateway_multigw_network_demand.png`
- `mo_sp_gateways/figures/gateway_multigw_topology_clusters.pdf`
- `mo_sp_gateways/figures/gateway_multigw_topology_clusters.png`
- `mo_sp_gateways/figures/gateway_multigw_deviation_by_k.pdf`
- `mo_sp_gateways/figures/gateway_multigw_deviation_by_k.png`

## Validacion Pendiente
La ejecucion runtime depende de MATLAB local. En la fase anterior MATLAB fallo por servicios MathWorks (`error 5201`), por lo que esta fase tambien debe validarse en cuanto MATLAB este disponible.
