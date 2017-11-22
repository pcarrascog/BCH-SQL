--------------------------------------------------------
--  DDL for Procedure CARGARAUDIT_TEST_CAMPOINV
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ALM_REPORT"."CARGARAUDIT_TEST_CAMPOINV" AS 
BEGIN
 execute immediate 'TRUNCATE TABLE ALM_REPORT.AUDIT_TEST_CAMPOINV';
 
for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME from alm_siteadmin_db_12.projects where DB_NAME = 'bch_qa_certificación_bch_qa_d') loop
execute immediate  'insert into ALM_REPORT.AUDIT_TEST_CAMPOINV

SELECT
DISTINCT
TS.TS_TEST_ID "ID Test",
TS.TS_NAME "Nombre Test",
RQ.RQ_USER_12 "Coordinador",
REL.REL_USER_TEMPLATE_01 "Jpqa",

''Corregir campo descripción'' "Accion a Tomar",
''SERVIDOR TSOFT'' as SERVIDOR

FROM
'||x.db_name||'.TEST TS
LEFT JOIN '||x.db_name||'.REQ_COVER RC ON RC.RC_ENTITY_ID = TS_TEST_ID AND RC.RC_ENTITY_TYPE = ''TEST''
LEFT JOIN '||x.db_name||'.REQ RQ ON RQ.RQ_REQ_ID = RC.RC_REQ_ID
LEFT JOIN '||x.db_name||'.REQ_RELEASES RQRL ON RQRL.RQRL_REQ_ID = RQ.RQ_REQ_ID
LEFT JOIN '||x.db_name||'.RELEASES REL ON REL.REL_ID = RQRL.RQRL_RELEASE_ID
LEFT JOIN '||x.db_name||'.RELEASE_FOLDERS RF ON REL.REL_PARENT_ID = RF.RF_ID

WHERE
(
UPPER(TS.TS_DESCRIPTION) NOT LIKE ''%OBJETIVO%'' AND
UPPER(TS.TS_DESCRIPTION) NOT LIKE ''%ÉXITO%'' AND
UPPER(TS.TS_DESCRIPTION) NOT LIKE ''%RECURSOS REQUERIDOS%'' AND
UPPER(TS.TS_DESCRIPTION) NOT LIKE ''%PRECONDICIONES%''
)

AND RF.RF_PATH like ''AAAAAA%'' 
--or RF.RF_PATH like ''AAAAAB%'')


'; end loop;


execute immediate  'insert into ALM_REPORT.AUDIT_TEST_CAMPOINV 
select * from AUDIT_TEST_CAMPOINV@SERVER_BCH
';


END;

/
