--------------------------------------------------------
--  DDL for Procedure cargarAU_BUG_TRAZABILIDAD
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ALM_REPORT"."cargarAU_BUG_TRAZABILIDAD" AS
BEGIN

execute immediate 'TRUNCATE TABLE ALM_REPORT.AU_BUG_TRAZABILIDAD';
for x in (select DB_NAME from alm_siteadmin_db_12.projects where domain_name in ('PROYECTOS') and PR_IS_ACTIVE = 'Y' ) loop
execute immediate  'insert into ALM_REPORT.AU_BUG_TRAZABILIDAD
SELECT

B.BG_BUG_ID "ID Defecto",
B.BG_STATUS "Estado",
B.BG_SEVERITY "Severidad",
B.BG_PRIORITY "Prioridad",
B.BG_DETECTED_BY "Detectado por",
B.BG_DETECTION_DATE "Detectado en Fecha",
R.REL_NAME "Detectado en REL",
RC.RCYC_NAME "Detectado en Ciclo" ,
L.LN_ENTITY_TYPE "Entidad Asociada" ,
''Defectos con Campos Incompletos (Detectado en Ciclo, Detectado en Release) y/o Sin Entidad Asociada '' "Accion a tomar",
'''||x.db_name||''' AS esquema,

NVL((SELECT DISTINCT  MAX(RQ_USER_12)
FROM  '||x.db_name||'.REQ,  '||x.db_name||'.REQ_RELEASES 
WHERE RQ_TYPE_ID = 101 AND RQRL_RELEASE_ID = R.REL_ID and RQRL_REQ_ID = RQ_REQ_ID), 
''No tiene trazabilidad al requerimiento o se encuentra vacio'') as coordinador,

NVL(R.REL_USER_04, ''No tiene trazabilidad al release o se encuentra vacío'' )

FROM '||x.db_name||'.BUG B

LEFT JOIN '||x.db_name||'.LINK L ON L.LN_BUG_ID = B.BG_BUG_ID
LEFT JOIN '||x.db_name||'.RELEASES R ON R.REL_ID =  B.BG_DETECTED_IN_REL
LEFT JOIN '||x.db_name||'.RELEASE_CYCLES RC ON RC.RCYC_ID = B.BG_DETECTED_IN_RCYC

WHERE
L.LN_ENTITY_TYPE IS NULL OR  B.BG_DETECTED_IN_REL IS NULL OR  B.BG_DETECTED_IN_RCYC IS NULL';

end loop;

end;

/
