# Plan: Replica Multi-Gateway k=1/3/5

## Fecha
2026-05-13

## Objetivo
Replicar el segundo bloque de figuras adjuntas asociado a multi-gateway: `N = 75`, `d = 0.1`, `m = 16`, `k = 1, 3, 5`, con schedulability ratio, worst-case network demand, topologia con gateways y deviation de centralidades respecto de Degree.

## Alcance
La implementacion se agrega solo en `mo_sp_gateways`. No modifica ni reemplaza los checkpoints `mo_sp_final` ni la fase single-gateway `N=80` ya creada.

## Figuras Objetivo
1. Schedulability ratio vs number of flows para `Degree` con `k = 1, 3, 5` y baseline `Random`.
2. Worst-case network demand vs time para `n = 25`, `d = 0.1`, `m = 16`, `N = 75`, comparando `Degree` y `Random` por `k`.
3. Topologia de ejemplo con `k = 3` gateways y clusters.
4. Deviation vs number of flows para `Betweenness`, `Closeness`, `Eigenvector` respecto de `Degree`, separada para `k = 1`, `k = 3`, `k = 5`.

## Interpretacion Implementada
- `k` se interpreta como numero de gateways.
- La particion de red se realiza mediante spectral clustering sobre el Laplacian normalizado.
- Dentro de cada cluster, el gateway se designa por centralidad: Degree, Betweenness, Closeness, Eigenvector o Random.
- Los sensores se asignan al gateway de su cluster.
- El routing es shortest path intra-red hacia el gateway asignado.

## Formulas
Laplacian normalizado:
```text
L_sym = I - D^{-1/2} A D^{-1/2}
```

Gateway por cluster:
```text
g_c = arg max centrality(v), v in cluster c
```

Schedulability:
```text
forall ell: contention(ell) + conflict_multi(ell) <= ell
```

Deviation absoluta respecto de Degree:
```text
Dev(method,k,n) = SR(method,k,n) - SR(degree,k,n)
```

## Diferencias Documentadas
La documentacion local de los papers no especifica todos los detalles operativos de simulacion. Por eso esta replica usa el modelo EDF/DBF y demand analysis ya defendido para NG-RES, extendido a multiples gateways excluyendo todos los gateways del conteo de overlaps.

## Validacion
- Misma topologia, clusters, sensores y periodos para todos los metodos en cada `(density,k,n,trial)`.
- Dataset separado de NG-RES y de la fase single-gateway.
- Figuras exportadas en PDF y PNG.

## Estado
En implementacion.
