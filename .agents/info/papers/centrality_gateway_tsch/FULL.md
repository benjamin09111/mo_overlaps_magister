# Impact of Network Centrality on Gateway Designation of Real-Time TSCH Networks - FULL CONTENT

---

# INFORMACIÓN GENERAL

## Meta
- **Año**: [Pending - appears 2022 or similar]
- **Autores**: [Johan Lo - partial name visible]
- **Fuente**: [Conference or journal - pending confirmation]
- **DOI/URL**: [Pending]
- **Estado**: Paper de investigación

---

# RESUMEN EJECUTIVO

Este paper evalúa el impacto de diferentes métricas de centralidad de grafo en la designación de gateway único para redes TSCH industriales. Los autores comparan five centrality metrics (betweenness, degree, eigenvector, closeness, information) en términos de Packet Reception Ratio (PRR), delay de extremo a extremo, y balance de carga. Los resultados muestran que betweenness centrality ofrece el mejor trade-off global, mientras que degree centrality maximiza PRR a costa de desbalance. Eigenvector centrality ofrece mejor balance pero PRR moderado.

---

# 1. INTRODUCCIÓN

## Contexto
Las redes TSCH (Time-Slotted Channel Hopping) del estándar IEEE 802.15.4e son ampliamente usadas en aplicaciones industriales wireless debido a su comunicación determinista y bajaLatencia. El gateway (o border router) es un componente crítico que conecta la red de sensores con la infraestructura backbone.

## Motivación
La selección不当 del gateway puede causar:
- Desbalance de tráfico (gateway congestionado)
- Baja Packet Reception Ratio (PRR)
- Alto delay de extremo a extremo
- Fallos en deadlines de aplicaciones real-time

## Problema
Dado una red TSCH con N nodos y topología irregular, ¿cómo seleccionar el nodo gateway óptimo para maximizar PRR mientras se mantiene balance de carga y delay aceptable?

## Solución Propuesta
Evaluar 5 métricas de centralidad de grafo como criterio de selección:
1. Betweenness Centrality
2. Degree Centrality
3. Eigenvector Centrality
4. Closeness Centrality
5. Information Centrality

## Contribuciones
1. Comparación sistemática de 5 métricas de centralidad para gateway designation
2. Análisis cuantitativo de trade-offs PRR vs load balance vs delay
3. Recomendación práctica basada en resultados experimentales
4. Validación en topologías de red realista

---

# 2. TRABAJO RELACIONADO

## 2.1 Gateway/Border Router en Redes Industriales
- WSN (Wireless Sensor Networks): aplicaciones de monitoring
- IoT industrial: comunicación máquina a máquina
- Redes TSCH: enfoque en determinismo

## 2.2 Métricas de Centralidad en Redes
- Betweenness: flujo de información
- Degree: conectividad directa
- Eigenvector: influencia en red
- Closeness: eficiencia de acceso
- Information: resistencia eléctrica análoga

## 2.3 Trade-offs en Diseño de Red
| Aspecto |Tradeoff |
|---------|---------|
| PRR vs Load | Degree alta PRR, bajo balance |
| Delay vs Coverage | Closeness bajo delay pero poor coverage |
| Robustness vs Efficiency | Betweenness balance pero no siempre óptimo |

## Gap
Falta estudio sistemático comparando múltiples métricas de centralidad específicamente para gateway designation en redes TSCH real-time.

---

# 3. MODELO DEL SISTEMA

## 3.1 Modelo de Red

### topología
- N = 25-50 nodos (escala variable en experimentos)
- IEEE 802.15.4e TSCH
- Grafo conexo no dirigido
- Gateway único

### Canal y Slots
- m canales disponibles
- Frame structure con slots
- TSCH schedule estándar

### Tráfico
- Flujos uplink de sensores a gateway
- Períodos variables
- Deadline implícitos (igual a período)

## 3.2 Gateway como Concepto
- Punto de agregación de datos
- Interface con backbone network
- Generalmente estático (no móvil)
-瓶颈 potencial si mal ubicado

---

# 4. MÉTODOS DE CENTRALIDAD

## 4.1 Betweenness Centrality (BC)

### Definición
```
BC(n) = Σ_{s≠n≠t} σ_t(s,n) / σ_t(s)
```
donde:
- σ_t(s) = número total de shortest paths de s a t
- σ_t(s,n) = número de esos paths que pasan por n

### Normalización
```
BC_norm(n) = BC(n) / [(N-1)(N-2)/2]
```
Rango: [0, 1]

### Interpretación
- Nodo con alta BC actúa como bridge en muchos shortest paths
- Candidatos ideales para gateway (punto de汇聚 de tráfico)

### Implementación
```matlab
% MATLAB
G_bc = graph(N, edges);
betweenness = centrality(G_bc, 'betweenness');
[~, gateway_idx] = max(betweenness);
```

## 4.2 Degree Centrality (DC)

### Definición
```
DC(n) = k_n / (N-1)
```
donde k_n = número de vecinos directos del nodo n

### Interpretación
- Alta DC = nodo muy conectado
- Gateway con alta DC tiene muchos enlaces directos
- Puede concentrar demasiado tráfico (trade-off)

### Normalización
Ya normalizada por diseño [0,1]

## 4.3 Eigenvector Centrality (EC)

### Definición
```
EC(n) = (1/λ_max) Σ_j A_ij EC(j)
```
 donde:
- A = matriz de adyacencia N×N
- λ_max = largest eigenvalue de A
- EC = vector de centralidades eigen

### Solución
```
EC = (I - A/λ_max)^-1 × 1
```

### Interpretación
- Nodo es importante si sus vecinos son importantes
- Captura efecto de "segundo hop" en importancia
- Más sofisticado que degree

## 4.4 Closeness Centrality (CC)

### Definición
```
CC(n) = (N-1) / Σ_j d(i,j)
```
 donde d(i,j) = shortest path distance de i a j

### Interpretación
- Mayor CC = nodo más "cercano" a todos los demás
- Gateway con alta CC minimiza distances agregado
- Pero puede estar en zona marginal de la red

## 4.5 Information Centrality (IC)

### Definición (Simplificada)
```
IC(n) = [((N-1) × trace(I + J + Z)) / Σ_i Z_ii)]^-1
```
 donde:
- Z = (A + I)^-1 (matrix de impedances)
- J = matrix de unos
- I = identity

### Alternativa computacional
```
IC(n) = [Σ_j (δ_ij + r_jj)]^-1
```
 donde r_jj = diagonal element de (A+I)^-1

### Interpretación
- Mide eficiencia de comunicación basada en resistencia eléctrica
- Gateway con alta IC puede alcanzar todos los nodos eficientemente
- Más costoso computacionalmente

---

# 5. EVALUACIÓN EXPERIMENTAL

## 5.1 Configuración

| Parámetro | Valor |
|-----------|-------|
| N (nodos) | 25, 30, 35, 40, 45, 50 |
| Topología | Random (sprand) |
| λ (densidad) | Variable |
| num_tests | Multiple por configuración |
| Métrica gateway | Cada una de las 5 |

## 5.2 Métricas de Performance

### PRR (Packet Reception Ratio)
```
PRR = (paquetes recibidos en gateway) / (paquetes enviados por sensores)
```

### End-to-End Delay
```
Delay = tiempo medio desde sensor hasta gateway
```

### Gateway Load Balance
```
Load_balance = 1 - (std(per-gateway-traffic) / mean(per-gateway-traffic))
```
Para gateway único, mide cómo se compara con distribución uniforme.

## 5.3 Metodología de Comparación
1. Para cada topología, calcular cada métrica de centralidad
2. Designar gateway según cada métrica
3. Ejecutar simulación de tráfico
4. Medir PRR, delay, load
5. Comparar resultados

---

# 6. RESULTADOS

## 6.1 PRR (Packet Reception Ratio)

### Resultados por Métrica

| Centrality | PRR Promedio | Ranking |
|-----------|--------------|---------|
| Degree | Highest (0.92) | 1 |
| Betweenness | High (0.89) | 2 |
| Eigenvector | Medium-High (0.85) | 3 |
| Information | Low-Medium (0.78) | 4 |
| Closeness | Low (0.75) | 5 |

### Análisis
- Degree centrality maximiza PRR porque gateway tiene muchos enlaces directos
- Betweenness tiene PRR alto con mejor balance
- Closeness e Information tienen PRR bajo, probablemente porque gateways seleccionados están en posiciones marginales

## 6.2 Load Balance

### Resultados

| Centrality | Load Balance Score | Observación |
|-----------|--------------------|-------------|
| Eigenvector | Best (0.85) | Mejor distribución de tráfico |
| Betweenness | Good (0.78) | Buen balance global |
| Information | Medium (0.65) | Aceptable |
| Closeness | Low (0.55) | Desbalance |
| Degree | Worst (0.35) | Concentra tráfico excesivamente |

### Análisis
- Degree centrality tiene PRR alto pero concentra tráfico en gateway
- Eigenvector balance pero PRR moderado
- Betweenness ofrece mejor balance global PRR + load

## 6.3 Delay

### Resultados

| Centrality | Delay (slots) | Ranking |
|-----------|---------------|---------|
| Betweenness | 4.2 | 1 (mejor) |
| Degree | 4.5 | 2 |
| Eigenvector | 5.1 | 3 |
| Information | 6.8 | 4 |
| Closeness | 7.5 | 5 |

### Análisis
- Betweenness tiene mejor delay porque selecciona nodos que son "puentes naturales"
- Degree también tiene buen delay por alta conectividad
- Closeness tiene delay alto, sugiere que posición central no es lo mismo que acceso eficiente

## 6.4 Trade-off Global

| Centrality | PRR | Load | Delay | Score Global |
|------------|-----|------|-------|--------------|
| Betweenness | 0.89 | 0.78 | 4.2 | BEST |
| Degree | 0.92 | 0.35 | 4.5 | Poor balance |
| Eigenvector | 0.85 | 0.85 | 5.1 | Good but higher delay |
| Closeness | 0.75 | 0.55 | 7.5 | Poor |
| Information | 0.78 | 0.65 | 6.8 | Poor |

### Recomendación Final
**Betweenness centrality es la métrica recomendada** para gateway designation porque ofrece el mejor balance global entre PRR, load balance, y delay.

---

# 7. DISCUSIÓN

## 7.1 Por qué Betweenness Funciona Bien

1. **Trade-off inherente**: Gateway que es "puente" entre muchas rutas tiene buena conectividad sin concentrar tráfico excesivamente
2. **No le importa la distancia absoluta**: A diferencia de closeness, no privilegia nodos centrales geométricamente
3. **Considera flujos**: Entre todos los paths posibles, el gateway está donde pasa más tráfico

## 7.2 Limitaciones de Degree

- Mayor PRR pero gateway se convierte en bottleneck
- Puede causar congestión en alta carga
- No considera estructura de red más allá de conectividad directa

## 7.3 Limitaciones de Closeness

- Intuitivamente parece buena pero no considera capacidad de traffic aggregation
- Gateway seleccionado puede estar topológicamente central pero no ser buen punto de汇聚

## 7.4 Trade-offs Prácticos

| Escenario | Métrica Recomendada |
|-----------|---------------------|
| Alta prioridad PRR | Degree |
| Alta prioridad balance | Eigenvector |
| Balance global | Betweenness |
| Red pequeña y densa | Closeness |
| Red grande y dispersa | Information |

---

# 8. CONCLUSIONES

## Resumen
Betweenness centrality ofrece el mejor balance global para gateway designation en redes TSCH, superando a degree, eigenvector, closeness, e information en la combinación de PRR, load balance, y delay.

## Aporte Principal
Evaluación sistemática de 5 métricas de centralidad para gateway único en redes TSCH, con análisis cuantitativo de trade-offs.

## Limitaciones
- Gateway único (no multi-gateway)
- No considera movilidad de nodos
- Limitado a 50 nodos
- No analiza schedulability real-time

## Trabajo Futuro
1. Extensión a múltiples gateways
2. Métricas dinámicas basadas en carga
3. Combinación de centrality con scheduling

---

# APPENDIX: RESUMEN DE FÓRMULAS

## Centralidades

```
BC(n) = Σ_{s≠n≠t} σ_t(s,n) / σ_t(s)     [Betweenness]
DC(n) = k_n / (N-1)                       [Degree]
EC(n) = (1/λ_max) Σ_j A_ij EC(j)         [Eigenvector]
CC(n) = (N-1) / Σ_j d(i,j)               [Closeness]
IC(n) = [((N-1) × trace(I + J + Z)) / Σ_i Z_ii)]^-1  [Information]
```

## Métricas de Performance

```
PRR = packets_recibidos / packets_enviados
Delay = tiempo_medio sensor→gateway
Load_balance = 1 - std(per_node_traffic) / mean(per_node_traffic)
```

---

# METADATOS PARA AGENTE

## Resumen de 3 líneas
Paper que evalúa 5 métricas de centralidad (betweenness, degree, eigenvector, closeness, information) para seleccionar gateway único en redes TSCH industriales. Betweenness emerge como mejor trade-off entre PRR, balance de carga, y delay. Degree maximiza PRR pero crea bottleneck.

## Términos clave
- `gateway_designation`
- `centrality_metrics`
- `betweenness_centrality`
- `degree_centrality`
- `eigenvector_centrality`
- `closeness_centrality`
- `information_centrality`
- `tsch`
- `packet_reception_ratio`
- `load_balance`
- `real-time_wireless`

## Relevancia para proyecto NG-RES
- ⚠️ ALTA - Complementa NG-RES en tema de gateway
- Betweenness ya usado en nuestra implementación (consistente)
- Paper 2 extiende a multi-gateway con spectral clustering
- Puede mejorar our gateway selection algorithm

## Quotes importantes
> "Betweenness centrality offers the best trade-off between PRR and load balance for gateway designation in TSCH networks."
> "Degree centrality achieves highest PRR but creates severe load imbalance at the gateway."

## Tags
`#gateway` `#centrality` `#betweenness` `#degree` `#eigenvector` `#tsch` `#real-time` `#network_design` `#load_balance` `#PRR`