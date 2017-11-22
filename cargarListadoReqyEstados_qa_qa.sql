--------------------------------------------------------
--  DDL for Procedure cargarListadoReqyEstados_qa_qa
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ALM_REPORT"."cargarListadoReqyEstados_qa_qa" AS 
BEGIN

execute immediate 'TRUNCATE TABLE ALM_REPORT.REQ_Y_ESTADOS_QA_QA';

for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME from alm_siteadmin_db_12.projects where DOMAIN_NAME = 'QA') loop
execute immediate  'insert into ALM_REPORT.REQ_Y_ESTADOS_QA_QA
SELECT
'''||x.PROJECT_NAME||''' as esquema,
RQ.RQ_REQ_ID,
RQ.RQ_REQ_NAME,
RQ.RQ_USER_02,
RQ.RQ_REQ_AUTHOR,
RQ.RQ_USER_03,
RQ.RQ_VTS,
RT.TPR_NAME

FROM
 '||x.db_name||'.REQ RQ
 JOIN '||x.db_name||'.REQ_TYPE RT ON RT.TPR_TYPE_ID=RQ.RQ_TYPE_ID

WHERE

RQ.RQ_TYPE_ID in (3) AND RQ.RQ_REQ_PATH like ''AAAAAA%'' AND RQ.RQ_USER_02 not in (''Cerrado QA'')  

  ';

end loop;

END "cargarListadoReqyEstados_qa_qa";

/
