# AuditIA PG2 Grupo 10

Implementación reproducible de un subconjunto ejecutable de PG1 en Neo4j Community 5.26.0. Autores del trabajo académico: Costa, Juan Pablo; Isgró, Tomás Valentino; Lucero, Bruno.

## Alcance

Se conserva el catálogo de 33 frames, 51 relaciones y 66 reglas de PG1. Las etiquetas concretas y las relaciones implementan los recorridos seleccionados, no todas las combinaciones del catálogo. Hay 32 reglas o ramas programadas, 34 catalogadas, tres modelos PI3 con 14 reglas difusas y 44 comprobaciones técnicas. Todas las reglas de dominio y el modelo difuso siguen candidatos. Una prueba pasada no constituye validación con expertos.

Se integraron los PI3 finales de Costa, Isgró y Lucero. MD-AMB-1.0 conserva ambigüedad residual; MD-CONTR-1.0, pertenencia a contradicción; MD-URG-1.0, urgencia de atención. Sus parámetros y anclas son candidatos, sin calibración experta real. Las puntuaciones de prueba son construidas. El ensayo del protocolo de validación de PG1 no se registra como conocimiento experto adquirido.

## Requisitos

- Neo4j Community 5.26.0. No se necesita APOC.
- Java 17 si se utiliza la distribución local de Neo4j, o Docker.
- Python 3.10 o superior para el ejecutor opcional. Utiliza solo la biblioteca estándar.
- Neo4j Browser para visualizar el esquema y los resultados.

Ejemplo local con Docker:

```bash
docker run --name auditia-pg2 -p 127.0.0.1:7474:7474 -p 127.0.0.1:7687:7687 -e NEO4J_AUTH=neo4j/auditia-demo-2026 neo4j:5.26.0
```

La credencial indicada es únicamente la del ejemplo local. Los archivos no contienen credenciales de ninguna organización.

## Ejecución

Extraer el paquete completo. Abrir una terminal en su carpeta y ejecutar:

```bash
python ejecutar_pg2.py --url http://localhost:7474 --usuario neo4j
```

El programa pide la contraseña sin guardarla. Para una instancia local ya configurada sin autenticación puede usarse explícitamente `--sin-auth`. Si se usa un puerto diferente, cambiar la URL. La API utilizada corresponde a la versión 5.26.0 verificada.

El ejecutor carga los seis bloques de datos e inferencia, ejecuta Q1 a Q3, compara las expectativas de las pruebas, repite la carga y verifica idempotencia. Escribe `pruebas/resultados_reproduccion.json` con el resultado de esa nueva ejecución. No reemplaza el registro original de evidencia.

Alternativa manual: ejecutar en orden los archivos de `scripts/` en cypher-shell o en Neo4j Browser. El archivo consolidado `Grupo_10_PG2_U1.cypher` contiene la misma secuencia y los controles. No incluye un borrado global. La etiqueta AuditIA_PG2 separa estos datos de otros proyectos.

Para observar el ciclo por etapas, cargar 01 a 04, ejecutar Q1/Q2, aplicar 05 y ejecutar Q3. Aplicar 06 para los informes por versión y 07 para controles. Q5 recupera los grados de los diagnósticos; Q6 muestra qué decisiones conserva cada versión del catálogo. Q4 requiere el parámetro `observacion_id`.

## Archivos

- `scripts/01_esquema.cypher`: restricción de ID e índices.
- `scripts/02_carga.cypher`: catálogo, fuentes, casos construidos y premisas.
- `scripts/03_inferencia_crisp.cypher`: juicios, diagnósticos y tratamientos.
- `scripts/04_difusa.cypher`: funciones gaussianas y Mamdani min-max con centroide discreto.
- `scripts/05_retorno.cypher`: respuestas, reevaluación y nuevas decisiones.
- `scripts/06_informes.cypher`: calidad observada y completitud separadas.
- `scripts/07_controles.cypher`: ocho controles de integridad.
- `consultas/Q1_tratamiento.cypher`: motivos de bloqueo y evidencia.
- `consultas/Q2_urgencia.cypher`: urgencia gradual y tratamiento crisp.
- `consultas/Q3_retorno.cypher`: respuesta, reevaluación e historia.
- `consultas/Q4_paquete_llm.cypher`: recuperación parametrizada de solo lectura para PI4.
- `consultas/Q5_diagnosticos_difusos.cypher`: grados, estados crisp y modelos de diagnóstico.
- `consultas/vista_diagnostico.cypher`: recorrido de instancias mostrado en la captura del grafo.
- `verificar_calculos.py`: control matemático independiente de grados y activaciones.
- `consultas/Q6_historial_versiones.cypher`: decisiones e historial de cada versión documental.
- `consultas/esquema_visual.cypher`: procedimiento de visualización del esquema.
- `datos/nodos.json` y `datos/relaciones.json`: datos utilizados para generar la carga.
- `evidencias/ejecucion_neo4j.json`: respuestas originales del motor, pruebas, conteos, esquema y métricas.
- `evidencias/paquete_llm.json` y `paquete_llm_catalogo.json`: salidas reales de Q4 para dos observaciones.
- `evidencias/calculos_difusos.json` y `verificacion_independiente.json`: cálculos guardados y contraste independiente.
- `evidencias/browser-*.png`: capturas reales de Neo4j Browser, sin reconstruir sus resultados.
- `pruebas/expectativas.json`: situaciones, consultas y valores esperados para la reproducción.

## Modelo difuso

Los modelos se guardan con nueve VariableDifusa, 27 EtiquetaDifusa y 14 ReglaDifusa. Todas las entradas tienen universo [0,10]. AMB y CONTR tienen salida [0,1]; URG conserva salida [0,10]. Los centros y sigma exactos de los tres PI3 están en datos/modelos_pi3.json y en los nodos del grafo. No se promedian ni se normalizan por conveniencia.

Se utilizan Mamdani MIN/MAX y centroide sobre 1001 puntos. La implementación principal es Cypher nativo. Como control independiente, verificar_calculos.py reconstruye cada grado y cada activación con la biblioteca estándar de Python y compara con tolerancia 1e-9.

```bash
python verificar_calculos.py
```

La ambigüedad del catálogo se calcula sobre valoraciones explícitas de las lecturas y del inventario revisado; la falta de aceptación mantiene pendientes verificabilidad y completitud. Sin una valoración numérica disponible no se calcula. Los escenarios excluyentes y las excepciones crisp impiden publicar un grado de contradicción. La banda media solicita revisión y no simula un desacuerdo documentado ni una revisión ya realizada.

El grado de urgencia complementa la explicación y ordena dentro de una misma prioridad. No modifica severidad, MPR-01 ni las puertas de hito y diferimiento. Toda decisión dependiente de conocimiento candidato permanece provisional. Una entrada numérica fuera de rango no se recorta ni se convierte en un valor válido.

## Calidad y completitud

InformeAuditoria separa hallazgos demostrados y calidad observada de unidades concluyentes y completitud de auditoría. Una unidad local es un JuicioCriterio; una unidad cruzada es una EvaluacionCruzada. El denominador corresponde a las unidades declaradas para los casos, no a una auditoría exhaustiva de una especificación real. madurez_documento queda desconocida hasta acordar su modelo. Una completitud alta no implica ausencia de defectos ni validación experta.

## Inmutabilidad y límites

MERGE por ID y ON CREATE SET preservan las instantáneas cargadas. Los cambios de conclusión usan evaluaciones nuevas, REEVALUA y decisiones con SUSTITUYE_A. Las escrituras administrativas fuera de estos scripts no están bloqueadas por un trigger de base de datos. Los controles detectan incumplimientos en el alcance declarado.

La relación CONTRADICE se almacena en una orientación canónica por orden de ID, con evaluación, regla, versión y ámbito. La simetría conceptual se recupera consultando sin dirección. Los catálogos Frame y TipoRelacion son metadatos, no observaciones.

## Fuentes técnicas consultadas

- https://neo4j.com/docs/cypher-manual/5/constraints/create-constraints/
- https://neo4j.com/docs/cypher-manual/5/clauses/merge/
- https://neo4j.com/docs/cypher-manual/5/functions/mathematical-logarithmic/
- https://neo4j.com/docs/cypher-manual/5/values-and-types/working-with-null/

Las fuentes de dominio son PG0, PG1, los tres PI3 finales y la devolución docente de PG1 suministradas para este trabajo. El informe explica la trazabilidad y las restricciones de interpretación.

## Correspondencia de versiones y evidencia

El informe de DOC-CAT-v1 conserva las decisiones iniciales por_consultar. El informe de DOC-CAT-v2 incluye sus sucesoras resueltas, sustentadas en EV-CAT-02. El cierre no se traslada al informe histórico. Q4 devuelve documento_id y evaluacion_id del contexto vigente, y documento_origen_id y evaluacion_origen_id del diagnóstico original. Los grados de ambigüedad vigente y de origen se devuelven por separado. La descripción del hallazgo se identifica como histórica.

Las respuestas parcial y completa tienen evidencia literal propia con el ID de la respuesta como localizador. La severidad se copia de una propuesta explícita del juicio de SM1 o de la evaluación de SM2; un valor ausente permanece desconocido. ContextoPrioridad no aporta una severidad de reemplazo. PT40 a PT44 verifican estos comportamientos.

El caso de retorno conserva la secuencia temporal respuesta, reevaluación y revisión. PT44 comprueba que no se invierta. Q4 incluye tratamiento_activo=false cuando el seguimiento está resuelto; la prioridad histórica no se interpreta como un bloqueo actual.
