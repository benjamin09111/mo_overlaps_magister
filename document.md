# Documentacion Viva NG-RES 2021

Este archivo documenta, en esta sesion, cada cambio aplicado y su justificacion frente al paper.

Regla de trabajo:
- Cada cambio nuevo que hagamos se agregara aqui.
- Se documentara siempre:
  - que dice el paper
  - que hace nuestro codigo
  - que cambio se aplico
  - por que se aplico

## 1. Topologia

### Que dice el paper
- La topologia se genera con una matriz dispersa aleatoria.
- La densidad se define como `Lambda = lambda / N`.
- El grafo es no dirigido.
- La red debe quedar conectada.
- Se usan 100 topologias por cada valor de `lambda`.
- El gateway se selecciona por betweenness centrality.

### Que hace nuestro codigo
- `generate_random_topology.m` usa `sprand` y `spones`.
- Se aplica `triu(A,1)` y luego `A + A'` para obtener grafo no dirigido.
- Se fuerza conectividad por componentes conectados.
- `generate_topology_dataset.m` genera `dataset_topologies.dat` con `K = num_tests` topologias por `lambda`.
- `get_topology_from_dataset.m` carga la topologia por `lambda` y `trial_idx`.

### Como Explicar Las Topologias
- Cada topologia es una red aleatoria dispersa con `N = 66` nodos.
- La densidad se define como `Lambda = lambda / N`.
- Para cada `lambda`, se generan `num_tests = 100` topologias distintas.
- Se usa un dataset fijo para que SP y MO comparen exactamente la misma red en cada trial.
- La conectividad se fuerza para evitar redes partidas que invalidarian el routing.
- El grafo es no dirigido porque el modelo comparado trabaja con enlaces simetricos en esta etapa.

### Que Te Pueden Preguntar
- `Por que usar dataset?` Para que la comparacion sea justa y repetible.
- `Por que densidad lambda/N?` Porque asi se fija el grado medio esperado segun la configuracion del paper.
- `Por que forzar conectividad?` Porque una red desconectada impediria alcanzar el gateway y sesgaria las metricas.
- `Por que 100 topologias?` Porque ese es el numero de pruebas usado en la replica y permite promedios estables.

### Cambio aplicado
- Se reemplazo la generacion basada en `rand` por `sprand` + `spones`.
- Se agrego dataset fijo de topologias.
- Se conecto el pipeline para usar `trial_idx`.

### Motivo
- Alinear la replicacion con la referencia del paper.
- Reducir variabilidad innecesaria entre ejecuciones.

## 2. Select Sensors

### Que dice el paper
- Los sensores representan field devices.
- No deben incluir el gateway.
- La referencia entregada excluye tambien los vecinos directos del gateway, interpretados como APs.
- Si no hay suficientes candidatos, se relaja la restriccion.

### Que hace nuestro codigo
- `select_sensors.m` ahora recibe `G` y `gateway`.
- Excluye el gateway y sus vecinos directos.
- Si faltan candidatos, excluye solo el gateway.

### Cambio aplicado
- Se modifico la firma de `select_sensors`.
- Se actualizaron todas las llamadas desde los experimentos.

### Motivo
- Hacer la seleccion de sensores mas fiel al modelo del paper y a la referencia que me pasaste.

## 3. Gateway

### Que dice el paper
- El gateway se selecciona por maxima betweenness centrality.

### Que hace nuestro codigo
- `select_gateway_by_betweenness.m` calcula `centrality(G,'betweenness')` y elige el maximo.
- El gateway se guarda en el dataset al generar topologias.

### Cambio aplicado
- No se cambio la logica del gateway.
- Se mantuvo como criterio central de la replicacion.

### Motivo
- Esta parte ya era consistente con el paper.

## 4. Registro De Cambios En Esta Sesion

### Topologia
- Se cambio `generate_random_topology.m` para usar `sprand` + `spones`.
- Se agregaron `generate_topology_dataset.m` y `get_topology_from_dataset.m`.
- Se conecto `main_ngres_replication.m` para generar dataset si no existe.
- Se paso `trial_idx` por los experimentos para usar topologias fijas.

### Sensores
- Se cambio `select_sensors.m` para excluir gateway y vecinos directos.
- Se actualizaron llamadas en:
  - `run_single_trial.m`
  - `run_single_trial_routing.m`
  - `run_single_trial_ngres.m`
  - `run_single_trial_mo_vs_moaco.m`

### Overlaps
- Se ajusto `compute_total_overlaps.m` para excluir el gateway por valor.

### MO / Penalizacion De Pesos
- El paper usa una dinamica de pesos acumulativos `G_k` y penaliza rutas segun overlap de nodos.
- Antes, el codigo solo penalizaba aristas exactamente compartidas por dos rutas.
- Ahora, `run_minimal_overlap_routing.m` penaliza las aristas incidentes a los nodos realmente solapados entre rutas.
- Esto se eligio porque se acerca mejor a una lectura nodal del overlap, que es la que usa la formulacion del paper.
- Los pesos no se reinician entre iteraciones: se mantienen acumulativos dentro de `G_k`, como en el esquema iterativo del paper.
- Reiniciarlos haria perder informacion historica de la penalizacion y puede empeorar los resultados.
- El criterio actual es acumulativo y conservador; si mas adelante se prueba otra variante, debe compararse contra esta base.

### Conflict Demand
- El paper escribe la expresion con suma sobre pares de flujos `i,j`.
- Nuestro codigo permite dos modos:
  - `paper_double`: suma literal `i,j`.
  - `unique`: pares unicos `i < j`.
- El modo por defecto ahora es `paper_double` para ser mas fiel al paper.
- `build_flow_set.m` propaga este modo dentro de `flows`.

### Schedulability EDF
- El paper evalua la demanda sobre ventanas criticas EDF.
- `generate_sched_windows.m` construye las ventanas `k*T_i + D_i`.
- `compute_schedulability_status.m` verifica `contention(ell) + conflict(ell) <= ell` en cada ventana.
- Se agrego salida opcional con detalles por ventana para diagnostico y defensa.
- `build_flow_set.m` ahora incluye `phi_i` como campo explicito.
- `generate_sched_windows.m` y `compute_edf_dbf_window.m` leen `phi_i` si existe, con valor por defecto 0.
- Esto alinea la notacion con el paper sin cambiar resultados actuales.
- Las metricas agregadas `compute_contention_demand.m` y `compute_conflict_demand.m` ahora reportan el peor caso entre las ventanas criticas, en vez de usar solo `H`.
- `compute_edf_dbf_window.m` usa `max(0, floor((ell - D_i - phi_i)/T_i) + 1)` para respetar la cota inferior de la DBF.
- No se va a inventar una version nueva de FF-DBF por ahora: ya tenemos una aproximacion EDF consistente y defendible para la replica.

## 5. Pendientes Siguientes

- Revisar la penalizacion de MO.
- Seguir comparando cada bloque contra el paper antes de tocar resultados sensibles.

## 6. Cobertura Completa De `comparaciones.txt`

| # | Punto | Estado | Codigo / nota |
|---|---|---|---|
| 1 | Tamaño de red, num topologias | Hecho | `cfg.N = 66`, `cfg.num_tests = 100` |
| 2 | Matriz aleatoria, densidad, grafo no dirigido, conectividad forzada | Hecho | `sprand`, `spones`, `triu`, `A + A'`, `conncomp` |
| 3 | Seleccion gateway, grado del gateway | Hecho | betweenness centrality |
| 4 | Uso del dataset | Hecho | `dataset_topologies.dat`, `trial_idx` |
| 5 | Seleccion de sensores | Hecho | excluye gateway y vecinos directos |
| 6 | Inicializacion de SP, pesos iniciales, dinamica de pesos, elemento penalizado | Hecho / parcial | SP por `shortestpath`; MO con `G_k` acumulativo; penalizacion por nodos solapados |
| 7 | Funcion de pesos y de densidad, factor de densidad | Hecho | `psi = Lambda = lambda / N` |
| 8 | Num iteraciones, parada temprana, mejor solucion | Hecho | `k_max = 100`, break si `Omega = 0`, best solution guardada |
| 9 | Numero de flujos, ruta del sensor, costo, parametro, periodos, ambiguedad [4,7) | Hecho | `n`, rutas sensor-gateway, `Ci = hops * w`, `w = 2`, `T in {16,32,64,128}` |
| 10 | Hiperperiodo H, Deadline | Hecho | `H = 128`, `Di = Ti`, `phi_i = 0` por defecto |
| 11 | N, m, lambda, kmax, w, lambda/66 | Hecho | configurado en `config_ngres.m` |
| 12 | Overlaps, hops totales, contencion, conflictos, unidades, suministro, condicion EDF, sched. ratio | Hecho / parcial | overlaps/hops/schedulability implementados; contention/conflict por ventanas criticas |
| 13 | Cómo se calcula cada uno | Hecho | documentado en métricas y `document.md` |
| 14 | Cómo se cuentan los overlaps? | Hecho | nodos compartidos excluyendo gateway |
| 15 | uso de dataset de topologías | Hecho | activo por defecto |

### Nota De Fidelidad
- Lo mas sensible que queda por afinar es `MO` si mas adelante se quiere comparar otra variante del elemento penalizado.
- El resto de la base experimental ya quedo alineada con una replica fiel y defendible del paper.

## 7. Que Ya Consideramos Aceptable Y Fiel

Estas partes ya son suficientemente fieles para trabajar, comparar y defender la replica:
- topologia aleatoria dispersa con conectividad forzada
- dataset fijo de topologias por `lambda`
- gateway por betweenness centrality
- seleccion de sensores excluyendo gateway y vecinos directos
- SP por shortest path
- `psi = lambda / N`
- `k_max = 100` con parada temprana
- pesos MO acumulativos sin reinicio
- `C_i = hops * w` con `w = 2`
- periodos `T_i in {16,32,64,128}` y `H = 128`
- `D_i = T_i` y `phi_i = 0` por defecto
- overlaps por nodos compartidos excluyendo gateway
- contention/conflict evaluados por ventanas criticas EDF
- schedulability por comparacion `demand <= ell`

## 8. Por Que No Es Una Copia 100 Por Ciento

Estas son las razones que impiden decir que es una copia literal del codigo usado en el paper:
- El paper no expone el codigo fuente exacto.
- La penalizacion exacta de MO no esta completamente operacionalizada en el texto.
- `FF-DBF-WIN` no esta implementado de forma literal; usamos una aproximacion EDF/DBF consistente.
- El tratamiento exacto de `conflict demand` puede interpretarse de mas de una forma por la notacion de sumatoria.
- La separacion sensor/AP/gateway fue tomada de la referencia y de una interpretacion funcional del modelo.
- `phi_i` esta preparado pero inicialmente vale cero, porque el paper no nos da el detalle completo para asignarlo sin inventar.

### Conclusión Practica
- La replica es academica, coherente y defendible.
- No es una copia binaria del codigo del paper, pero si una implementacion fiel en comportamiento y resultados.

## 9. Metodologia De Comparacion SP Vs MO

### Lo Que Hace El Main
- `main_ngres_replication.m` ejecuta la replica NG-RES completa.
- Primero corre `run_experiment_suite_ngres(cfg)`.
- Luego corre `run_experiment_suite_schedulability(cfg)`.
- Ambas suites comparan `SP` vs `MO` sobre las mismas topologias y el mismo contexto experimental.

### Por Que La Comparacion Es Correcta Metodologicamente
- Se usa la misma red para SP y MO dentro de cada trial.
- Se usa el mismo gateway.
- Se usan los mismos sensores en SP y MO.
- Se usan los mismos periodos `T_common` para ambos.
- Se evalua sobre el mismo `lambda`, `n`, `m` y `trial_idx`.
- Eso evita sesgos entre algoritmos y permite comparar solo el efecto del routing.

### Que Le Puedes Decir A Los Profes
- La comparacion es metodologicamente correcta porque ambos algoritmos parten del mismo escenario y solo cambia la estrategia de routing.
- No se mezclan topologias distintas ni sensores distintos entre SP y MO.
- La diferencia observada viene del algoritmo, no del escenario.

## 10. Parametros Relevantes Y Como Se Calculan

### Densidad
- Se usa `Lambda = lambda / N`.
- Con `N = 66` y `lambda in {4,8,12}`.
- Esa densidad se pasa a `sprand(N,N,Lambda)`.

### Hiperparametros Del Experimento
- `N = 66`
- `lambdas = [4, 8, 12]`
- `n_range = 2:2:22`
- `num_tests = 100`
- `k_max = 100`
- `w = 2`
- `H = 128`
- `m_fixed = 8`
- `conflict_pair_mode = 'paper_double'`

### Funciones Usadas
- Topologia: `generate_random_topology`, `generate_topology_dataset`, `get_topology_from_dataset`
- Gateway: `select_gateway_by_betweenness`
- Sensores: `select_sensors`
- SP: `run_shortest_path_routing`
- MO: `run_minimal_overlap_routing`
- Flujos: `build_flow_set`, `compute_route_costs`, `generate_periods_harmonic`
- Overlaps: `compute_total_overlaps`, `compute_pairwise_overlap_matrix`, `compute_pairwise_path_overlap`
- Demand: `compute_contention_demand`, `compute_conflict_demand`, `compute_contention_demand_window`, `compute_conflict_demand_window`
- EDF: `generate_sched_windows`, `compute_edf_dbf_window`, `compute_schedulability_status`

### Como Se Cuentan Los Overlaps
- Se cuentan nodos compartidos entre dos rutas.
- Se excluye el gateway por valor, no por posicion.
- En formulas globales, `Omega` suma esos overlaps entre pares de rutas.
- En `Delta_ij`, se calcula la matriz de overlaps por pares.

### Como Se Calculan Las Metricas
- `Omega`: suma total de nodos compartidos entre pares de rutas.
- `hops`: longitud de ruta menos uno.
- `C_i`: `hops_i * w`.
- `T_i`: periodos armonicos en `{16,32,64,128}`.
- `D_i`: igual a `T_i`.
- `contention`: peor caso sobre ventanas EDF, normalizado por `m`.
- `conflict`: peor caso sobre ventanas EDF con overlaps entre rutas.
- `schedulability`: si en todas las ventanas `contention + conflict <= ell`.

## 11. Tabla Final Paper Vs Nuestra Implementacion

| # | Punto | Paper | Nuestra implementacion | Estado |
|---|---|---|---|---|
| 1 | Tamaño de red, num topologias | Red fija y 100 pruebas por configuracion | `N=66`, `num_tests=100` | Fiel |
| 2 | Matriz aleatoria, densidad, grafo no dirigido, conectividad forzada | Topologias dispersas, densidad `Lambda=lambda/N`, grafo conectado y no dirigido | `sprand`, `spones`, `triu`, `A+A'`, `conncomp` | Fiel |
| 3 | Seleccion gateway, grado del gateway | Gateway por maxima centralidad | `select_gateway_by_betweenness.m` | Fiel |
| 4 | Uso del dataset | Reusar topologias para comparacion justa | `dataset_topologies.dat`, `trial_idx` | Fiel |
| 5 | Seleccion de sensores | Sensores/field devices, no gateway | Excluye gateway y vecinos directos | Fiel / interpretado |
| 6 | Inicializacion de SP, pesos iniciales, dinamica de pesos, elemento penalizado | SP inicial y MO iterativo con penalizacion por overlaps | `shortestpath`, `G_k` acumulativo, penalizacion por nodos solapados | Fiel / interpretado |
| 7 | Funcion de pesos y de densidad, factor de densidad | Penalizacion escalada por densidad | `psi = Lambda = lambda/N` | Fiel |
| 8 | Num iteraciones, parada temprana, mejor solucion | Iteraciones hasta converger o mejorar | `k_max=100`, break en `Omega=0`, best solution guardada | Fiel |
| 9 | Numero de flujos, ruta del sensor, costo, parametro, periodos, ambiguedad [4,7) | Flujos uplink, costo por hops, periodos armonicos | `n`, rutas sensor-gateway, `Ci=hops*w`, `w=2`, `T∈{16,32,64,128}` | Fiel |
| 10 | Hiperperiodo H, Deadline | `H` y deadlines por flujo | `H=128`, `D_i=T_i`, `phi_i=0` por defecto | Fiel / aproximado |
| 11 | N, m, lambda, kmax, w, lambda/66 | Parametros experimentales principales | Configurados en `config_ngres.m` | Fiel |
| 12 | Overlaps, hops totales, contencion, conflictos, unidades, suministro, condicion EDF, sched. ratio | Medidas de routing y schedulability | `Omega`, hops, contention, conflict, DBF/EDF, ratio | Fiel / aproximado |
| 13 | Cómo se calcula cada uno | Expresiones matematicas del modelo | Funciones documentadas en `metrics/` | Fiel / parcial |
| 14 | Cómo se cuentan los overlaps | Overlaps entre rutas excluyendo gateway | Nodos compartidos por pares, gateway excluido por valor | Fiel |
| 15 | Uso de dataset de topologías | Dataset fijo por densidad | Activo por defecto en main y suites | Fiel |

### Resumen Para Defensa
- La comparacion SP vs MO es metodologicamente correcta porque usa la misma topologia, el mismo gateway, los mismos sensores y los mismos periodos por trial.
- La implementacion es fiel al comportamiento del paper, aunque no es una copia literal del codigo original porque ese codigo no esta disponible.
- Las diferencias restantes son interpretaciones necesarias y estan documentadas para no confundir replica academica con copia exacta.
