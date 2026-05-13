# Plan: Gateway Comparison & Deviation Analysis

## Fecha
2026-05-13

## Objetivo
Agregar en `mo_sp_final` una comparación profesional de métodos de selección de gateway usando centralidades, junto con gráficos de deviation como en los papers del profesor.

## Regla Operativa
Este avance debe ser incremental: agregar archivos y flags nuevos sin romper el flujo existente de SP vs MO. El comportamiento actual debe mantenerse como default.

## Fases
1. Crear selección de gateway multi-centralidad.
2. Crear trial aislado para comparar gateway method + SP/MO.
3. Crear suite de comparación paired usando las mismas topologías, sensores y períodos.
4. Crear gráficos de deviation estilo paper.
5. Agregar flags al `main_experiments_control.m`.
6. Documentar el proceso y las fórmulas.

## Fórmulas Deviation

### Deviation vs Degree
```text
Dev(method) = 100 * (metric_method - metric_degree) / metric_degree
```

### Degree + MO vs Degree + SP
```text
Dev(MO vs SP) = 100 * (metric_degree_MO - metric_degree_SP) / metric_degree_SP
```

### Best Centrality + MO vs Degree + SP
```text
Dev(best MO) = 100 * (metric_best_MO - metric_degree_SP) / metric_degree_SP
```

## Validación
- `run_gateway_comparison=false` debe dejar el main igual que antes.
- Las nuevas comparaciones deben usar las mismas topologías para todos los métodos.
- Los gráficos deben mantener estilo paper.
