--------------------------------------------------------
--  DDL for Procedure cargarProyectos_sin_IDC
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ALM_REPORT"."cargarProyectos_sin_IDC" AS
BEGIN
execute immediate 'TRUNCATE TABLE ALM_REPORT.Proyectos_sin_IDC';


for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME from alm_siteadmin_db_12.projects where domain_name in ('PROYECTOS') and PR_IS_ACTIVE = 'Y' ) loop
execute immediate  'insert into ALM_REPORT.Proyectos_sin_IDC 
SELECT 
DISTINCT RQ_REQ_ID,
'''||x.DOMAIN_NAME||''' as DOMINIO,
'''||x.DB_NAME||''' as ESQUEMA,
R.REL_NAME AS PROYECTO,
RC.RCYC_NAME AS TIPO_DE_CICLO,
MIN (RN.RN_EXECUTION_DATE),
RQ.RQ_REQ_DATE,
MAX (RN.RN_EXECUTION_DATE)

FROM '||x.db_name||'.RELEASES R
INNER JOIN '||x.db_name||'.REQ_RELEASES RR ON RR.RQRL_RELEASE_ID=R.REL_ID
INNER JOIN '||x.db_name||'.REQ RQ ON RQ.RQ_REQ_ID=RR.RQRL_REQ_ID
INNER JOIN '||x.db_name||'.RELEASE_CYCLES RC ON R.REL_ID=RC.RCYC_PARENT_ID
INNER JOIN '||x.db_name||'.RUN RN ON RN.RN_ASSIGN_RCYC=RC.RCYC_ID
INNER JOIN '||x.db_name||'.TEST TS ON TS.TS_TEST_ID=RN.RN_TEST_ID
WHERE RQ.RQ_TYPE_ID IN (104,109) 
GROUP BY
RQ_REQ_ID,
R.REL_NAME ,
RC.RCYC_NAME ,
RN.RN_EXECUTION_DATE,
RQ.RQ_REQ_DATE,
RN.RN_EXECUTION_DATE

 
';
 
 
end loop;

 
 

------------------------ESTRUCTURA NUEVA-----------------------------------

for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME from alm_siteadmin_db_12.projects where DB_NAME = 'bch_qa_certificación_bch_qa_d') loop
execute immediate  'insert into ALM_REPORT.Proyectos_sin_IDC 

SELECT 
DISTINCT RQ_REQ_ID,
'''||x.DOMAIN_NAME||''' as DOMINIO,
'''||x.DB_NAME||''' as ESQUEMA,
R.REL_NAME AS PROYECTO,
RC.RCYC_NAME AS TIPO_DE_CICLO,
MIN (RN.RN_EXECUTION_DATE),
RQ.RQ_REQ_DATE,
MAX (RN.RN_EXECUTION_DATE)

FROM '||x.db_name||'.RELEASES R
INNER JOIN '||x.db_name||'.REQ_RELEASES RR ON RR.RQRL_RELEASE_ID=R.REL_ID
INNER JOIN '||x.db_name||'.REQ RQ ON RQ.RQ_REQ_ID=RR.RQRL_REQ_ID
INNER JOIN '||x.db_name||'.RELEASE_CYCLES RC ON R.REL_ID=RC.RCYC_PARENT_ID
INNER JOIN '||x.db_name||'.RUN RN ON RN.RN_ASSIGN_RCYC=RC.RCYC_ID
INNER JOIN '||x.db_name||'.TEST TS ON TS.TS_TEST_ID=RN.RN_TEST_ID
WHERE RQ.RQ_TYPE_ID IN (104,109) 
GROUP BY
RQ_REQ_ID,
R.REL_NAME ,
RC.RCYC_NAME ,
RN.RN_EXECUTION_DATE,
RQ.RQ_REQ_DATE,
RN.RN_EXECUTION_DATE

';
end loop;



end;

/
