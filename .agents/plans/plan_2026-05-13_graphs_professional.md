# Plan: Gráficos Profesionales (Completado ✅)

## Fecha
2026-05-13

## Objetivo
Actualizar todos los gráficos de mo_sp_final para que tengan estilo publicable en paper académico.

## Pasos Realizados

### 1. Leer graph_design.txt
- Documento define estilo obligatorio: fondo blanco, Times New Roman, colores sobrios
- figsize = 650x400, relación 1.5-1.75
- SP: línea segmentada `--` con círculo `o`, MO: línea continua `-` con cuadrado `s`
- λ=4: azul, λ=8: naranjo, λ=12: verde
- Sin títulos internos, grilla suave, bordes solo izq/abajo

### 2. Identificar archivos a modificar
- mo_sp_final/plots/ contiene 7 archivos .m con gráficos

### 3. Modificar cada archivo
- plot_conflict_demand_results.m
- plot_overlaps_results.m
- plot_contention_demand_results.m
- plot_hops_results.m
- plot_sched_ratio_channels_results.m
- plot_hops_results_mo_vs_moaco.m
- plot_overlaps_results_mo_vs_moaco.m

### Cambios aplicados a cada uno:
- Figure 650x400 con fondo blanco
- Axes con grid suave (alpha 0.6, color #D0D0D0, linestyle --)
- Ticks inward, thickness 0.8
- Box off (solo izq/abajo visibles)
- Fuente Times New Roman 10pt
- Etiquetas LaTeX para ejes
- Leyenda pequeña con borderpad y handlelength
- markerfacecolor white, markeredgewidth 0.8

## Validación
✅ Los 7 archivos fueron actualizados según las especificaciones del graph_design.txt

## Dependencias
Ninguna - trabajo completado