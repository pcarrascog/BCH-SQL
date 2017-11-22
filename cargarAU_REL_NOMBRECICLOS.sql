--------------------------------------------------------
--  DDL for Procedure cargarAU_REL_NOMBRECICLOS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ALM_REPORT"."cargarAU_REL_NOMBRECICLOS" AS
BEGIN
execute immediate 'TRUNCATE TABLE ALM_REPORT.AU_REL_NOMBRECICLOS';
for x in (select DB_NAME, PROJECT_NAME from alm_siteadmin_db_12.projects where domain_name in ('PROYECTOS') and PR_IS_ACTIVE = 'Y' ) loop
execute immediate  'insert into ALM_REPORT.AU_REL_NOMBRECICLOS
SELECT
DISTINCT 
RC.RCYC_ID,
RC.RCYC_NAME,
R.REL_ID,
R.REL_NAME,
R.REL_USER_04,

(SELECT DISTINCT  MAX(RQ_USER_12)
FROM  '||x.db_name||'.REQ,  '||x.db_name||'.REQ_RELEASES 
WHERE RQ_TYPE_ID = 101 AND RQRL_RELEASE_ID = R.REL_ID and RQRL_REQ_ID = RQ_REQ_ID) as coordinador,

'''||x.PROJECT_NAME||''' as esquema,

(SELECT  count(DISTINCT  RQ_USER_02)
FROM  '||x.db_name||'.REQ
WHERE RQ_TYPE_ID = 101 
AND RQ_USER_02 NOT IN (''Términado QA'',''Finalizado'',''Cancelado'',''En Producción'',''Pospuesto'',''Cerrado QA'',''Traspaso a Continuidad'') )  as estado

FROM
'||x.DB_NAME||'.RELEASES R
JOIN '||x.DB_NAME||'.RELEASE_CYCLES RC ON RC.RCYC_PARENT_ID = R.REL_ID
LEFT JOIN '||x.DB_NAME||'.RELEASE_FOLDERS RF ON RF.RF_ID = R.REL_PARENT_ID

WHERE 
(RC.RCYC_NAME NOT LIKE ''Pruebas Funcionales_Ciclo1'' OR
RC.RCYC_NAME NOT LIKE ''Pruebas Funcionales_Ciclo2'' OR
RC.RCYC_NAME NOT LIKE ''Pruebas Funcionales_Ciclo3'' AND
RC.RCYC_NAME NOT LIKE ''Pruebas IDC'' AND
RC.RCYC_NAME NOT LIKE ''Pruebas Estáticas'') and RF.RF_NAME != ''Papelera''

';
end loop;


end;

/
