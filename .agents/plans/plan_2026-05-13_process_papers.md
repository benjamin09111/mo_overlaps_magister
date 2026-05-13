# Plan: Procesamiento de Papers del Profesor

## Fecha
2026-05-13

## Objetivo
Leer y procesar los 2 papers PDF entregados, integrar su conocimiento en `.agents` para uso futuro en la tesis.

---

## Archivos a Procesar

| # | Paper | Archivo PDF | Tema |
|---|-------|-------------|------|
| 1 | Impact of Network Centrality on Gateway Designation | `Impact_of_network_centrality_on_the_gateway_designation_of_real-time_TSCH_networks (1).pdf` | Gateway único, centralidad |
| 2 | Multigateway Designation for Real-Time TSCH Networks | `Multigateway_Designation_for_Real-Time_TSCH_Networks_Using_Spectral_Clustering_and_Centrality.pdf` | Múltiples gateways, spectral clustering |

---

## Plan de Acción

### Phase 1: Paper 1 - Centrality Gateway

#### Paso 1: Extraer información estructurada
- [ ] Título completo y metadata
- [ ] Autores y afiliaciones
- [ ] Año y fuente de publicación
- [ ] Abstract completo

#### Paso 2: Metodología
- [ ] Modelo de red (N,topología,canales)
- [ ] Definición de centralidad (betweenness, grado, eigenvector, etc.)
- [ ] Algoritmo de selección de gateway
- [ ] Métricas de evaluación

#### Paso 3: Resultados
- [ ] Resultados principales de centralidad vs throughput/latencia
- [ ] Comparación entre métricas de centralidad
- [ ] Recomendaciones de diseño

#### Paso 4: Fórmulas y modelos
- [ ] Definiciones matemáticas de centralidad
- [ ] Modelo de scheduling si hay
- [ ] Métricas de performance

#### Paso 5: Crear documentos .agents
- [ ] `SUMMARY.md` (1-2 páginas)
- [ ] `FULL.md` (contenido completo)
- [ ] Actualizar `PAPERS_INDEX.md`

---

### Phase 2: Paper 2 - Multigateway

#### Paso 1: Extraer información estructurada
- [ ] Título completo y metadata
- [ ] Autores y afiliaciones
- [ ] Año y fuente de publicación
- [ ] Abstract completo

#### Paso 2: Metodología
- [ ] Modelo de red con múltiples gateways
- [ ] Spectral clustering (qué es, cómo se aplica)
- [ ] Algoritmo de designation de gateways
- [ ] Asignación de sensores a gateways

#### Paso 3: Resultados
- [ ] Mejoras vs gateway único
- [ ] Comparación spectral vs otros métodos
- [ ] Impacto en schedulability

#### Paso 4: Fórmulas y modelos
- [ ] Spectral clustering: fórmula de Laplacian, cuts
- [ ] Metricas de cobertura o segregación
- [ ] Análisis de real-time

#### Paso 5: Crear documentos .agents
- [ ] `SUMMARY.md` (1-2 páginas)
- [ ] `FULL.md` (contenido completo)
- [ ] Actualizar `PAPERS_INDEX.md`

---

### Phase 3: Integración

#### Paso 1: Comparar con NG-RES 2021
- [ ] Identificar similitudes
- [ ] Identificar diferencias
- [ ] Identificar gaps que podemos atacar

#### Paso 2: Identificar aplicaciones a nuestra tesis
- [ ] Mejoras potenciales a MO routing
- [ ] Extensiones multi-gateway
- [ ] Métricas de centralidad aplicables

#### Paso 3: Documentar en master_project_document
- [ ] Nueva sección de work relacionado
- [ ] Oportunidades de extensión

---

## Validación
- [ ] Ambos papers integrados en `.agents`
- [ ] `PAPERS_INDEX.md` actualizado con 3 papers
- [ ] Agent puede razonar sobre los 3 papers
- [ ] Documentado relación con NG-RES 2021

## Dependencias
Ninguna - trabajo listo para comenzar

## Tiempo Estimado
- Paper 1: 30-45 minutos
- Paper 2: 30-45 minutos
- Integración: 15-20 minutos
- Total: ~90 minutos

---

## Instrucciones de Ejecución

El agente debe:
1. Leer cada PDF usando la herramienta Read
2. Extraer toda la información siguiendo la estructura de los templates
3. Crear `SUMMARY.md` y `FULL.md` para cada paper
4. Actualizar `PAPERS_INDEX.md`
5. Crear sección de integración en `master_project_document.md`

---

## Nota para el Agente

Después de ejecutar este plan, el agente tendrá conocimiento profundo de:
- Paper 1: Cómo la centralidad afecta la designación de gateway en redes TSCH
- Paper 2: Cómo usar spectral clustering para múltiples gateways en redes real-time
- NG-RES 2021: MO routing para minimizar overlaps

Esto permitirá:
- Proponer extensiones a MO con multi-gateway
- Usar centralidad para mejorar selección de gateway
- Comparar y contrastar resultados con papers existentes