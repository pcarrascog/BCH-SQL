--------------------------------------------------------
--  DDL for Procedure cargarAU_REL_CARPETA_TESTSET
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ALM_REPORT"."cargarAU_REL_CARPETA_TESTSET" AS
BEGIN
execute immediate 'TRUNCATE TABLE ALM_REPORT.AU_REL_CICLOCARPETA_TESTSET';
for x in (select DB_NAME, PROJECT_NAME from alm_siteadmin_db_12.projects where domain_name in ('PROYECTOS') and PR_IS_ACTIVE = 'Y' ) loop
execute immediate  'insert into ALM_REPORT.AU_REL_CICLOCARPETA_TESTSET
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
CF_ITEM_NAME,

(SELECT  count(DISTINCT  RQ_USER_02)
FROM  '||x.db_name||'.REQ
WHERE RQ_TYPE_ID = 101 
AND RQ_USER_02 NOT IN (''Términado QA'',''Finalizado'',''Cancelado'',''En Producción'',''Postpuesto'',''Cerrado QA'',''Traspaso a Continuidad'') )  as estado

FROM
'||x.DB_NAME||'.RELEASES R
JOIN '||x.DB_NAME||'.RELEASE_CYCLES RC ON RC.RCYC_PARENT_ID = R.REL_ID
JOIN '||x.db_name||'.CYCL_FOLD ON CF_ASSIGN_RCYC = RC.RCYC_ID
LEFT JOIN '||x.DB_NAME||'.RELEASE_FOLDERS RF ON RF.RF_ID = R.REL_PARENT_ID


WHERE 
CF_ITEM_NAME != RC.RCYC_NAME AND 
RF.RF_NAME != ''Papelera''

';
end loop;
end;

/
