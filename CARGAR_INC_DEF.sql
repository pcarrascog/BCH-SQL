--------------------------------------------------------
--  DDL for Procedure CARGAR_INC_DEF
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ALM_REPORT"."CARGAR_INC_DEF" AS 
BEGIN
 execute immediate 'TRUNCATE TABLE ALM_REPORT.INC_DEF_QA';
 
for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME from alm_siteadmin_db_12.projects where DB_NAME = 'bch_qa_certificación_bch_qa_d') loop
execute immediate  'insert into ALM_REPORT.INC_DEF_QA 

SELECT
HQ1.RQ_USER_11  as Incidente_PROVEEDOR,
HQ1.RQ_REQ_ID   as Incidente_Id_Req,
HQ1.RQ_USER_02  as N_Incidente_o_PPM,
HQ1.RQ_USER_04  as Estado_actual,
HQ1.RQ_USER_39  as Sub_Estado,
HQ1.RQ_USER_10  as Sistema,
HQ1.RQ_USER_33  as Coordinador_QA,
BUG.BG_BUG_ID BUG_ID,
BUG.BG_USER_01 BUG_ESTADO,
BUG.BG_USER_08 BUG_TIPO,
BUG.BG_USER_TEMPLATE_17,
BUG.BG_USER_05 BUG_PROVEEDOR,
BUG.BG_RESPONSIBLE BUG_RESPONSABLE,
BG_SEVERITY  Bug_severidad,
BG_DETECTION_DATE "Fecha_Creación",
sysdate,
TPR_NAME,
TPR_TYPE_ID,
DIAS_LABORABLES(BG_DETECTION_DATE,SYSDATE) "Dias_Trans",
''SERVIDOR TSOFT'' as SERVIDOR

FROM '||x.db_name||'.REQ HQ1
LEFT JOIN '||x.db_name||'.REQ_TYPE ON RQ_TYPE_ID = TPR_TYPE_ID
LEFT JOIN '||x.db_name||'.REQ_RELEASES on RQ_REQ_ID = RQRL_REQ_ID
LEFT JOIN '||x.db_name||'.RELEASES on RQRL_RELEASE_ID = REL_ID
LEFT JOIN '||x.db_name||'.BUG on REL_ID = BUG.BG_TARGET_REL OR REL_ID = BUG.BG_DETECTED_IN_REL

WHERE HQ1.RQ_TYPE_ID in (102,116,121,124,125)
AND HQ1.RQ_USER_04 not in (''Finalizado'',''Cerrado'',''Creado'',''Cancelado'')
AND BUG.BG_USER_01 not in (''Cancelado'')

'; end loop;

execute immediate  'insert into ALM_REPORT.INC_DEF_QA 
select * from INC_DEF_QA@SERVER_BCH
';

end;

/
