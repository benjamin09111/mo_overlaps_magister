# NG-RES 2021 - Full Content

---

# INFORMACIÓN GENERAL

## Meta
- **Año**: 2021
- **Autores**: [Pending confirmation]
- **Fuente**: NG-RES (Next Generation Reservation Enhanced Systems) o conferencia equivalente
- **DOI/URL**: [Pending]
- **Estado**: Paper de referencia principal

---

# RESUMEN EJECUTIVO

Este paper presenta un algoritmo de routing llamado MO (Minimal Overlaps) para redes inalámbricas industriales IEEE 802.15.4e en modo TSCH. El objetivo es minimizar la superposición de nodos entre rutas para reducir el conflict demand en el análisis de schedulability EDF. Los autores proponen comparar su enfoque MO contra SP (Shortest Path) tradicional, mostrando que MO reduce significativamente los overlaps manteniendo hops razonables, lo que mejora la factibilidad del scheduling en redes densas.

---

# 1. INTRODUCCIÓN

## Contexto
Las redes industriales wireless basadas en IEEE 802.15.4e TSCH proporcionan comunicación determinista y de bajo consumo. Sin embargo, el scheduling de flujos con diferentes períodos en estas redes es un desafío, especialmente cuando múltiples rutas comparten nodos (overlaps), generando contención adicional.

## Motivación
El routing tradicional SP minimiza hops pero puede crear rutas con muchos nodos compartidos, aumentando el conflict demand. Esto puede empeorar la schedulability incluso si el camino es corto.

## Problema
Dado:
- Red con N nodos, densidad Λ = λ/N
- m canales de comunicación
- Flujos con períodos T_i y trabajo C_i

Encontrar rutas que minimicen overlap entre pares de flujos para maximizar schedulability.

## Solución Propuesta
MO (Minimal Overlaps): Algoritmo iterativo que parte de rutas SP y las perturba para reducir nodos compartidos, usando penalización acumulada en pesos de aristas.

## Contribuciones
1. Algoritmo MO para minimizar overlaps en routing TSCH
2. Análisis de trade-off entre overlaps y hops
3. Evaluación de schedulability EDF con demanda separada (contention + conflict)
4. Dataset de 100 topologías por densidad para validación reproducible

---

# 2. TRABAJO RELACIONADO

## Routing en Redes Inalámbricas Industriales
- SP: Dijkstra minimiza hops
- RMMA: Reservation-based Multi-Path Multi-Hop Algorithm
- CAR: Conflict-Aware Routing

## EDF Scheduling en Redes
- DBF (Demand Bound Function): Cota superior de demanda
- FF-DBF: Holistic analysis con hiperperiodo
- Análisis por ventanas críticas

## Gap
No existe enfoque que minimice overlaps de forma iterativa con pesos acumulados para redes TSCH densas.

---

# 3. MODELO DEL SISTEMA

## 3.1 Modelo de Red

### Topología
- N = 66 nodos
- Grafo disperso aleatorio no dirigido
- Densidad: Λ = λ/N, λ ∈ {4, 8, 12}
- Conectividad forzada (componentes conexos)
- 100 topologías por λ (dataset fijo)

### Gateway
- Seleccionado por máxima betweenness centrality
- Representa el punto de agregación de datos

### Sensores
- n sensores seleccionados aleatoriamente
- Excluyen gateway y vecinos directos (APs)
- Origen de flujos de tráfico uplink

## 3.2 Modelo de Tráfico

### Flujos
Cada flujo f_i definido por:
- C_i: trabajo por período (bytes/slot)
- T_i: período (slot)
- D_i: deadline = T_i (implicit deadline)
- φ_i: offset = 0 por defecto

### Períodos
T_i ∈ {16, 32, 64, 128} (armónicos)
Hiperperiodo H = 128

### Costo por flujo
C_i = hops_i × w, donde w = 2 (ancho de celda)

## 3.3 Modelo de Canales

- m canales disponibles (m_fixed = 8 en experimentos principales)
- Cada canal puede servir una transmisión por slot
- Canal compartido por contendores (contention)

---

# 4. ALGORITMOS DE ROUTING

## 4.1 SP (Shortest Path)

### Descripción
Usa Dijkstra para encontrar ruta con mínimo número de hops.

### Algoritmo
```matlab
function routes = run_shortest_path_routing(G, sensors, gateway)
    for each sensor s
        [path, dist] = shortestpath(G, s, gateway);
        routes(s) = path;
    end
end
```

### Input
- G: Grafo de la topología
- sensors: Lista de nodos sensores
- gateway: Nodo gateway

### Output
- routes: Celda con ruta para cada sensor

---

## 4.2 MO (Minimal Overlaps)

### Descripción
Algoritmo iterativo que perturba rutas SP para reducir nodos compartidos. Usa pesos acumulativos G_k que penalizan aristas incidentes a nodos con alto overlap.

### Algoritmo
```matlab
function routes = run_minimal_overlap_routing(G, sensors, gateway, k_max, psi)
    % Inicializar con SP
    routes = shortest_path_routing(G, sensors, gateway);
    G_k = ones(N_edges);  % Pesos iniciales = 1

    best_omega = inf;

    for k = 1:k_max
        % Calcular overlaps
        Omega = compute_total_overlaps(routes, gateway);

        if Omega == 0
            break;  % Solución perfecta
        end

        if Omega < best_omega
            best_routes = routes;
            best_omega = Omega;
        end

        % Calcular matriz de overlaps Δ_ij
        Delta = compute_pairwise_overlap_matrix(routes, gateway);

        % Penalizar aristas con nodos shared
        for each edge e in routes
            shared_nodes = get_shared_nodes(e, routes, Delta);
            if ~isempty(shared_nodes)
                penalty = psi * length(shared_nodes);
                for each node n in shared_nodes
                    incident_edges = edges_incident_to(G, n);
                    G_k(incident_edges) = G_k(incident_edges) * (1 + penalty);
                end
            end
        end

        % Recalcular rutas con nuevos pesos
        for each sensor s
            [path, ~] = shortestpath(G, s, gateway, 'Weights', G_k);
            routes(s) = path;
        end
    end

    routes = best_routes;  % Restaurar mejor solución
end
```

### Parámetros
- k_max = 100 (máximo de iteraciones)
- psi = Λ = λ/N (factor de densidad)

### Características Clave
1. **Pesos acumulativos**: G_k NO se reinicia entre iteraciones
2. **Penalización por nodos compartidos**: No por aristas exactas
3. **Penalización escala con densidad**: psi = λ/N
4. **Parada temprana**: Si Ω=0, solución perfecta

---

## 4.3 MO+ACO (Extensión Propia)

### Descripción
Extensión de MO usando Colony Optimization Algorithm para exploración global de soluciones.

### Algoritmo (breve)
1. Generar k rutas candidatas por flujo
2. Construir soluciones completas (todas las rutas)
3. Evaluar overlap global Ω
4. Seleccionar probabilísticamente basadas en pheromones
5. Iterar evolución de soluciones

### Estado
⚠️ En desarrollo - NO terminado

---

# 5. MÉTRICAS DE ROUTING

## 5.1 Overlaps (Ω)

### Definición
```
Ω = Σ_{i<j} Δ_ij
```

donde Δ_ij = número de nodos compartidos entre ruta_i y ruta_j (excluyendo gateway)

### Cálculo
```matlab
function Omega = compute_total_overlaps(routes, gateway)
    n = length(routes);
    Omega = 0;

    for i = 1:n
        for j = i+1:n
            nodes_i = routes{i}(2:end-1);  % Excluir origen y gateway
            nodes_j = routes{j}(2:end-1);
            nodes_i = setdiff(nodes_i, gateway);  % Excluir gateway por valor
            nodes_j = setdiff(nodes_j, gateway);
            shared = intersect(nodes_i, nodes_j);
            Omega = Omega + length(shared);
        end
    end
end
```

### Nota Importante
- Gateway excluido por VALOR, no por posición
- Δ_ij cuenta nodos compartidos, no aristas

---

## 5.2 Hops

### Definición
Longitud de ruta en número de aristas = hops - 1

### Cálculo
```matlab
hops_i = length(routes{i}) - 1;
```

### Costo de transmisión
```
C_i = hops_i × w
```
donde w = 2 slots (tiempo de transmisión por hop)

---

# 6. DEMAND ANALYSIS (MODELO NG-RES)

## 6.1 Concepto Clave: Separación de Demanda

```
Total Demand = Contention + Conflict
```

Esta separación es fundamental para el análisis de schedulability.

---

## 6.2 Contention Demand

### Definición
```
contention(ℓ) = Σ_i dbf_i(ℓ) / m
```

### Significado
Demanda caused por competencia por canales (recurso compartido)

### DBF (Demand Bound Function)
```
dbf_i(ℓ) = max(0, ⌊(ℓ - D_i - φ_i)/T_i⌋ + 1) × C_i
```

### Variables
- ℓ: longitud de ventana (slots)
- D_i: deadline del flujo i = T_i
- φ_i: offset (0 por defecto)
- T_i: período del flujo i
- C_i: trabajo por período

### Implementación
```matlab
function dbf = compute_edf_dbf_window(ell, flow)
    if ell < flow.Di
        dbf = 0;
    else
        count = floor((ell - flow.Di - flow.phi) / flow.Ti) + 1;
        dbf = max(0, count) * flow.Ci;
    end
end
```

---

## 6.3 Conflict Demand

### Definición
```
conflict(ℓ) = Σ_{i<j} Δ_ij × max(⌈ℓ/T_i⌉, ⌈ℓ/T_j⌉)
```

### Significado
Demanda adicional causada por overlaps de rutas (nodos compartidos)

### Variables
- Δ_ij: overlaps entre flujo i y j (nodos compartidos)
- max(⌈ℓ/T_i⌉, ⌈ℓ/T_j⌉): máximo número de instancias que pueden colisionar en ventana ℓ

### Implementación (modo paper_double)
```matlab
function conflict = compute_conflict_demand_window(ell, routes, flows, gateway)
    n = length(routes);
    conflict = 0;

    for i = 1:n
        for j = 1:n
            if i ~= j
                nodes_i = setdiff(routes{i}(2:end-1), gateway);
                nodes_j = setdiff(routes{j}(2:end-1), gateway);
                shared = intersect(nodes_i, nodes_j);
                delta_ij = length(shared);

                if delta_ij > 0
                    Ti = flows{i}.Ti;
                    Tj = flows{j}.Ti;
                    instances = max(ceil(ell / Ti), ceil(ell / Tj));
                    conflict = conflict + delta_ij * instances;
                end
            end
        end
    end
end
```

### Nota de Implementación
- `paper_double`: suma literal i,j (incluye ambos sentidos)
- `unique`: suma i<j (más eficiente pero diferente)
- Default: `paper_double` para ser fiel al paper

---

# 7. SCHEDULABILITY ANALYSIS

## 7.1 Ventanas Críticas EDF

### Definición
```
ℓ = k × T_i + D_i
```
para k = 0, 1, 2, ... mientras ℓ ≤ H

### Significado
Todas las combinaciones de instantes donde la demanda puede ser máxima para algún flujo.

## 7.2 Schedulability Condition

### Condición
```
∀ ℓ ∈ ventanas críticas: contention(ℓ) + conflict(ℓ) ≤ ℓ
```

### Significado
El sistema es factible (schedulable) si y solo si la demanda total no excede el tiempo disponible en ninguna ventana crítica.

## 7.3 Implementación

```matlab
function status = compute_schedulability_status(routes, flows, m, H)
    windows = generate_sched_windows(flows, H);

    for each ell in windows
        contention = compute_contention_demand_window(ell, flows, m);
        conflict = compute_conflict_demand_window(ell, routes, flows);

        if contention + conflict > ell
            status = 'NOT SCHEDULABLE';
            return;
        end
    end

    status = 'SCHEDULABLE';
end
```

---

# 8. RESULTADOS EXPERIMENTALES

## 8.1 Configuración

| Parámetro | Valor |
|-----------|-------|
| N | 66 |
| λ | {4, 8, 12} |
| n | {2, 4, 6, ..., 22} |
| num_tests | 100 |
| k_max | 100 |
| w | 2 |
| H | 128 |
| m_fixed | 8 |
| T_i | {16, 32, 64, 128} |

## 8.2 Métricas Reportadas

### Overlaps (Ω)
- SP: Crece con n y λ
- MO: Significantly menor que SP
- Trade-off: MO puede aumentar hops

### Hops
- SP: Mínimo por construcción
- MO: Ligeramente mayor que SP
- Diferencia aceptable vs reducción en overlaps

### Schedulability Ratio
- MO > SP especialmente con alta densidad (λ=12)
- Mejora con más canales (m)
- Empeora con más flujos (n)

## 8.3 Tendencias Esperadas

```
SP vs MO:
- Overlaps: MO << SP
- Hops: MO ≥ SP (trade-off)
- Schedulability: MO > SP
```

---

# 9. DISCUSIÓN

## 9.1 Trade-offs

| Aspecto | SP | MO |
|---------|----|----|
| Overlaps | Alto | Bajo |
| Hops | Mínimo | Mayor |
| Schedulability | Menor | Mayor |

## 9.2 Limitaciones Reconocidas

1. Aproximación de FF-DBF (no implementación literal del paper)
2. Offset φ_i = 0 por defecto
3. Sin considerar múltiples gateways
4. Topología estática

## 9.3 Casos de Uso

MO beneficial cuando:
- Alta densidad de red (λ alto)
- Muchos flujos compitiendo
- Schedulability es prioritaria vs shortest path

---

# 10. CONCLUSIONES

## Resumen
MO proporciona mejor schedulability que SP al costo de rutas ligeramente más largas, especialmente en redes densas.

## Aporte Principal
Algoritmo MO con pesos acumulativos y penalización por nodos compartidos.

## Limitaciones y Trabajo Futuro
- Extender a múltiples gateways
- Incorporar offsets φ_i reales
- Evaluar en topologías dinámicas
- MO+ACO para exploración global

---

# APPENDIX: RESUMEN DE FÓRMULAS

## topología
```
Λ = λ / N                    (densidad de red)
```

## Routing
```
Ω = Σ_{i<j} Δ_ij             (overlaps total)
C_i = hops_i × w              (costo por flujo)
```

## Demand
```
dbf_i(ℓ) = max(0, ⌊(ℓ - D_i - φ_i)/T_i⌋ + 1) × C_i
contention(ℓ) = Σ_i dbf_i(ℓ) / m
conflict(ℓ) = Σ_{i<j} Δ_ij × max(⌈ℓ/T_i⌉, ⌈ℓ/T_j⌉)
```

## Schedulability
```
ℓ = k × T_i + D_i            (ventanas críticas)
∀ℓ: contention(ℓ) + conflict(ℓ) ≤ ℓ
```

---

# METADATOS PARA AGENTE

## Resumen de 3 líneas
Paper sobre routing en redes TSCH industriales que propone MO (Minimal Overlaps) para minimizar nodos compartidos entre rutas. Usa análisis EDF con demanda separada (contention + conflict) para evaluar schedulability. MO mejora significativamente la factibilidad vs SP, especialmente en redes densas, a costa de rutas ligeramente más largas.

## Términos clave
- `minimal_overlaps_routing`
- `tsch`
- `ieee_802.15.4e`
- `edf_scheduling`
- `conflict_demand`
- `contention_demand`
- `betweenness_centrality`
- `schedulability_analysis`
- `shortest_path`
- `routing_overlaps`

## Relevancia para proyecto NG-RES
CRÍTICO - Es el paper base. Toda la implementación replica y extiende este trabajo. El agente debe conocer cada fórmula, algoritmo y resultado para poder razonar sobre extensiones y mejoras.

## Quotes importantes
> "The system evaluates schedulability under EDF by separating contention and conflict demand over multiple time windows"
> "MO reduces overlaps at the cost of slightly longer routes"
> "Schedulability improves with MO especially at high density"

## Tags
`#routing` `#tsch` `#industrial_wireless` `#edf` `#scheduling` `#overlaps`