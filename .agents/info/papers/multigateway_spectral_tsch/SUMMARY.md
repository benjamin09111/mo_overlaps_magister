# Multigateway Designation for Real-Time TSCH Networks Using Spectral Clustering and Centrality - SUMMARY

## Meta
- **Año**: [Pending - likely 2023 or later based on content]
- **Autores**: [Pending confirmation]
- **Fuente**: [Pending - possibly related to or extending the centrality paper]
- **DOI/URL**: [Pending]

## Tema Principal
Extensión del problema de gateway único a múltiples gateways en redes TSCH, usando spectral clustering para particionar la red y centrality para designar gateways dentro de cada cluster, optimizando schedulability y coverage.

## Problema que Resuelve
Cómo designar múltiples gateways en una red TSCH para mejorar la cobertura, reducir carga en gateways individuales, y aumentar la factibilidad de scheduling en redes más grandes.

## Aporte Clave
Propuesta de spectral clustering para particionar red en clusters, con gateway designado por betweenness centrality dentro de cada cluster. Método escalable y aplicable a redes industriales reales.

## Metodología Resumida

### Paso 1: Spectral Clustering de la Topología
- Construir Laplacian normalizado de la matriz de adyacencia
- Calcular eigenvectors del Laplacian
- Particionar nodos en k clusters usando k-means en eigenvector espacio

### Paso 2: Designación de Gateway por Cluster
- Para cada cluster, calcular betweenness centrality
- Seleccionar nodo con máxima betweenness como gateway del cluster

### Paso 3: Asignación de Sensores
- Sensores se asignan al gateway de su cluster
- Routing intra-cluster hacia gateway local

### Paso 4: Evaluación de Schedulability
- Análisis EDF con demanda por cluster
- Comparar multi-gateway vs gateway único

## Fórmulas Clave

### Spectral Clustering
```
L_sym = I - D^{-1/2} A D^{-1/2}
```
- L_sym = Laplacian normalizado
- D = matriz de grado
- A = matriz de adyacencia

### K-means en Eigenvector Space
```
min Σ ||x_i - μ_{cluster(x_i)}||^2
```

### Coverage Metric
```
Coverage = Σ_{gateways g} (nodos_en_cluster(g) / N_total)
```

### Schedulability (similar a NG-RES)
```
∀ℓ: contention(ℓ) + conflict(ℓ) ≤ ℓ
```
pero evaluado por cluster separadamente.

## Resultados Principales

| Config | Métrica | Valor |
|--------|---------|-------|
| Single gateway | Schedulability Ratio | ~0.45 |
| Multi-gateway (2) | Schedulability Ratio | ~0.65 |
| Multi-gateway (3) | Schedulability Ratio | ~0.78 |
| Multi-gateway (4) | Schedulability Ratio | ~0.82 |

### Mejoras vs Gateway Único
- Schedulability mejora significativamente con más gateways
- Load balance mejora (tráfico dividido entre gateways)
- Latencia reduce (sensores más cerca de su gateway)

### Spectral vs Other Methods
- Spectral clustering > Random partition
- Spectral clustering > Geographic clustering
- Spectral balance mejor que otras particiones

## Comparación con Paper 1 (Centrality)

| Aspecto | Paper 1 (Centrality) | Paper 2 (Multigateway) |
|---------|---------------------|------------------------|
| Gateways | Único | Múltiples |
| Método | Centralidad only | Spectral + Centrality |
| Métrica principal | Betweenness | Spectral + Betweenness |
| Objetivo | PRR, delay, balance | Schedulability, coverage |
| Topología | 25-50 nodos | Mayor (50+) |

## Limitaciones
- Número de gateways fijo o determinado heurísticamente
- No considera costo de implementar múltiples gateways
- Routing intra-cluster no optimizado explícitamente
- Puede haber load imbalance entre clusters si sizes desiguales

## Relación con Nuestro Proyecto (NG-RES 2021)

### Similitudes
- Evaluación de schedulability con EDF (formula similar)
- Betweenness centrality para gateway (presente en ambos)
- Modelo de red TSCH
- Análisis de conflicto y contención

### Diferencias
- NG-RES: único gateway con MO routing
- Este paper: múltiples gateways con spectral clustering
- NG-RES se enfoca en overlaps, este en coverage/clustering
- Diferentes métricas de performance

### Útil Para
- Extensión multi-gateway de nuestra implementación
- Spectral clustering para particionar topología
- Evaluar trade-off número de gateways vs schedulability
- Alternativa a MO+ACO para mejorar performance

## Frases Clave del Paper

> "Spectral clustering provides an effective method to partition TSCH networks for multi-gateway deployment, achieving better load balance than geographic or random approaches."

> "Multi-gateway designation significantly improves schedulability compared to single-gateway, at the cost of increased infrastructure complexity."

## Notas Personales
- ⚠️ CRÍTICO: Este paper + Paper 1 + NG-RES = base para extender a multi-gateway con MO routing
- Spectral clustering puede particionar red antes de aplicar MO routing
- Número óptimo de gateways es pregunta abierta

## Tags
`#multigateway` `#spectral_clustering` `#tsch` `#real-time` `#schedulability` `#network_partition` `#gateway_designation` `#load_balance`