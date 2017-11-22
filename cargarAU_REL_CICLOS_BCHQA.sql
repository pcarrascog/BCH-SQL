--------------------------------------------------------
--  DDL for Procedure cargarAU_REL_CICLOS_BCHQA
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ALM_REPORT"."cargarAU_REL_CICLOS_BCHQA" 
AS
BEGIN
  EXECUTE immediate 'TRUNCATE TABLE ALM_REPORT.AU_REL_CICLOS_BCHQA';
  FOR x IN (SELECT DB_NAME, PROJECT_NAME, DESCRIPTION FROM alm_siteadmin_db_12.projects WHERE DB_NAME = 'bch_qa_certificación_bch_qa_d') LOOP
   EXECUTE immediate 'insert into ALM_REPORT.AU_REL_CICLOS_BCHQA
SELECT
DISTINCT 
RC.RCYC_ID,
RC.RCYC_NAME,
R.REL_ID,
R.REL_NAME,
R.REL_USER_TEMPLATE_01,

(SELECT DISTINCT  MAX(RQ_REQ_AUTHOR)
FROM  '||x.db_name||'.REQ,  '||x.db_name||'.REQ_RELEASES 
WHERE RQRL_RELEASE_ID = R.REL_ID and RQRL_REQ_ID = RQ_REQ_ID) as coordinador,

'''||x.PROJECT_NAME||''' as esquema,

(SELECT  count(DISTINCT RQ_USER_04)
FROM  '||x.db_name||'.REQ
WHERE RQ_TYPE_ID in (119,117,107) 
AND RQ_USER_04 NOT IN (''Términado QA'',''Finalizado'',''Cancelado'',''En Producción'',''Cerrado QA'',''Traspaso a Continuidad'',''Rechazado'') )  as activos,

RF.RF_NAME

FROM
'||x.DB_NAME||'.RELEASES R
JOIN '||x.DB_NAME||'.RELEASE_CYCLES RC ON RC.RCYC_PARENT_ID = R.REL_ID
LEFT JOIN '||x.DB_NAME||'.RELEASE_FOLDERS RF ON RF.RF_ID = R.REL_PARENT_ID


WHERE RF.RF_PATH like ''AAAAAA%'' AND RF.RF_NAME != ''Papelera''

';
  END LOOP;
END;

/
