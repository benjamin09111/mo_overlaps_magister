# Documentation Index

Esta carpeta contiene la documentación detallada de cada avance del proyecto.

## Estructura de Nombres

`YYYY-MM-DD_nombre_del_avance.md`

---

## Documentos Disponibles

| Fecha | Documento | Descripción |
|-------|-----------|-------------|
| - | document.md | Documentación viva de decisiones de fidelidad (carpeta raíz) |
| 2026-05-13 | doc_2026-05-13_gateway_single_paper_replication.md | Replica single-gateway N=80 Degree/Random + Deviation |
| 2026-05-13 | doc_2026-05-13_gateway_multigw_replication.md | Replica multi-gateway N=75 k=1/3/5 |
| 2026-05-13 | doc_2026-05-13_gateway_papers_fidelity_table.md | Tabla final paper vs implementación para fases 1 y 2 |
| 2026-05-13 | pauta_tesis_udp.md | Pauta formal UDP para tesis, seminarios y memorias |
| 2026-05-13 | doc_2026-05-13_gateway_deviation_interpretation_fix.md | Corrección de interpretation de deviation en schedulability ratio |

---

## Formato de Documentación

```markdown
# Avance: [Título]

## Fecha
YYYY-MM-DD

## Resumen
[Descripción breve]

## Detalles
[Explicación detallada]

## Cambios Realizados
- [Archivo]: [Cambio]

## Justificación
[Por qué se hizo así vs paper]

## Resultados
[Qué se observó]
```

---

## Guía para Documentar

1. **Antes de cada cambio**: documentar qué dice el paper
2. **Después del cambio**: documentar qué se implementó
3. **Sempre**: incluir justificación académica

---

## Propósito para Paper y Tesis

Esta documentación sirve como:
- Bitácora de decisiones de diseño
- Justificación para reviewers
- Material para escribir metodology
- Registro de qué es fiel al paper vs interpretación
