--------------------------------------------------------
--  DDL for Procedure CARGARAUDIT_REQ_SIN_TRAZ
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ALM_REPORT"."CARGARAUDIT_REQ_SIN_TRAZ" AS 
BEGIN
 execute immediate 'TRUNCATE TABLE ALM_REPORT.AUDIT_REQ_SIN_TRAZ';
 
for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME from alm_siteadmin_db_12.projects where DB_NAME = 'bch_qa_certificación_bch_qa_d') loop
execute immediate  'insert into ALM_REPORT.AUDIT_REQ_SIN_TRAZ

SELECT
DISTINCT 
RQ.RQ_REQ_ID "ID REQ",
RQ.RQ_REQ_NAME "Nombre Requerimiento",
--''''Al no poseer trazabilidad no se puede rescatar el JPQA'''' "JPQA",
(SELECT MAX(REL_USER_04) FROM '||x.db_name||'.RELEASES WHERE REL_ID = RQS.RQRL_RELEASE_ID) as jpqa,

CASE WHEN RQR.TPR_NAME = ''Proyecto'' THEN RQ.RQ_USER_33  
     WHEN RQR.TPR_NAME = ''Functional'' OR RQR.TPR_NAME = ''Estática'' OR RQR.TPR_NAME = ''Prueba IDC'' THEN PADRE.RQ_USER_33 
     ELSE PADRE2.RQ_USER_33 END   "coordinador",

RQ.RQ_REQ_DATE "Fecha Creación",
''BCH_QA_CERTIFICACIÓN_BCH_QA_D'' AS esquema,
RQR.TPR_NAME "Tipo Req",

''Requerimiento sin trazabilidad'' "Accion a Tomar", 

(SELECT  count(DISTINCT  RQ_USER_04)
FROM  '||x.db_name||'.REQ
WHERE RQ_TYPE_ID = 107
AND RQ_USER_04 NOT IN (''Términado QA'',''Finalizado'',''Cancelado'',''En Producción'',''Postpuesto'',''Cerrado QA'',''Traspaso a Continuidad'') )  as estado,

CASE
WHEN PADRE.RQ_REQ_NAME = ''Continuidad'' THEN ''MALO''
WHEN PADRE2.RQ_REQ_NAME = ''Continuidad'' THEN ''MALO''
ELSE ''BIEN'' END AS "validacion continuidad",
''SERVIDOR TSOFT'' as SERVIDOR


FROM

'||x.db_name||'.REQ RQ
JOIN '||x.db_name||'.REQ_TYPE RQR ON RQR.TPR_TYPE_ID = RQ.RQ_TYPE_ID
LEFT JOIN '||x.db_name||'.REQ_RELEASES RQS  ON RQS.RQRL_REQ_ID = RQ.RQ_REQ_ID
LEFT JOIN '||x.db_name||'.REQ_CYCLES RQC ON RQC.RQC_REQ_ID = RQ.RQ_REQ_ID
LEFT JOIN '||x.db_name||'.REQ PADRE ON PADRE.RQ_REQ_ID = RQ.RQ_FATHER_ID
LEFT JOIN '||x.db_name||'.REQ PADRE2 ON PADRE.RQ_FATHER_ID = PADRE2.RQ_REQ_ID


WHERE 
(RQS.RQRL_REQ_ID IS NULL OR RQC.RQC_REQ_ID IS NULL) AND
RQ.RQ_REQ_NAME NOT IN (''Requirements'',''Papelera'') AND
PADRE.RQ_REQ_NAME NOT IN (''Papelera'')
AND
RQR.TPR_NAME != ''Folder''


'; end loop;


execute immediate  'insert into ALM_REPORT.AUDIT_REQ_SIN_TRAZ 
select * from AUDIT_REQ_SIN_TRAZ@SERVER_BCH
';

END;

/
