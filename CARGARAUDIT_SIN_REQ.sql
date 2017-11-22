--------------------------------------------------------
--  DDL for Procedure CARGARAUDIT_SIN_REQ
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ALM_REPORT"."CARGARAUDIT_SIN_REQ" AS 
BEGIN
 execute immediate 'TRUNCATE TABLE ALM_REPORT.AUDIT_SIN_REQ';
 
for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME from alm_siteadmin_db_12.projects where DB_NAME = 'bch_qa_certificación_bch_qa_d') loop
execute immediate  'insert into ALM_REPORT.AUDIT_SIN_REQ

SELECT
R.REL_ID"Release ID",
R.REL_NAME"Nombre Releses",
R.REL_USER_TEMPLATE_01 "JPQA",
RQ.RQ_USER_33 "Coordinador de Servicio",
R.REL_DESCRIPTION"Descripción",

CASE  WHEN (RQ.RQ_REQ_ID IS NULL) THEN ''Asociar Release a Requerimiento''
ELSE ''OK'' END AS "Accion a Tomar",
''SERVIDOR TSOFT'' as SERVIDOR

FROM '||x.db_name||'.RELEASES R
LEFT JOIN '||x.db_name||'.REQ_RELEASES RR ON RR.RQRL_RELEASE_ID = R.REL_ID
LEFT JOIN '||x.db_name||'.REQ RQ ON RQ.RQ_REQ_ID = RR.RQRL_REQ_ID
LEFT JOIN '||x.db_name||'.RELEASE_FOLDERS RF ON R.REL_PARENT_ID = RF.RF_ID

WHERE RQ.RQ_REQ_ID IS NULL

AND RF.RF_PATH like ''AAAAAA%''

'; end loop;


execute immediate  'insert into ALM_REPORT.AUDIT_SIN_REQ 
select * from AUDIT_SIN_REQ@SERVER_BCH
';


END;

/
