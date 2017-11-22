--------------------------------------------------------
--  DDL for Procedure CARGARAUDIT_REQ_SIN_COB
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ALM_REPORT"."CARGARAUDIT_REQ_SIN_COB" AS 
BEGIN
 execute immediate 'TRUNCATE TABLE ALM_REPORT.AUDIT_REQ_SIN_COB';
 
for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME from alm_siteadmin_db_12.projects where DB_NAME = 'bch_qa_certificación_bch_qa_d') loop
execute immediate  'insert into ALM_REPORT.AUDIT_REQ_SIN_COB

SELECT
DISTINCT 
RQ.RQ_REQ_ID "ID Requerimiento",
RQ.RQ_REQ_NAME "Nombre Requerimiento",

(SELECT MAX(REL_USER_TEMPLATE_01) FROM '||x.db_name||'.RELEASES 
JOIN '||x.db_name||'.REQ_RELEASES ON RQRL_RELEASE_ID = REL_ID
JOIN '||x.db_name||'.REQ ON RQ_REQ_ID = RQRL_REQ_ID
WHERE RQ_REQ_ID = RQ.RQ_REQ_ID) as jpqa,

CASE WHEN TPR.TPR_NAME = ''Proyecto'' THEN RQ.RQ_USER_33  
     WHEN TPR.TPR_NAME = ''Functional'' OR TPR.TPR_NAME = ''Estática'' OR TPR.TPR_NAME = ''Prueba IDC'' THEN PADRE.RQ_USER_33 
     ELSE PADRE2.RQ_USER_33 END   "coordinador",
RQ.RQ_REQ_DATE,
''BCH_QA_CERTIFICACIÓN_BCH_QA_D'' as esquema,

RC.RCYC_NAME,
R.REL_NAME,
''Requerimiento sin cobertura'' "Accion a Tomar",

(SELECT  count(DISTINCT  RQ_USER_04)
FROM  '||x.db_name||'.REQ
WHERE RQ_TYPE_ID = 107 
AND RQ_USER_04 NOT IN (''Términado QA'',''Finalizado'',''Cancelado'',''En Producción'',''Postpuesto'',''Cerrado QA'',''Traspaso a Continuidad'') )  as estado,
TPR.TPR_NAME "Tipo Req",
''SERVIDOR TSOFT'' as SERVIDOR

FROM '||x.db_name||'.REQ RQ
JOIN '||x.db_name||'.REQ_TYPE TPR ON TPR.TPR_TYPE_ID = RQ.RQ_TYPE_ID
LEFT JOIN '||x.db_name||'.REQ_COVER RQC ON RQC.RC_REQ_ID = RQ.RQ_REQ_ID
LEFT JOIN '||x.db_name||'.REQ_CYCLES CI ON CI.RQC_REQ_ID = RQ.RQ_REQ_ID
LEFT JOIN '||x.db_name||'.RELEASE_CYCLES RC ON RC.RCYC_ID = CI.RQC_CYCLE_ID
LEFT JOIN '||x.db_name||'.REQ_RELEASES RQR ON RQR.RQRL_REQ_ID = RQ.RQ_REQ_ID
LEFT JOIN '||x.db_name||'.RELEASES R ON R.REL_ID = RQR.RQRL_RELEASE_ID
LEFT JOIN '||x.db_name||'.REQ PADRE ON PADRE.RQ_REQ_ID = RQ.RQ_FATHER_ID
LEFT JOIN '||x.db_name||'.REQ PADRE2 ON PADRE.RQ_FATHER_ID = PADRE2.RQ_REQ_ID

WHERE
TPR.TPR_NAME IN (''Functional'',''Producto IDC'')
AND RQC.RC_ENTITY_ID IS NULL AND
RQ.RQ_REQ_NAME NOT IN (''Requirements'',''Papelera'') AND
PADRE.RQ_REQ_NAME NOT IN (''Papelera'')

'; end loop;

execute immediate  'insert into ALM_REPORT.AUDIT_REQ_SIN_COB 
select * from AUDIT_REQ_SIN_COB@SERVER_BCH
';

END;

/
