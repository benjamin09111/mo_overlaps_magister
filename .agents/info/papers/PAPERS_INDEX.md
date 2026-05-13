# Papers Index

Este archivo es el punto de entrada principal. El agente conoce y puede razonar sobre todos los papers listados aquí.

---

## 🎯 Cómo usar este index

Antes de cualquier tarea, el agente debe:
1. Leer este index para saber qué papers conoce
2. Consultar el summary card del paper relevante
3. Acceder al full content solo si necesita detalles específicos

---

## 📚 Papers en Conocimiento

### 1. NG-RES 2021 - Routing con Mínima Superposición en TSCH
**Año**: 2021
**Autores**: [Pending confirmation]
**Tema**: Routing con mínima superposición en redes IEEE 802.15.4e TSCH
**Resumen**: Paper de referencia principal. Propone algoritmo MO (Minimal Overlaps) que minimiza nodos compartidos entre rutas para mejorar schedulability bajo EDF. Compara SP vs MO en redes de 66 nodos con diferentes densidades.
**Estado**: ✅ Dominio completo
**Relevancia**: CRÍTICO - Es el paper base de la tesis
**Carpeta**: `papers/ng_res_2021/`
**Resumen**: `./papers/ng_res_2021/SUMMARY.md`
**Full**: `./papers/ng_res_2021/FULL.md`

---

### 2. Impact of Network Centrality on Gateway Designation of Real-Time TSCH Networks
**Año**: [Pending - appears 2022]
**Autores**: Johan Lo y colaboradores
**Tema**: Selección de gateway único usando métricas de centralidad
**Resumen**: Evalúa 5 métricas de centralidad (betweenness, degree, eigenvector, closeness, information) para gateway único en redes TSCH. Betweenness ofrece mejor trade-off entre PRR, load balance, y delay.
**Estado**: ✅ Dominio completo
**Relevancia**: ALTA - Complementa NG-RES en tema de gateway
**Carpeta**: `papers/centrality_gateway_tsch/`
**Resumen**: `./papers/centrality_gateway_tsch/SUMMARY.md`
**Full**: `./papers/centrality_gateway_tsch/FULL.md`

---

### 3. Multigateway Designation for Real-Time TSCH Networks Using Spectral Clustering and Centrality
**Año**: [Pending - likely 2023+]
**Autores**: [Pending confirmation]
**Tema**: Múltiples gateways usando spectral clustering
**Resumen**: Extiende a múltiples gateways usando spectral clustering para particionar la red, con betweenness gateway dentro de cada cluster. Mejora schedulability de ~0.45 (1 gateway) a ~0.78 (3 gateways).
**Estado**: ✅ Dominio completo
**Relevancia**: ALTA - Base para extensión multi-gateway
**Carpeta**: `papers/multigateway_spectral_tsch/`
**Resumen**: `./papers/multigateway_spectral_tsch/SUMMARY.md`
**Full**: `./papers/multigateway_spectral_tsch/FULL.md`

---

## 📋 Agregar Nuevo Paper

Usar estructura:
```
papers/
├── paper_name/
│   ├── SUMMARY.md
│   └── FULL.md
```

Templates disponibles en `_templates/`

---

## 🔄 Proceso para Nuevos Papers

1. Copiar templates a nueva carpeta
2. Extraer summary card (1-2 páginas)
3. Extraer full content
4. Actualizar este index
5. Actualizar AGENTS.md si es core knowledge

---

## 📊 Estadísticas de Dominio

| Paper | Dominio | Resumen | Full | Relevancia |
|-------|---------|---------|------|------------|
| NG-RES 2021 | ✅ Completo | ✅ | ✅ | CRÍTICO |
| Centrality Gateway | ✅ Completo | ✅ | ✅ | ALTA |
| Multigateway Spectral | ✅ Completo | ✅ | ✅ | ALTA |

---

## 🚀 Próximos Papers (Pendientes)

- [ ] Paper de profesor #4 (por recibir)
- [ ] Paper de profesor #5 (por recibir)
- [ ] Paper de profesor #6 (por recibir)

---

## 📚 Guía de Uso Rápido

| Necesito... | Leo... |
|-------------|--------|
| Contexto general | PAPERS_INDEX.md (este archivo) |
| Resumen rápido | `papers/NOMBRE/SUMMARY.md` |
| Detalle completo | `papers/NOMBRE/FULL.md` |
| Templates | `papers/_templates/` |
| Qué conoce el agente | AGENTS.md → info/papers_context.md |

---

## 🔗 Relación entre Papers

```
Paper 1 (Centrality Gateway)
    └── Selección de gateway único con betweenness
            ↓
Paper 2 (Multigateway Spectral)
    └── Extensión a múltiples gateways con spectral clustering
            ↓
Paper 3 (NG-RES 2021)
    └── MO routing para minimizar overlaps
            ↓
    Extensión potencial: Multi-gateway + Spectral + MO routing
```

---

## 🎯 Insights para la Tesis

### Oportunidades de Extensión Identificadas

1. **MO + Multi-gateway**: Combinar MO routing con múltiples gateways
2. **Spectral + Betweenness + MO**: Partición espectral → gateway betweenness → MO routing
3. **Trade-off número de gateways**: Evaluar overlap reduction vs número de gateways
4. **Schedulability mejorada**: Multi-gateway puede mejorar schedulability más que MO solo

### Métricas Clave Comparadas

| Métrica | Paper 1 | Paper 2 | Paper 3 (NG-RES) |
|---------|---------|---------|------------------|
| Gateway | Único | Múltiples | Único |
| Método | Centralidad | Spectral + Centrality | SP → MO |
| Objetivo | PRR, balance | Schedulability | Overlaps, schedulability |
| Resultado | BC mejor | 3 gateways = 0.78 | MO mejora sched. |