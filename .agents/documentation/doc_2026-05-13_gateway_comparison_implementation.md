# Implementación: Gateway Comparison & Deviation Analysis

## Fecha
2026-05-13

## Objetivo
Agregar una capa incremental en `mo_sp_final` para comparar métodos de selección de gateway basados en centralidad y generar gráficos de deviation como en los papers del profesor.

## Regla de Sesión
No se reemplazó el flujo existente SP vs MO. La comparación de gateways queda apagada por defecto con `run_gateway_comparison=false`.

---

## 1. Qué Dice El Paper

### Centrality Gateway
El paper de centrality propone designar el gateway usando métricas de centralidad. Evalúa:
- degree centrality
- closeness centrality
- betweenness centrality
- eigenvector centrality

Los gráficos de deviation comparan el desempeño de otras centralidades respecto de degree centrality.

### Multigateway / Deviation
El paper multigateway usa deviation para comparar schedulability ratio entre configuraciones. La lógica relevante para esta misión es usar una baseline clara y medir diferencias relativas.

---

## 2. Qué Hacía Nuestro Código

Antes de esta misión:
- `mo_sp_final` usaba gateway por betweenness mediante `select_gateway_by_betweenness.m`.
- El dataset guardaba una topología y un gateway calculado con betweenness.
- `main_experiments_control.m` ejecutaba SP vs MO, schedulability y MO vs ACO.
- No existía comparación automática de centralidades.

---

## 3. Qué Se Agregó

### Nuevos archivos
- `mo_sp_final/topology/select_gateway.m`
- `mo_sp_final/experiments/run_single_trial_gateway.m`
- `mo_sp_final/experiments/run_experiment_suite_gateway_comparison.m`
- `mo_sp_final/plots/plot_gateway_centrality_deviation.m`
- `mo_sp_final/plots/plot_gateway_mo_improvement.m`

### Archivos modificados
- `.agents/AGENTS.md`: reglas incrementales y documentación obligatoria.
- `mo_sp_final/topology/select_gateway_by_betweenness.m`: wrapper hacia `select_gateway`.
- `mo_sp_final/main/main_experiments_control.m`: flags nuevos, apagados por defecto.
- `mo_sp_final/plot_sched_ratio_density_results.m`: estilo paper para gráfico pendiente.

---

## 4. Fórmulas Implementadas

### Deviation vs Degree Centrality
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

## Interpretación
- Para overlaps/conflict/hops, valores negativos indican reducción de demanda o costo.
- Para schedulability ratio, valores positivos indican mejora.

---

## 5. Diseño Experimental

La suite nueva usa comparación paired:
- misma topología para todos los métodos
- mismos sensores para todos los métodos
- mismos períodos `T_common` para SP y MO
- mismo `lambda`, `n`, `m` y `trial_idx`

Esto permite atribuir diferencias solamente al método de gateway y routing.

---

## 6. Cómo Activar

En `mo_sp_final/main/main_experiments_control.m`:
```matlab
run_gateway_comparison = true;
run_gateway_plots = true;
```

Métodos default:
```matlab
gateway_methods = {'betweenness', 'degree', 'eigenvector', 'closeness'};
baseline_gateway_method = 'degree';
```

---

## 7. Reversión Segura

Como el avance es incremental, para desactivar todo basta con dejar:
```matlab
run_gateway_comparison = false;
```

Si se quiere revertir completamente, eliminar los nuevos archivos listados en la sección 3 y restaurar `select_gateway_by_betweenness.m` a su versión previa.

---

## 8. Pendientes Técnicos

- Ejecutar en MATLAB para validar sintaxis runtime.
- Verificar que `centrality(G, 'eigenvector')` esté disponible en la versión de MATLAB usada.
- Si eigenvector no está disponible, agregar fallback documentado.
- Confirmar visualmente los gráficos exportados en `mo_sp_final/figures`.
