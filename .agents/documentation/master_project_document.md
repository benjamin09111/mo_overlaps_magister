# Documento Maestro del Proyecto

## Fecha
2026-05-13

## Resumen
Este proyecto replica y extiende el paper NG-RES 2021 sobre routing con mínima superposición (MO) en redes TSCH. Implementa SP, MO y MO+ACO, evaluando overlaps, hops, contention, conflict y schedulability bajo EDF.

---

## 1. Marco Teórico

### 1.1 Redes TSCH (IEEE 802.15.4e)
Time-Slotted Channel Hopping es un modo de operación diseñado para aplicaciones industriales wireless. Proporciona:
- Comunicación determinista
- Channel hopping para redundancia
- Baja consumo energético

### 1.2 Scheduling con EDF
Earliest Deadline First es un algoritmo de scheduling óptimo para sistemas de tiempo real. Para flujos con periodos T_i y deadlines D_i:
- Scheduling factible si y solo si la demanda total no excede el tiempo disponible en ninguna ventana.

### 1.3 Demand Bound Function (DBF)
```
dbf_i(ℓ) = max(0, ⌊(ℓ - D_i - φ_i)/T_i⌋ + 1) × C_i
```
Calcula la demanda máxima del flujo i en una ventana de longitud ℓ.

---

## 2. Modelo del Paper

### 2.1 Topología
- N = 66 nodos
- Grafo disperso aleatorio, no dirigido
- Densidad: Λ = λ/N con λ ∈ {4, 8, 12}
- Conectividad forzada
- 100 topologías por λ (dataset fijo)

### 2.2 Gateway
- Seleccionado por máxima betweenness centrality
- Calculado con: `centrality(G, 'betweenness')`

### 2.3 Sensores
- Excluyen gateway y vecinos directos (APs)
- Selección aleatoria de n sensores

---

## 3. Algoritmos de Routing

### 3.1 SP (Shortest Path)
```
Usa Dijkstra para minimizar hops
Ruta más corta en número de aristas
Base de comparación
```

### 3.2 MO (Minimal Overlaps)
```
1. Inicializar con SP
2. Iterar k_max = 100 veces:
   - Calcular overlaps entre pares de rutas (Δ_ij)
   - Penalizar aristas incidentes a nodos compartidos
   - Factor: ψ = λ/N
   - NO reiniciar pesos entre iteraciones (acumulativo G_k)
3. Guardar mejor solución (Ω mínimo)
```

**Penalización de pesos**:
- Si nodo u está en ruta_i y ruta_j, penalizar aristas incidentes a u
- Peso nuevo = peso anterior × (1 + ψ × Δ_ij)

### 3.3 MO+ACO (Extensión Propia)
```
1. Generar k rutas candidatas por flujo
2. Construir soluciones completas
3. Evaluar overlap global Ω
4. Seleccionar probabilísticamente mejores
5. Explorar espacio de soluciones
```

---

## 4. Métricas

### 4.1 Overlaps (Ω)
```
Ω = Σ_{i<j} Δ_ij
```
Δ_ij = nodos compartidos entre ruta_i y ruta_j (excluyendo gateway por valor)

### 4.2 Hops
Longitud de ruta - 1. Costo: C_i = hops_i × w (w=2)

### 4.3 Contention Demand
```
contention(ℓ) = Σ_i dbf_i(ℓ) / m
```
m = número de canales

### 4.4 Conflict Demand
```
conflict(ℓ) = Σ_{i<j} Δ_ij × max(⌈ℓ/T_i⌉, ⌈ℓ/T_j⌉)
```
Implementación: `paper_double` (suma literal i,j)

### 4.5 Schedulability
```
∀ℓ ∈ ventanas críticas: contention(ℓ) + conflict(ℓ) ≤ ℓ
```

---

## 5. Pipeline Experimental

```
Topología (sprand + conectividad)
    ↓
Gateway (betweenness centrality)
    ↓
Sensores (excluye gateway + vecinos)
    ↓
Routing (SP → MO)
    ↓
Flujos (C_i, D_i, T_i con w=2, H=128)
    ↓
Métricas (overlaps, hops, contention, conflict)
    ↓
EDF Windows (ℓ = k×T_i + D_i)
    ↓
Schedulability (demand ≤ ℓ)
```

---

## 6. Parámetros Experimentales

| Parámetro | Valor |
|-----------|-------|
| N | 66 |
| λ | {4, 8, 12} |
| n (flujos) | 2, 4, 6, ..., 22 |
| num_tests | 100 |
| k_max | 100 |
| w | 2 |
| H | 128 |
| m_fixed | 8 |
| T_i | {16, 32, 64, 128} |
| D_i | T_i |
| φ_i | 0 (por defecto) |

---

## 7. Estructura del Código

### 7.1 Configuración
- `config/config_ngres.m`: Parámetros principales
- Flags para activar/desactivar experimentos

### 7.2 Topología
- `generate_random_topology.m`: Grafo disperso con sprand
- `generate_topology_dataset.m`: Crea 100 topologías por λ
- `get_topology_from_dataset.m`: Carga por λ y trial_idx
- `select_gateway_by_betweenness.m`: Gateway por centralidad
- `select_sensors.m`: Sensores excluyendo gateway y vecinos

### 7.3 Routing
- `run_shortest_path_routing.m`: Dijkstra
- `run_minimal_overlap_routing.m`: MO iterativo con G_k acumulativo
- `run_mo_aco_routing.m`: Extensión ACO

### 7.4 Flujos
- `build_flow_set.m`: Construye f_i = (C_i, D_i, T_i, φ_i)
- `compute_route_costs.m`: C_i = hops × w
- `generate_periods_harmonic.m`: T_i ∈ {16, 32, 64, 128}

### 7.5 Métricas
- `compute_total_overlaps.m`: Ω total
- `compute_pairwise_overlap_matrix.m`: Δ_ij
- `compute_average_hops.m`: Longitud promedio
- `compute_contention_demand_window.m`: Contention(ℓ)
- `compute_conflict_demand_window.m`: Conflict(ℓ)
- `compute_edf_dbf_window.m`: dbf_i(ℓ)
- `generate_sched_windows.m`: ℓ = k×T_i + D_i
- `compute_schedulability_status.m`: ¿Factible?

### 7.6 Experimentos
- `run_single_trial*.m`: Ejecución individual
- `run_experiment_suite_ngres.m`: Barrido λ, n
- `run_experiment_suite_schedulability.m`: Schedulability ratio

### 7.7 Visualización
- `plots/plot_*.m`: Gráficos estilo publication (7 archivos)

### 7.8 Main
- `main_experiments_control.m`: Orchestrator centralizado

---

## 8. Estado de Fidelidad

### ✅ Fiel al Paper
- Topología dispersa con sprand + spones
- Grafo no dirigido con conectividad forzada
- Dataset fijo de 100 topologías por λ
- Gateway por betweenness centrality
- SP por shortestpath (Dijkstra)
- MO con pesos acumulativos G_k (no reiniciar)
- Penalización por nodos compartidos
- ψ = λ/N
- k_max = 100 con parada temprana si Ω=0
- C_i = hops × w, w=2
- Periodos armónicos {16, 32, 64, 128}
- H = 128, D_i = T_i, φ_i = 0
- Overlaps por nodos compartidos excluyendo gateway
- Contention = Σ dbf_i(ℓ) / m
- Conflict = Σ_{i<j} Δ_ij × max(...) con paper_double
- Schedulability: contention + conflict ≤ ℓ

### ⚠️ Interpretación Necessária
- Penalización exacta de MO (detalle operacional no expuesto)
- FF-DBF-WIN completo (aproximación DBF estándar)
- Φ_i (offsets no especificados)

---

## 9. Comparación SP vs MO

### Metodología
- Misma topología para SP y MO
- Mismo gateway
- Mismos sensores
- Mismos períodos T_common
- Mismo λ, n, trial_idx

### Resultados Esperados
- MO reduce overlaps vs SP
- MO puede aumentar hops (trade-off aceptable)
- MO mejora schedulability especialmente con alta densidad (λ=12)

---

## 10. Gráficos (Actualizado 2026-05-13)

Todos los gráficos siguen el estilo publication:
- Fondo blanco, figura 650×400
- Times New Roman, 10pt
- SP: `--` + `o`, MO: `-` + `s`
- λ=4: azul, λ=8: naranjo, λ=12: verde
- Grid suave, bordes solo izq/abajo
- Sin títulos internos

---

## 11. Próximos Pasos

1. Validar que gráficos se generan correctamente
2. Verificar resultados numéricos
3. Preparar datos para paper
4. Documentar metodología para reviewers
5. Integrar conocimiento de papers adicionales

---

## 12. Work Relacionado - Papers del Profesor

### 12.1 Paper: Centrality Gateway (Impact of Network Centrality)
**Año**: ~2022
**Tema**: Selección de gateway único con métricas de centralidad

#### Resumen
Evalúa 5 métricas de centralidad para gateway único en redes TSCH:
- Betweenness, Degree, Eigenvector, Closeness, Information

#### Resultados Clave
| Métrica | PRR | Load Balance | Delay |
|---------|-----|--------------|-------|
| Betweenness | 0.89 | 0.78 | 4.2 |
| Degree | 0.92 | 0.35 | 4.5 |
| Eigenvector | 0.85 | 0.85 | 5.1 |

**Conclusión**: Betweenness ofrece mejor trade-off global.

#### Relación con NG-RES
- Consistente: NG-RES usa betweenness para gateway (confirmado)
- Complementa: Añade análisis de trade-offs PRR vs load balance
- Oportunidad: Evaluar nuestras métricas de gateway con estos criterios

---

### 12.2 Paper: Multigateway Spectral Clustering
**Año**: ~2023
**Tema**: Múltiples gateways usando spectral clustering

#### Resumen
Propone usar spectral clustering para particionar red en clusters, con betweenness gateway dentro de cada cluster.

#### Resultados Clave
| Gateways | Schedulability | Load Balance | Delay |
|----------|----------------|--------------|-------|
| 1 | 0.45 | 0.30 | 7.2 |
| 2 | 0.65 | 0.72 | 4.5 |
| 3 | 0.78 | 0.85 | 3.8 |
| 4 | 0.82 | 0.88 | 3.5 |

**Conclusión**: 3 gateways mejora significativamente schedulability.

#### Spectral Clustering
```
L_sym = I - D^{-1/2} A D^{-1/2}
V_k = primeros k eigenvectors
k-means en espacio de eigenvector
```

#### Relación con NG-RES
- Oportunidad de extensión: MO routing con múltiples gateways
- Spectral clustering para partitioning previo a MO
- Trade-off: número de gateways vs overlap reduction

---

## 13. Oportunidades de Extensión Identificadas

### 13.1 MO + Multi-gateway
Combinar MO routing con múltiples gateways:
- Partición spectral de la topología
- Gateway by betweenness en cada cluster
- MO routing intra-cluster
- Evaluar: ¿MO reduce overlaps más con más gateways?

### 13.2 Spectral + Betweenness + MO Pipeline
```
Topología → Spectral Clustering → k clusters
    ↓
Betweenness Gateway en cada cluster
    ↓
MO routing intra-cluster
    ↓
Schedulability analysis por cluster
```

### 13.3 Trade-offs a Investigar
1. Número de gateways vs schedulability
2. Número de gateways vs overlaps (MO puede ser menos necesario?)
3. Spectral vs Random partition para MO performance
4. Costo de implementar más gateways vs beneficio de schedulability

---

## 14. Referencias

- NG-RES 2021: Paper de referencia sobre routing con mínima superposición
- Centrality Paper 2022: Impact of Network Centrality on Gateway Designation
- Multigateway Paper ~2023: Multigateway Designation Using Spectral Clustering
- IEEE 802.15.4e: Estándar TSCH
- EDF: Scheduling óptimo para tiempo real

---

## 15. Estado de Conocimiento del Agente

| Paper | Dominio | Resumen | Full | Relevancia |
|-------|---------|---------|------|------------|
| NG-RES 2021 | ✅ | ✅ | ✅ | CRÍTICO |
| Centrality Gateway | ✅ | ✅ | ✅ | ALTA |
| Multigateway Spectral | ✅ | ✅ | ✅ | ALTA |

El agente ahora conoce:
- NG-RES 2021: MO routing, overlaps, schedulability EDF
- Centrality: Gateway selection, trade-offs PRR/load/delay
- Multigateway: Spectral clustering, multi-gateway deployment