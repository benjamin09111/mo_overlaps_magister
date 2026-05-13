# Papers Folder - README

Esta carpeta contiene todos los papers procesados que alimentan al agente.

---

## 📁 Estructura

Cada paper vive en su propia carpeta:

```
papers/
├── PAPER_NAME/
│   ├── SUMMARY.md      ← Resumen de 1-2 páginas (lectura rápida)
│   └── FULL.md        ← Contenido completo (consulta detallada)
└── _templates/
    ├── papers_template_summary.md
    └── papers_template_full.md
```

---

## 📖 Cómo usar

### Para lectura rápida (contexto)
→ Leer `SUMMARY.md`

### Para investigación profunda
→ Leer `FULL.md`

### Para agregar un nuevo paper
→ Usar templates en `_templates/`

---

## 📝 Plantillas

### Summary Template
Archivo: `papers_template_summary.md`

Campos:
- Meta (año, autores, fuente)
- Tema principal (1-2 frases)
- Problema que resuelve
- Aporte clave
- Metodología resumida
- Fórmulas clave
- Resultados principales
- Relación con proyecto NG-RES

### Full Template
Archivo: `papers_template_full.md`

Campos:
- Información general completa
- Introducción detallada
- Background
- Modelo/Sistema
- Metodología
- Fórmulas
- Implementación
- Resultados
- Discusión
- Conclusiones
- Metadatos para agente

---

## 🚀 Proceso para agregar paper nuevo

### Paso 1: Preparar
- Obtener PDF del paper
- Tener claro el tema y relevancia para la tesis

### Paso 2: Extraer Summary
- Leer abstract e introducción
- Identificar metodología clave
- Anotar fórmulas importantes
- Comparar con NG-RES 2021
- Crear `papers/NOMBRE_PAPER/SUMMARY.md`

### Paso 3: Extraer Full Content
- Leer paper completo
- Estructurar por secciones
- Documentar todas las fórmulas
- Anotar resultados específicos
- Crear `papers/NOMBRE_PAPER/FULL.md`

### Paso 4: Actualizar Index
- Editar `PAPERS_INDEX.md`
- Agregar paper con estado y ubicación

### Paso 5: Actualizar AGENTS.md (si es core)
- Si el paper es fundamental para el proyecto, agregar referencia en AGENTS.md

---

## 🎯 Criterios de Calidad

### Summary debe tener:
✅ Tema principal claro (1-2 frases)
✅ Aporte clave identificado
✅ 2-5 fórmulas principales
✅ Relación con proyecto NG-RES explícita
✅ Tags relevantes

### Full debe tener:
✅ Todas las secciones del paper
✅ Todas las fórmulas documentadas
✅ Metadatos para agente al final
✅ Quotes importantes para citación
✅ Análisis de limitaciones

---

## 📊 Estado Actual

| Paper | Summary | Full | Fecha |
|-------|---------|------|-------|
| NG-RES 2021 | ✅ | ✅ | 2026-05-13 |

---

## 📅 Historial

- **2026-05-13**: Creada estructura base con templates