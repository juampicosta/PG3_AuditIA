// Solo crea restricciones del proyecto; no borra datos ajenos.
CREATE CONSTRAINT auditia_pg2_id IF NOT EXISTS FOR (n:AuditIA_PG2) REQUIRE n.id IS UNIQUE;
CREATE INDEX auditia_pg2_eval_estado IF NOT EXISTS FOR (e:Evaluacion) ON (e.estado);
CREATE INDEX auditia_pg2_fuente_nombre IF NOT EXISTS FOR (f:Fuente) ON (f.nombre);
