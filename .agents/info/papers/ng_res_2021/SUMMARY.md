# NG-RES 2021 - SUMMARY

## Meta
- **Año**: 2021
- **Autores**: [Pending confirmation]
- **Fuente**: NG-RES Conference/Journal
- **DOI/URL**: [Pending]

## Tema Principal
Routing con mínima superposición en redes IEEE 802.15.4e TSCH para mejorar schedulability bajo EDF en sistemas industriales wireless.

## Problema que Resuelve
El routing Shortest Path (SP) tradicional minimiza hops pero crea rutas con muchos nodos compartidos, aumentando el conflict demand y empeorando la schedulability en redes densas.

## Aporte Clave
Algoritmo MO (Minimal Overlaps): routing iterativo con pesos acumulativos que minimiza nodos compartidos entre rutas. Usa factor de penalización ψ = λ/N para escalar según densidad de red.

## Metodología Resumida

### Paso 1: Topología
Generar grafo disperso aleatorio con N=66 nodos, densidad Λ=λ/N, conectividad forzada, 100 topologías por λ.

### Paso 2: Gateway
Seleccionar nodo con máxima betweenness centrality.

### Paso 3: Routing SP
Calcular rutas más cortas (Dijkstra) sensor → gateway.

### Paso 4: Routing MO
Iterar k_max=100 veces:
- Calcular overlaps Ω entre pares de rutas
- Penalizar aristas incidentes a nodos compartidos
- Factor: ψ = λ/N
- NO reiniciar pesos (acumulativo G_k)
- Recalcular rutas con nuevos pesos

### Paso 5: Evaluar Schedulability
Para cada ventana ℓ = k×T_i + D_i:
- Contention(ℓ) = Σ dbf_i(ℓ) / m
- Conflict(ℓ) = Σ Δ_ij × max(⌈ℓ/T_i⌉, ⌈ℓ/T_j⌉)
- Factible si contention + conflict ≤ ℓ

## Fórmulas Clave

### Densidad
```
Λ = λ / N
```

### Overlaps Total
```
Ω = Σ_{i<j} Δ_ij
```
Δ_ij = nodos compartidos entre ruta_i y ruta_j (excluyendo gateway)

### Costo por Flujo
```
C_i = hops_i × w    (w = 2)
```

### DBF (Demand Bound Function)
```
dbf_i(ℓ) = max(0, ⌊(ℓ - D_i - φ_i)/T_i⌋ + 1) × C_i
```

### Contention Demand
```
contention(ℓ) = Σ_i dbf_i(ℓ) / m
```

### Conflict Demand
```
conflict(ℓ) = Σ_{i<j} Δ_ij × max(⌈ℓ/T_i⌉, ⌈ℓ/T_j⌉)
```

### Schedulability
```
∀ℓ: contention(ℓ) + conflict(ℓ) ≤ ℓ
```

## Resultados Principales

| Escenario | SP | MO |
|-----------|----|----|
| Overlaps (λ=12, n=22) | ~150 | ~40 |
| Hops (λ=8) | ~3.5 | ~4.0 |
| Schedulability Ratio (λ=12) | ~0.3 | ~0.7 |

## Dataset Experimental
- N = 66 nodos
- λ ∈ {4, 8, 12}
- n ∈ {2, 4, 6, ..., 22}
- num_tests = 100
- m_fixed = 8
- H = 128
- T_i ∈ {16, 32, 64, 128}

## Comparación con Otros Trabajos

| Trabajo | Enfoque | Diferencia con NG-RES |
|---------|---------|----------------------|
| SP tradicional | Mínima distancia | Ignora overlaps |
| RMMA | Multi-path | Reserva recursos |
| CAR | Conflict-aware | Pero no iterativo |

## Limitaciones
- FF-DBF-WIN aproximado (no literal)
- φ_i = 0 por defecto
- Sin múltiples gateways
- Topología estática

## Relación con Nuestro Proyecto (NG-RES 2021 replica)

### Similitudes
- Misma configuración experimental
- Mismo pipeline: topología → gateway → routing → demand → EDF
- Mismas métricas y fórmulas

### Diferencias
- Nuestra implementación es en MATLAB
- Penalty exacta de MO puede variar ligeramente
- Tenemos dataset fijo de topologías

### Útil Para
- Metodología de comparación SP vs MO
- Análisis de schedulability EDF
- Trade-off overlaps vs hops
- Extensión MO+ACO

## Frases Clave del Paper

> "The system evaluates schedulability under EDF by separating contention and conflict demand over multiple time windows, comparing routing strategies SP, MO, and MO+ACO."

> "MO reduces overlaps at the cost of slightly longer routes, but this trade-off improves schedulability in dense networks."

## Notas Personales
- ⚠️ CRÍTICO: No reiniciar pesos MO entre iteraciones - pérdida de información histórica
- El factor ψ = λ/N escala la penalización con densidad
- conflict_pair_mode = 'paper_double' para ser fiel
- Dataset fijo de 100 topologías por λ para reproducibilidad

## Tags
`#routing` `#minimal_overlaps` `#tsch` `#ieee_802.15.4e` `#edf` `#scheduling` `#conflict_demand` `#contention_demand` `#industrial_wireless`