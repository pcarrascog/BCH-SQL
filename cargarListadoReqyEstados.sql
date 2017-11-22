--------------------------------------------------------
--  DDL for Procedure cargarListadoReqyEstados
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ALM_REPORT"."cargarListadoReqyEstados" AS
BEGIN

execute immediate 'TRUNCATE TABLE ALM_REPORT.REQUERIMIENTOS_Y_ESTADOS';

for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME from alm_siteadmin_db_12.projects where domain_name in ('PROYECTOS')) loop
execute immediate  'insert into ALM_REPORT.REQUERIMIENTOS_Y_ESTADOS
SELECT
'''||x.PROJECT_NAME||''' as esquema,
RQ.RQ_REQ_ID,
RQ.RQ_REQ_NAME,
RQ.RQ_USER_02,
RQ.RQ_REQ_AUTHOR,
RQ.RQ_USER_03,
RQ.RQ_VTS

FROM
 '||x.db_name||'.REQ RQ
 JOIN '||x.db_name||'.REQ_TYPE RT ON RT.TPR_TYPE_ID=RQ.RQ_TYPE_ID

WHERE

RT.TPR_NAME in (''Proyecto Normativo'',''Proyecto'')
 
  ';

end loop;


END;

/
