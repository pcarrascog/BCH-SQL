--------------------------------------------------------
--  DDL for Procedure cargarListadoReqyEstados_bchqa
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ALM_REPORT"."cargarListadoReqyEstados_bchqa" AS 
BEGIN

execute immediate 'TRUNCATE TABLE ALM_REPORT.REQ_Y_ESTADOS_BCHQA';

for x in (select DB_NAME, PROJECT_NAME, DESCRIPTION from alm_siteadmin_db_12.projects where  DB_NAME = 'bch_qa_certificación_bch_qa_d') loop
execute immediate  'insert into ALM_REPORT.REQ_Y_ESTADOS_BCHQA
SELECT
'''||x.PROJECT_NAME||''' as esquema,
RQ.RQ_REQ_ID,
RQ.RQ_REQ_NAME,
RQ.RQ_USER_04,
RQ.RQ_REQ_AUTHOR,
RQ.RQ_USER_03,
RQ.RQ_VTS,
RT.TPR_NAME

FROM
 '||x.db_name||'.REQ RQ
 JOIN '||x.db_name||'.REQ_TYPE RT ON RT.TPR_TYPE_ID=RQ.RQ_TYPE_ID

WHERE

RQ.RQ_TYPE_ID in (119,117,107,3,109) AND RQ.RQ_REQ_PATH like ''AAAAAB%'' 

  ';

end loop;

END;

/
