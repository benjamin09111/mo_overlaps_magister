# Papers Context - NG-RES 2021

Este archivo contiene el conocimiento profundo sobre el paper de referencia y el dominio técnico del proyecto.

---

## 📄 Paper Principal: NG-RES 2021

**Título**: Minimal Overlap Routing for TSCH Networks (referencia interna)

### Modelo de Red

- **N = 66 nodos**
- **Topología**: Grafo disperso aleatorio no dirigido
- **Densidad**: Λ = λ/N donde λ ∈ {4, 8, 12}
- **Conectividad**: Forzada para garantizar red conexa
- **Gateway**: Seleccionado por máxima betweenness centrality
- **Sensores**: Excluyen gateway y vecinos directos (APs)

### Algoritmos de Routing

#### SP (Shortest Path)
- Usa Dijkstra
- Minimiza número de hops
- Base para comparación

#### MO (Minimal Overlaps)
- Parte de rutas SP iniciales
- Itera k_max = 100 veces
- Penaliza aristas compartidas según overlaps de nodos
- Factor de densidad: ψ = λ/N
- Mantiene pesos acumulativos G_k (NO reiniciar entre iteraciones)

### Métricas de Routing

#### Overlaps (Ω)
```
Ω = Σ_{i<j} Δ_ij
```
donde Δ_ij = nodos compartidos entre ruta_i y ruta_j (excluyendo gateway)

#### Hops
- Longitud de ruta menos uno
- C_i = hops_i × w donde w = 2

### Modelado de Flujos

Cada flujo f_i = (C_i, D_i, T_i):
- C_i = hops × w (work per period)
- T_i ∈ {16, 32, 64, 128} (períodos armónicos)
- D_i = T_i (implicit deadline)
- Hiperperiodo H = 128

### Demand Analysis (Modelo NG-RES)

Separación clave: **Total Demand = Contention + Conflict**

#### Contention Demand
```
contention(ℓ) = Σ_i dbf_i(ℓ) / m
```
donde m = número de canales

#### Conflict Demand
```
conflict(ℓ) = Σ_{i<j} Δ_ij × max(⌈ℓ/T_i⌉, ⌈ℓ/T_j⌉)
```
Modo de implementación: `paper_double` (suma literal i,j, no i<j)

### EDF Scheduling

#### DBF (Demand Bound Function)
```
dbf_i(ℓ) = max(0, ⌊(ℓ - D_i - φ_i)/T_i⌋ + 1) × C_i
```
donde φ_i = offset (0 por defecto)

#### Ventanas Críticas
```
ℓ = k×T_i + D_i  para k = 0, 1, 2, ...
```

#### Schedulability
```
∀ℓ: contention(ℓ) + conflict(ℓ) ≤ ℓ
```

### Parámetros Experimentales

| Parámetro | Valor |
|-----------|-------|
| N | 66 |
| λ | {4, 8, 12} |
| n (flujos) | 2:2:22 |
| num_tests | 100 |
| k_max | 100 |
| w | 2 |
| H | 128 |
| m_fixed | 8 |

---

## 📚 Dominio Técnico

### IEEE 802.15.4e TSCH
- Time-Slotted Channel Hopping
- Celda = slot + canal
- Diseño para industrial wireless

### Betweenness Centrality
- Medida de importancia de nodo
- Gateway = nodo con máxima centralidad
- Calculado con graphcentrality(G, 'betweenness')

### EDF (Earliest Deadline First)
- Scheduling óptimo para sistemas de tiempo real
- Deadlines implícitas (D_i = T_i)
- Análisis holístico con hyperperiod

### FF-DBF-WIN (aproximación)
- No implementado de forma literal
- DBF estándar EDF con ventanas críticas
- Aproximación defendible para replica

---

## 🔍 Detalles de Implementación

### Penalización MO
- Pesos acumulativos G_k (no reiniciar)
- Penaliza aristas incidentes a nodos solapados
- Factor ψ = λ/N escala la penalización

### Overlaps Contaje
- Por nodos compartidos (no aristas)
- Gateway excluido por valor (no por posición)
- Suma por pares i,j (no i<j para conflict demand)

### Contention vs Conflict
- Contention: demanda por acceso a canales (compartido)
- Conflict: demanda por superposición de rutas (nodos compartidos)

---

## 📊 Resultados Esperados

### SP vs MO
- MO reduce overlaps vs SP
- MO puede aumentar hops (trade-off)
- MO mejora schedulability en alta densidad

### Schedulability Ratio
- Mejora con más canales (m)
- Empeora con más flujos (n)
- MO > SP especialmente con λ=12

---

## ⚠️ Puntos de Atención

1. **No reiniciar pesos MO** entre iteraciones - pierde información histórica
2. **Usar dataset fijo** para comparaciones reproducibles
3. **Φ_i = 0** por defecto - paper no especifica otra cosa
4. **conflict_pair_mode = 'paper_double'** para ser fiel
5. **m_fixed = 8** para experimentos principales

---

## 📝 Notación Matemática

```
Λ = λ/N              (densidad)
ψ = Λ                 (factor de penalización)
Ω = Σ_{i<j} Δ_ij     (overlaps total)
C_i = hops_i × w     (costo por flujo)
dbf_i(ℓ) = max(0, ⌊(ℓ - D_i - φ_i)/T_i⌋ + 1) × C_i
contention(ℓ) = Σ_i dbf_i(ℓ) / m
conflict(ℓ) = Σ_{i<j} Δ_ij × max(⌈ℓ/T_i⌉, ⌈ℓ/T_j⌉)
```

---

## 🔗 Estructura del Código

```
mo_sp_final/
├── config/
│   └── config_ngres.m      # Parámetros principales
├── topology/
│   ├── generate_random_topology.m
│   ├── generate_topology_dataset.m
│   ├── get_topology_from_dataset.m
│   ├── select_gateway_by_betweenness.m
│   └── select_sensors.m
├── routing/
│   ├── run_shortest_path_routing.m
│   ├── run_minimal_overlap_routing.m
│   └── run_mo_aco_routing.m
├── flows/
│   ├── build_flow_set.m
│   ├── compute_route_costs.m
│   └── generate_periods_harmonic.m
├── metrics/
│   ├── compute_total_overlaps.m
│   ├── compute_pairwise_overlap_matrix.m
│   ├── compute_average_hops.m
│   ├── compute_contention_demand_window.m
│   ├── compute_conflict_demand_window.m
│   ├── compute_edf_dbf_window.m
│   ├── generate_sched_windows.m
│   └── compute_schedulability_status.m
├── experiments/
│   ├── run_single_trial_ngres.m
│   ├── run_experiment_suite_ngres.m
│   └── run_experiment_suite_schedulability.m
├── plots/
│   ├── plot_conflict_demand_results.m
│   ├── plot_overlaps_results.m
│   ├── plot_contention_demand_results.m
│   ├── plot_hops_results.m
│   ├── plot_sched_ratio_channels_results.m
│   └── plot_*_mo_vs_moaco.m
└── main/
    └── main_experiments_control.m
```

---

## 📌 Checklist de Fidelidad

- [x] Topología dispersa con sprand + spones
- [x] Grafo no dirigido (triu + A')
- [x] Conectividad forzada
- [x] Dataset fijo de topologías
- [x] Gateway por betweenness centrality
- [x] Sensores excluyen gateway y vecinos
- [x] SP por shortestpath (Dijkstra)
- [x] MO con pesos acumulativos G_k
- [x] MO penaliza nodos compartidos
- [x] ψ = λ/N
- [x] k_max = 100 con parada temprana
- [x] C_i = hops × w con w=2
- [x] T_i ∈ {16, 32, 64, 128}
- [x] H = 128, D_i = T_i
- [x] Overlaps por nodos compartidos excluyendo gateway
- [x] Contention = Σ dbf_i(ℓ) / m
- [x] Conflict = Σ_{i<j} Δ_ij × max(...)
- [x] Schedulability: contention + conflict ≤ ℓ
- [x] conflict_pair_mode = 'paper_double'