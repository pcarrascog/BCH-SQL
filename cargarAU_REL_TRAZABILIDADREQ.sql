--------------------------------------------------------
--  DDL for Procedure cargarAU_REL_TRAZABILIDADREQ
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ALM_REPORT"."cargarAU_REL_TRAZABILIDADREQ" AS
BEGIN
execute immediate 'TRUNCATE TABLE ALM_REPORT.AU_REL_TRAZABILIDADREQ';
for x in (select DB_NAME, PROJECT_NAME from alm_siteadmin_db_12.projects where domain_name in ('PROYECTOS') and PR_IS_ACTIVE = 'Y' ) loop
execute immediate  'insert into ALM_REPORT.AU_REL_TRAZABILIDADREQ
SELECT
DISTINCT 
R.REL_ID,
R.REL_NAME,
(SELECT DISTINCT  MAX(RQ_USER_12)
FROM  '||x.db_name||'.REQ,  '||x.db_name||'.REQ_RELEASES 
WHERE RQ_TYPE_ID = 101 AND RQRL_RELEASE_ID = R.REL_ID and RQRL_REQ_ID = RQ_REQ_ID) as coordinador,

R.REL_USER_04,
'''||x.PROJECT_NAME||''' as esquema,

(SELECT  count(DISTINCT  RQ_USER_02)
FROM  '||x.db_name||'.REQ
WHERE RQ_TYPE_ID = 101) as estado 
AND RQ_USER_02 NOT IN (''Términado QA'',''Finalizado'',''Cancelado'',''En Producción'',''Pospuesto'',''Cerrado QA'',''Traspaso a Continuidad'') )  as estado

FROM
'||x.DB_NAME||'.RELEASES R
LEFT JOIN '||x.DB_NAME||'.REQ_RELEASES ON  RQRL_RELEASE_ID = R.REL_ID
LEFT JOIN '||x.DB_NAME||'.RELEASE_FOLDERS RF ON RF.RF_ID = R.REL_PARENT_ID

WHERE 
RQRL_REQ_ID IS NULL AND
R.REL_NAME != ''Prueba'' AND
RF.RF_NAME != ''Papelera''

';
end loop;
end;

/
