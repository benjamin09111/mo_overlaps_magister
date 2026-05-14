# Ajuste De Interpretacion: Deviation En Gateway Comparison

## Fecha
2026-05-13

## Problema Observado
Al ejecutar la comparacion inicial de gateway centrality aparecieron graficos con picos muy grandes, por ejemplo `3500%` o `-100%`, especialmente en `degree MO vs degree SP` y `best centrality + MO vs degree SP`.

## Causa
La implementacion original calculaba deviation de schedulability ratio como porcentaje relativo:

```text
Dev_rel = 100 * (SR_method - SR_baseline) / SR_baseline
```

Esto es matematicamente correcto para variables con baseline estable, pero no es adecuado para schedulability ratio cuando `SR_baseline` puede ser cercano a cero. Si `degree + SP` tiene schedulability ratio muy bajo, una mejora pequena en valor absoluto produce un porcentaje enorme.

Ejemplo:

```text
SR_degree_SP = 0.02
SR_degree_MO = 0.72
Dev_rel = 100 * (0.72 - 0.02) / 0.02 = 3500%
```

El grafico parece explosivo, pero lo que realmente significa es una mejora de `70 puntos porcentuales`.

## Solucion Implementada
Para graficos de schedulability ratio se agrego deviation en puntos porcentuales:

```text
Dev_pp = 100 * (SR_method - SR_baseline)
```

Esta metrica es mas interpretable y coincide mejor con los graficos de los papers adjuntos, donde la deviation se muestra como diferencia respecto de una curva baseline y no como porcentaje relativo explosivo.

## Que Se Conserva
La deviation porcentual relativa se conserva para metricas como:

- overlaps
- conflict demand
- contention demand

Estas metricas suelen tener baseline distinto de cero y la interpretacion porcentual sigue siendo util.

## Archivos Modificados
- `mo_sp_gateways/experiments/run_experiment_suite_gateway_comparison.m`
- `mo_sp_gateways/plots/plot_gateway_centrality_deviation.m`
- `mo_sp_gateways/plots/plot_gateway_mo_improvement.m`

## Interpretacion Para Profesor
La explicacion correcta es:

> Los primeros graficos usaban deviation porcentual relativa. Como el schedulability ratio baseline puede ser cercano a cero, se generaban picos artificialmente grandes. Para schedulability ratio corresponde reportar deviation en puntos porcentuales, que expresa directamente cuanto sube o baja la proporcion de instancias schedulables respecto del baseline.

## Estado
Ajuste implementado en `mo_sp_gateways`. Se debe regenerar la figura ejecutando nuevamente el experimento o replotear desde `gw_results` recalculado.
