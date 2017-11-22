--------------------------------------------------------
--  DDL for Procedure cargarDetalleNuevaInternet
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ALM_REPORT"."cargarDetalleNuevaInternet" AS
BEGIN
execute immediate 'TRUNCATE TABLE ALM_REPORT.DETALLE_NUEVA_INTERNET';
for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME from alm_siteadmin_db_12.projects where DOMAIN_NAME = 'QA') loop
execute immediate 'insert into ALM_REPORT.DETALLE_NUEVA_INTERNET
SELECT
DISTINCT
R.REL_START_DATE,
R.REL_NAME ,
RQ.RQ_REQ_NAME

FROM '||x.db_name||'.RELEASE_FOLDERS RF
LEFT JOIN '||x.db_name||'.RELEASES R ON R.REL_PARENT_ID = RF.RF_ID
LEFT JOIN '||x.db_name||'.REQ_RELEASES RQRL ON RQRL.RQRL_RELEASE_ID = R.REL_ID
LEFT JOIN '||x.db_name||'.REQ RQ ON RQ.RQ_REQ_ID = RQRL.RQRL_REQ_ID
WHERE R.REL_NAME != '' ''

START WITH RF.RF_ID = 105
CONNECT BY PRIOR RF.RF_ID = RF_PARENT_ID


';

end loop;

END;

/
