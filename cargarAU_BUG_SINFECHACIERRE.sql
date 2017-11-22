--------------------------------------------------------
--  DDL for Procedure cargarAU_BUG_SINFECHACIERRE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ALM_REPORT"."cargarAU_BUG_SINFECHACIERRE" AS
BEGIN


execute immediate 'TRUNCATE TABLE ALM_REPORT.AU_BUG_SINFECHACIERRE';

for x in (select DB_NAME, PROJECT_NAME from alm_siteadmin_db_12.projects where domain_name in ('PROYECTOS') and PR_IS_ACTIVE = 'Y' ) loop
execute immediate  'insert into ALM_REPORT.AU_BUG_SINFECHACIERRE
SELECT
DISTINCT
R.REL_ID   "ID Version",
R.REL_NAME "Nombre Version" ,
B.BG_BUG_ID  "ID Defecto",
B.BG_STATUS  "Estado Defecto",
B.BG_SEVERITY  "Severidad",
B.BG_TARGET_RCYC "Ciclo Destino",
RC.RCYC_NAME "Nombre Ciclo",
B.BG_CLOSING_DATE "Fecha Cierre",
B.BG_DETECTION_DATE "Fecha Deteccion",
B.BG_DETECTED_BY "Detectado por",
B.BG_RESPONSIBLE,
'''||x.PROJECT_NAME||''' as esquema,

NVL((SELECT DISTINCT  MAX(RQ_USER_12)
FROM  '||x.db_name||'.REQ,  '||x.db_name||'.REQ_RELEASES 
WHERE RQ_TYPE_ID = 101 AND RQRL_RELEASE_ID = R.REL_ID and RQRL_REQ_ID = RQ_REQ_ID), 
''No tiene trazabilidad al requerimiento o se encuentra vacio'') as coordinador,

NVL(R.REL_USER_04, ''No tiene trazabilidad al release o se encuentra vacío'' )

FROM '||x.db_name||'.RELEASES R
JOIN '||x.db_name||'.BUG B ON B.BG_TARGET_REL = R.REL_ID
LEFT JOIN '||x.db_name||'.RELEASE_CYCLES RC ON RC.RCYC_ID = B.BG_TARGET_RCYC


WHERE


B.BG_STATUS  in (''Closed'',''Cerrado'') AND B.BG_CLOSING_DATE IS NULL

order by B.BG_BUG_ID ASC';

end loop;

END;

/
