# Impact of Network Centrality on Gateway Designation of Real-Time TSCH Networks - SUMMARY

## Meta
- **Año**: [Pending - appears to be 2022 or similar]
- **Autores**: [Johan Lo - nombre parcial en text]
- **Fuente**: [Pending confirmation]
- **DOI/URL**: [Pending]

## Tema Principal
Estudio del impacto de diferentes métricas de centralidad en la selección de gateway único en redes TSCH industriales, evaluando trade-offs entre Packet Reception Ratio (PRR), delay y load balance.

## Problema que Resuelve
Cómo seleccionar el gateway óptimo en una red TSCH para maximizar performance (PRR, delay) mientras se mantiene balance de carga, usando diferentes métricas de centralidad de grafo.

## Aporte Clave
Comparación sistemática de 5 métricas de centralidad (betweenness, degree, eigenvector, closeness, information) para designation de gateway, con análisis de trade-offs prácticos. Betweenness emerge como mejor balance general.

## Metodología Resumida

### Paso 1: Modelo de Red
- IEEE 802.15.4e TSCH
- N = 25-50 nodos (escala variable)
- Gateway único designado
- Canales y slots definidos

### Paso 2: Métricas de Centralidad
Para cada nodo n calcular:
- **Betweenness**: Fracción de paths más cortos que pasan por n
- **Degree**: Normalización del grado del nodo
- **Eigenvector**: Influencia basada en centralidad de vecinos
- **Closeness**: Inverso de la suma de distancias
- **Information**: Eficiencia de comunicación basada en resistencia

### Paso 3: Simulación/Experimentación
- Comparar cada métrica contra:
  - PRR (Packet Reception Ratio)
  - End-to-end delay
  - Gateway load balance
- topología variable (densidad λ)

### Paso 4: Análisis de Trade-offs
- Evaluar cuál métrica ofrece mejor balance global
- Considerar escenarios específicos (alta densidad, baja densidad)

## Fórmulas Clave

### Betweenness Centrality
```
BC(n) = Σ_{s≠n≠t} σ_t(s,n) / σ_t(s)
```
- σ_t(s) = número de shortest paths s→t
- σ_t(s,n) = número que pasan por n

### Degree Centrality
```
DC(n) = k_n / (N-1)
```
- k_n = grado del nodo n
- Normalizada [0,1]

### Eigenvector Centrality
```
EC(n) = (1/λ_max) Σ_j A_ij EC(j)
```
- A = matriz de adyacencia
- λ_max = largest eigenvalue

### Closeness Centrality
```
CC(n) = (N-1) / Σ_j d(i,j)
```
- d(i,j) = shortest path distance
- Mayor = más central

### Information Centrality
```
IC(n) = [((N-1) × trace(I + J + Z)) / Σ_i Z_ii)]^-1
```
- Z = matrix de impedances
- J = matrix de unos
- captura eficiencia de comunicación

## Resultados Principales

### PRR (Packet Reception Ratio)
| Métrica | PRR | Observación |
|---------|-----|-------------|
| Betweenness | Alto | Mejor balance |
| Degree | Muy alto | Mejor PRR puro |
| Eigenvector | Medio-alto | Buen balance |
| Closeness | Bajo | Poor en general |
| Information | Bajo | Poor en general |

### Load Balance
| Métrica | Balance | Observación |
|---------|---------|-------------|
| Betweenness | Bueno | Mejor global |
| Degree | Poor | Concentra tráfico |
| Eigenvector | Muy bueno | Mejor balance |
| Closeness | Poor | Desbalance |
| Information | Medio | Aceptable |

### Delay
| Métrica | Delay | Observación |
|---------|-------|-------------|
| Betweenness | Bajo | Recomendado |
| Degree | Bajo | Similar a Betweenness |
| Eigenvector | Medio | Aceptable |
| Closeness | Alto | Peor |
| Information | Alto | Peor |

### Recomendación Final
**Betweenness** como métrica default para gateway selection:
- Mejor balance global PRR + load + delay
- Robusto a diferentes densidades de red

## Topologías y Datasets
- Redes de 25-50 nodos
- Topologías generadas con sprand (similar a NG-RES)
- Comparación con ground truth (manual placement)

## Limitaciones
- Gateway único (no multi-gateway)
- No considera spectral methods
- Limited scale (50 nodos max mentioned)
- No analiza schedulability explícitamente

## Relación con Nuestro Proyecto (NG-RES 2021)

### Similitudes
- Mismo tipo de red: IEEE 802.15.4e TSCH
- Mismo enfoque de topología: sprand, random
- Betweenness como métrica de gateway (presente en ambos)
- Evaluación de performance

### Diferencias
- NG-RES usa gateway único pero se enfoca en routing MO
- Este paper no evalúa routing, solo gateway selection
- Este paper no tiene análisis de schedulability EDF
- NG-RES tiene 66 nodos, este paper usa 25-50

### Útil Para
- Mejorar selección de gateway en nuestra implementación
- Entender trade-offs entre métricas de centralidad
- Extensión multi-gateway (con Paper 2)
- Métricas de load balance para evaluar gateway coverage

## Frases Clave del Paper

> "Betweenness centrality offers the best trade-off between PRR and load balance for gateway designation in TSCH networks."

> "Degree centrality achieves highest PRR but creates severe load imbalance at the gateway."

## Notas Personales
- ⚠️ CRÍTICO: Este paper complementa NG-RES - juntos cubren gateway selection + routing
- Betweenness es la métrica recomendada para gateway en ambos papers
- Para extender a multi-gateway, Paper 2 usa spectral clustering

## Tags
`#gateway` `#centrality` `#betweenness` `#tsch` `#real-time` `#network_design` `#load_balance`