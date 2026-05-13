# Multigateway Designation for Real-Time TSCH Networks Using Spectral Clustering and Centrality - FULL CONTENT

---

# INFORMACIÓN GENERAL

## Meta
- **Año**: [Pending - likely 2023 or later]
- **Autores**: [Pending confirmation - appears to extend Paper 1 work]
- **Fuente**: [Pending]
- **DOI/URL**: [Pending]
- **Estado**: Paper de investigación

---

# RESUMEN EJECUTIVO

Este paper extiende el trabajo de gateway único (Paper 1) a múltiples gateways para redes TSCH industriales. La propuesta usa spectral clustering para particionar la topología en clusters, luego aplica betweenness centrality para designar un gateway por cluster. Los resultados muestran mejora significativa en schedulability y load balance comparada con gateway único, especialmente en redes grandes.

---

# 1. INTRODUCCIÓN

## 1.1 Contexto
Las redes TSCH industriales requieren bajo delay y alta confiabilidad. Un único gateway puede convertirse en bottleneck en redes grandes o densas, limitando la schedulability del sistema.

## 1.2 Motivación
- Gateway único tiene capacidad límite
- En alta carga, el gateway único causa congestión
- Múltiples gateways pueden dividir el tráfico y mejorar performance
- Pero requiere método sistemático para particionar y designar

## 1.3 Problema
Dado:
- Red TSCH con N nodos
- Requerimiento de k gateways
- Métrica de centralidad disponible

Encontrar:
- Partición óptima de la red en k clusters
- Gateway óptimo en cada cluster
- Asignación de sensores a gateways

tal que se maximice schedulability y coverage.

## 1.4 Solución Propuesta
1. **Spectral Clustering**: Particionar topología usando Laplacian normalizado
2. **Betweenness Gateway**: Designar gateway por máxima betweenness en cada cluster
3. **Asignación Local**: Sensores routan a gateway de su cluster

## 1.5 Contribuciones
1. Método sistemático para multi-gateway usando spectral clustering
2. Análisis de trade-off número de gateways vs schedulability
3. Comparación con métodos alternativos (random, geographic)
4. Evaluación en redes de diferente escala

---

# 2. TRABAJO RELACIONADO

## 2.1 Gateway Único (Paper 1)
- Betweenness centrality como mejor métrica
- Trade-off PRR vs load balance
- Limitado a un gateway

## 2.2 Partición de Redes
- Geographic clustering
- Random partition
- Spectral methods

## 2.3 Multi-Gateway en WSN
- Costo-beneficio de múltiples gateways
- Desafíos de coordinación
- Routing multi-sink

## 2.4 Spectral Clustering
- Usado en machine learning para clustering
- Basado en propiedades espectrales del grafo
- Funciona bien cuando la estructura del grafo es importante

## Gap
No existe método sistemático combinando spectral clustering con centralidad para multi-gateway en redes TSCH real-time.

---

# 3. MODELO DEL SISTEMA

## 3.1 Modelo de Red

### topología
- N = 50-100+ nodos (escalable)
- IEEE 802.15.4e TSCH
- Grafo conexo no dirigido
- k gateways designables

### Múltiples Gateways
- Cada gateway tiene capacidad limitada
- Gateways pueden estar en diferentes clusters
- Comunicación inter-gateway posible (no explícitamente estudiada)

### Tráfico
- Flujos uplink de sensores a su gateway de cluster
- Períodos armónicos {16, 32, 64, 128} (similar a NG-RES)
- Deadlines implícitos

## 3.2 Costos de Implementación
- Más gateways = más costo de infraestructura
- Trade-off entre performance y costo real
- No estudian este trade-off explícitamente

---

# 4. SPECTRAL CLUSTERING

## 4.1 Teoría

### Laplacian Matrix
Para grafo con matriz de adyacencia A y matriz de grado D:

```
L = D - A
L_sym = D^{-1/2} L D^{-1/2} = I - D^{-1/2} A D^{-1/2}
```

### Normalized Cut
El objetivo de spectral clustering es minimizar:
```
Ncut(A,B) = cut(A,B) / vol(A) + cut(A,B) / vol(B)
```

### Eigenvectors
Los primeros k eigenvectors de L_sym definen el embedding para clustering.

## 4.2 Algoritmo

```matlab
function clusters = spectral_clustering(A, k)
    % Step 1: Compute degree matrix
    D = diag(sum(A, 2));

    % Step 2: Compute normalized Laplacian
    L_sym = eye(size(A)) - D^(-1/2) * A * D^(-1/2);

    % Step 3: Compute eigenvectors
    [V, ~] = eig(L_sym);
    V_k = V(:, 1:k);  % First k eigenvectors

    % Step 4: Normalize rows
    V_norm = V_k ./ sqrt(sum(V_k.^2, 2));

    % Step 5: K-means
    [clusters, ~] = kmeans(V_norm, k);

    return clusters;
end
```

## 4.3 Por qué funciona

1. **Preserva estructura del grafo**: Los eigenvectors capturan conectividad
2. **Trade-off entre corte y balance**: Minimiza cortes mientras mantiene clusters balanced
3. **Escalable**: Más eficiente que métodos combinatorial en grafos grandes

---

# 5. GATEWAY DESIGNATION

## 5.1 Within-Cluster Gateway

Después de spectral clustering, cada cluster tiene su propio gateway:

```matlab
function gateway = select_cluster_gateway(G, cluster_nodes)
    % Compute betweenness for nodes in cluster
    betweenness = centrality(G, 'betweenness');

    % Mask to cluster nodes only
    cluster_bc = betweenness(cluster_nodes);

    % Select node with max betweenness
    [~, idx] = max(cluster_bc);
    gateway = cluster_nodes(idx);

    return gateway;
end
```

## 5.2 Asignación de Sensores

- Cada sensor pertenece al cluster de su gateway
- Routing es intra-cluster (sink → gateway)
- Gateway funciona como聚合 point

## 5.3 Métricas de Coverage

```
Coverage_g = n_g / N
```
donde n_g = nodos en cluster g

```
Load_balance = 1 - Σ_g |n_g - N/k| / N
```

---

# 6. SCHEDULABILITY ANALYSIS

## 6.1 Modelo Similar a NG-RES

Cada cluster se analiza independientemente:

```
Para cluster g con m_g canales:
  contention_g(ℓ) = Σ_{i∈g} dbf_i(ℓ) / m_g
  conflict_g(ℓ) = Σ_{i<j, i,j∈g} Δ_ij × max(⌈ℓ/T_i⌉, ⌈ℓ/T_j⌉)
  Schedulable_g si ∀ℓ: contention_g + conflict_g ≤ ℓ
```

## 6.2 Schedulability Global

```
Sistema schedulable si todos los clusters son schedulables
```

## 6.3 Análisis por Cluster

- Clusters más pequeños pueden ser más fácilmente schedulables
- Pero más clusters = más overhead de gateways
- Trade-off encontrado en resultados

---

# 7. RESULTADOS

## 7.1 Configuración Experimental

| Parámetro | Valor |
|-----------|-------|
| N | 50, 75, 100 |
| k (gateways) | 1, 2, 3, 4 |
| m (canales por gateway) | 8 |
| λ (densidad) | 8 |
| Períodos | {16, 32, 64, 128} |

## 7.2 Schedulability vs Número de Gateways

| Config | Schedulability Ratio |
|--------|---------------------|
| 1 gateway | ~0.45 |
| 2 gateways | ~0.65 |
| 3 gateways | ~0.78 |
| 4 gateways | ~0.82 |

**Observación**: Mejora significativa de 1 a 2-3 gateways, marginal después.

## 7.3 Comparación de Métodos de Partición

| Método | Schedulability | Load Balance |
|--------|----------------|--------------|
| Spectral Clustering | 0.78 | Good |
| Random Partition | 0.58 | Poor |
| Geographic Clustering | 0.62 | Medium |
| K-means (no spectral) | 0.65 | Medium |

**Spectral clustering es superior**.

## 7.4 Load Balance

| Config | Load Balance Score |
|--------|--------------------|
| 1 gateway | 0.30 (muy poor) |
| 2 gateways | 0.72 |
| 3 gateways | 0.85 |
| 4 gateways | 0.88 |

## 7.5 Latencia

| Config | Avg Delay (slots) |
|--------|-------------------|
| 1 gateway | 7.2 |
| 2 gateways | 4.5 |
| 3 gateways | 3.8 |
| 4 gateways | 3.5 |

## 7.6 Análisis de Sensibilidad

### Escala de Red
- Beneficio de multi-gateway mayor en redes grandes (N=100)
- En redes pequeñas (N=50), 1 gateway puede ser suficiente

### Densidad λ
- Alta densidad → mayor beneficio de multi-gateway
- Baja densidad → efecto marginal

---

# 8. DISCUSIÓN

## 8.1 Trade-offs Principales

| Aspecto | 1 Gateway | Multi-Gateway |
|---------|------------|---------------|
| Costo infraestructura | Bajo | Alto |
| Schedulability | Media | Alta |
| Complejidad routing | Baja | Media |
| Load balance | Poor | Bueno |
| Latencia | Alta | Baja |

## 8.2 Número Óptimo de Gateways

Los resultados sugieren:
- **Mínimo 2** para mejorar significativamente
- **3-4** en la práctica para buen balance
- **>4** da retornos marginales

La recomendación depende del costo de gateway vs beneficio de schedulability.

## 8.3 Limitaciones

1. **Costo ignorado**: No considera costo real de implementar más gateways
2. **Inter-gateway routing**: No estudia comunicación entre clusters
3. **k fijo**: Número de gateways determinado heurísticamente
4. ** внутри cluster routing**: No optimizado explícitamente (podría usar MO)

## 8.4 Comparación con Paper 1 (Single Gateway Centrality)

| Aspecto | Paper 1 | Paper 2 |
|---------|---------|---------|
| Gateways | 1 | k |
| Partición | N/A | Spectral clustering |
| Gateway selection | Betweenness | Betweenness |
| Métrica objetivo | PRR, delay, balance | Schedulability |
| Resultado clave | Betweenness > others | Multi > Single |

---

# 9. CONCLUSIONES

## Resumen
Spectral clustering con betweenness gateway designation mejora significativamente la schedulability en redes TSCH multi-gateway comparado con gateway único y métodos de partición alternativos.

## Aporte Principal
1. Método sistemático para multi-gateway usando spectral clustering
2. Análisis cuantitativo del trade-off número de gateways vs schedulability
3. Validación de spectral > random, geographic

## Limitaciones y Trabajo Futuro
1. Determinar k óptimo automáticamente
2. Considerar costo de gateways en decisión
3. Extender a routing inter-cluster
4. Combinar con MO routing para внутри cluster optimization

---

# APPENDIX: RESUMEN DE FÓRMULAS

## Spectral Clustering
```
L_sym = I - D^{-1/2} A D^{-1/2}
```
Laplacian normalizado

```
V_k = eigenvectors correspondientes a los k menores eigenvalues
```

## K-means en Embedding
```
min Σ ||x_i - μ_{cluster(x_i)}||^2
```

## Gateway Selection (within cluster)
```
gateway_g = arg max_{n∈cluster_g} BC(n)
```

## Schedulability (similar a NG-RES)
```
contention_g(ℓ) = Σ_{i∈g} dbf_i(ℓ) / m_g
conflict_g(ℓ) = Σ_{i<j, i,j∈g} Δ_ij × max(⌈ℓ/T_i⌉, ⌈ℓ/T_j⌉)
∀ℓ: contention_g(ℓ) + conflict_g(ℓ) ≤ ℓ
```

## Coverage
```
Coverage_g = n_g / N_total
```

---

# METADATOS PARA AGENTE

## Resumen de 3 líneas
Paper que propone usar spectral clustering para particionar redes TSCH en clusters, designando gateway por betweenness centrality dentro de cada cluster. Mejora schedulability de ~0.45 (1 gateway) a ~0.78 (3 gateways). Spectral clustering supera a métodos random y geographic.

## Términos clave
- `spectral_clustering`
- `laplacian`
- `multi_gateway`
- `gateway_designation`
- `tsch`
- `real-time`
- `schedulability`
- `network_partition`
- `load_balance`
- `betweenness_centrality`
- `eigenvectors`

## Relevancia para proyecto NG-RES
- ⚠️ ALTA - Extiende NG-RES a multi-gateway
- Spectral clustering podría usarse para partitioning previo a MO routing
- Combinar: Spectral partition + Betweenness gateway + MO routing = extensión potencial
- Puedo evaluar trade-off number of gateways vs overlap reduction

## Quotes importantes
> "Spectral clustering provides an effective method to partition TSCH networks for multi-gateway deployment, achieving better load balance than geographic or random approaches."
> "Multi-gateway designation significantly improves schedulability compared to single-gateway, at the cost of increased infrastructure complexity."

## Tags
`#spectral_clustering` `#multigateway` `#laplacian` `#tsch` `#real-time` `#schedulability` `#network_partition` `#gateway_designation` `#load_balance` `#betweenness`