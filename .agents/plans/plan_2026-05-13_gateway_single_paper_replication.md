# Plan: Replica Single-Gateway Centrality Paper

## Fecha
2026-05-13

## Objetivo
Replicar primero el bloque de graficos mas cercano al codigo actual: `N = 80`, `density = 0.1, 0.5, 1`, `m = 16`, comparando `Degree` contra `Random` y calculando `Deviation` para `Betweenness`, `Closeness` y `Eigenvector` respecto de `Degree`.

## Alcance
Este plan trabaja solo en `mo_sp_gateways`, copia separada del checkpoint `mo_sp_final`. No reemplaza la replica NG-RES ya lograda; agrega un flujo experimental aislado para los papers de gateway.

## Figuras Objetivo
1. Schedulability ratio vs number of flows para `Degree` y `Random`, en tres subplots: `density = 0.1`, `0.5`, `1`.
2. Deviation vs number of flows para `Betweenness`, `Closeness` y `Eigenvector` respecto de `Degree`, en tres subplots: `density = 0.1`, `0.5`, `1`.

## Parametros Del Paper A Replicar
| Parametro | Valor objetivo |
|---|---|
| N | 80 |
| density | 0.1, 0.5, 1 |
| m | 16 |
| n | 1:10 |
| baseline | Degree centrality |
| comparison | Random, Betweenness, Closeness, Eigenvector |

## Interpretacion Implementada
El paper usa `density` como parametro de conectividad. En nuestro generador MATLAB se interpreta como probabilidad/densidad de `sprand(N,N,density)` antes de forzar conectividad. Esta interpretacion queda marcada como aproximacion si el paper no especifica una formula distinta.

## Metricas
Schedulability ratio:
```text
ratio(method, density, n) = schedulable_trials / num_tests
```

Deviation respecto de Degree:
```text
Dev(method) = ratio(method) - ratio(degree)
```

Nota: los graficos adjuntos muestran valores de deviation en escala absoluta aproximada `[-0.05, 0.2]`, no porcentaje. Por eso esta replica usa diferencia absoluta de schedulability ratio para fidelidad visual. Las deviations porcentuales anteriores se conservan en el flujo existente.

## Validacion
- La suite debe usar mismas topologias, sensores y periodos para todos los metodos.
- `Random` debe ser reproducible por `trial_idx`, `density_idx` y `n_idx`.
- Los resultados deben guardarse aparte como `results_gateway_single_paper.mat`.
- Los plots deben exportarse a PDF y PNG en `mo_sp_gateways/figures`.

## Estado
En implementacion.
