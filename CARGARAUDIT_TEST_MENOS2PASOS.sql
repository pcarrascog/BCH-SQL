--------------------------------------------------------
--  DDL for Procedure CARGARAUDIT_TEST_MENOS2PASOS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ALM_REPORT"."CARGARAUDIT_TEST_MENOS2PASOS" AS 
BEGIN
 execute immediate 'TRUNCATE TABLE ALM_REPORT.AUDIT_TEST_MENOS2PASOS';
 
for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME from alm_siteadmin_db_12.projects where DB_NAME = 'bch_qa_certificación_bch_qa_d') loop
execute immediate  'insert into ALM_REPORT.AUDIT_TEST_MENOS2PASOS

SELECT
DISTINCT
TS.TS_TEST_ID "ID Test",
TS.TS_NAME "Nombre Test",
RQ.RQ_USER_12 "Coordinador",
REL.REL_USER_TEMPLATE_01 "Jpqa",

COUNT(DISTINCT DS_ID) as numero_pasos,

''Corregir diseño de pasos'' "Accion a Tomar",
TS.TS_USER_06 Tipo_Req,
''SERVIDOR TSOFT'' as SERVIDOR

FROM
'||x.db_name||'.TEST TS
LEFT JOIN '||x.db_name||'.REQ_COVER RC ON RC.RC_ENTITY_ID = TS_TEST_ID AND RC.RC_ENTITY_TYPE = ''TEST''
LEFT JOIN '||x.db_name||'.REQ RQ ON RQ.RQ_REQ_ID = RC.RC_REQ_ID
JOIN '||x.db_name||'.REQ_TYPE RQR ON RQR.TPR_TYPE_ID = RQ.RQ_TYPE_ID
LEFT JOIN '||x.db_name||'.REQ_RELEASES RQRL ON RQRL.RQRL_REQ_ID = RQ.RQ_REQ_ID
LEFT JOIN '||x.db_name||'.RELEASES REL ON REL.REL_ID = RQRL.RQRL_RELEASE_ID
LEFT JOIN '||x.db_name||'.DESSTEPS DS ON TS.TS_TEST_ID = DS.DS_TEST_ID
LEFT JOIN '||x.db_name||'.RELEASE_FOLDERS RF ON REL.REL_PARENT_ID = RF.RF_ID

WHERE
TS.TS_TYPE LIKE ''%MANUAL%''  and TS_STATUS  not like ''%Cancelado%'' and  ts_user_02 not like ''%Genérico%''
AND RF.RF_PATH like ''AAAAAA%'' 

HAVING
COUNT(DISTINCT DS.DS_ID) <= 2

GROUP BY
TS.TS_TEST_ID,
TS.TS_NAME,
RQ.RQ_USER_12,
REL.REL_USER_TEMPLATE_01
,TS.TS_USER_06

'; end loop;


execute immediate  'insert into ALM_REPORT.AUDIT_TEST_MENOS2PASOS 
select * from AUDIT_TEST_MENOS2PASOS@SERVER_BCH
';


END;

/
