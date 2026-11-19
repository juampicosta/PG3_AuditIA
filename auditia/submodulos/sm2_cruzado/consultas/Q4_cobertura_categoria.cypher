// Q4. Exigibilidad y cobertura de una categoría no funcional en cada documento revisado: perfil usado, condición
// del catálogo, necesidades, partes cubiertas, relaciones EXIGE y CUBRE derivadas, regla, resultado y severidad.
// Parámetros: $categoria (String) y $documento_ids (List<String> o null para todos los documentos).
MATCH (ev:AuditIA_PG2:EvaluacionCruzada {tipo_analisis: 'cobertura'})-[:EVALUA_CATEGORIA]->(cat:CategoriaNFR {nombre: $categoria}),
      (ev)-[:USA_PERFIL]->(pf:PerfilSistema),
      (ev)-[:REVISA_DOCUMENTO]->(doc:DocumentoVersion)
WHERE $documento_ids IS NULL OR doc.id IN $documento_ids
OPTIONAL MATCH (ev)-[:GENERA]->(o:ResultadoAnalisis)
RETURN {
  documento_id: doc.id,
  version: toInteger(doc.version),
  evaluacion_id: ev.id,
  estado: ev.estado,
  categoria: {id: cat.id, nombre: cat.nombre},
  perfil: {id: pf.id, datos_sensibles: pf.datos_sensibles, confirmado: pf.confirmado,
           operaciones_esenciales: pf.operaciones_esenciales},
  condicion_catalogo: ev.condicion_catalogo,
  necesidades: ev.necesidades,
  partes_cubiertas: ev.partes_cubiertas,
  busqueda_completa: ev.busqueda_completa,
  cobertura: ev.cobertura,
  requerimientos_del_documento: [(doc)-[:CONTIENE]->(r:Requerimiento) | {id: r.id, texto: r.texto_original}],
  exige: [(pf)-[x:EXIGE {evaluacion_id: ev.id}]->(cat) | {regla: x.regla_id, necesidad: x.necesidad}],
  cubre: [(r:Requerimiento)-[c:CUBRE {evaluacion_id: ev.id}]->(cat) |
          {requerimiento_id: r.id, texto: r.texto_original, regla: c.regla_id, necesidad: c.necesidad}],
  reglas: [(ev)-[:APLICA_REGLA]->(r:Regla) | r.id],
  evidencias: [(ev)-[:SE_SUSTENTA_EN]->(e:Evidencia) | {id: e.id, tipo: e.tipo, contenido: e.contenido}],
  resultado: CASE WHEN o IS NULL THEN null ELSE
    {id: o.id, clase: CASE WHEN o:Hallazgo THEN 'Hallazgo' ELSE 'Pendiente' END,
     tipo_defecto: o.tipo_defecto, motivo_pendiente: o.motivo_pendiente, dato_faltante: o.dato_faltante,
     severidad: head([(o)-[:TIENE_SEVERIDAD]->(s:Severidad) | {id: s.id, valor: s.valor}])} END
} AS cobertura
ORDER BY cobertura.documento_id;
