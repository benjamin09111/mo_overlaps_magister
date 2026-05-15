# Diseño Nested/Paired Para Reducir Ruido En Gateway Papers

## Fecha
2026-05-13

## Problema
Las curvas de schedulability ratio y deviation presentaban cambios bruscos entre valores consecutivos de `n`.

## Causa
El codigo inicial generaba sensores y periodos de forma independiente para cada valor de `n`. Eso significa que el punto `n=6` no necesariamente era el punto `n=5` mas un flujo adicional, sino un experimento distinto.

## Correccion Metodologica
Se implemento un diseño nested/paired:

```text
Para cada topologia/trial:
  seleccionar gateways una vez
  seleccionar un pool maximo de sensores una vez
  generar periodos maximos una vez
  para cada n:
    usar sensores_pool(1:n)
    usar periodos_pool(1:n)
```

## Por Que Es Fiel Al Paper
Este cambio no suaviza ni altera datos. Solo asegura que la comparacion entre `n` y `n+1` sea incremental y controlada. Es una practica experimental mas rigurosa porque reduce varianza artificial no asociada al metodo de gateway.

## Que No Se Hizo
- No se aplico media movil.
- No se interpolaron curvas.
- No se editaron puntos.
- No se eligieron resultados manualmente.

## Archivos Modificados
- `mo_sp_gateways/experiments/run_experiment_suite_gateway_single_paper.m`
- `mo_sp_gateways/experiments/run_experiment_suite_gateway_multigw_paper.m`

## Impacto Esperado
- Curvas menos bruscas.
- Mejor lectura visual.
- Tendencias mas estables con el mismo numero de topologias.
- Mayor fidelidad metodologica para comparar contra papers.
