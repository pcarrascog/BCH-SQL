--------------------------------------------------------
--  DDL for Procedure cargarAU_REQ_SINCOBERTURA
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ALM_REPORT"."cargarAU_REQ_SINCOBERTURA" AS
BEGIN
execute immediate 'TRUNCATE TABLE ALM_REPORT.AU_REQ_SINCOBERTURA';

for x in (select DB_NAME, PROJECT_NAME from alm_siteadmin_db_12.projects where domain_name in ('PROYECTOS') and PR_IS_ACTIVE = 'Y' ) loop
execute immediate  'insert into ALM_REPORT.AU_REQ_SINCOBERTURA
SELECT
DISTINCT 
RQ.RQ_REQ_ID,
RQ.RQ_REQ_NAME,

(SELECT MAX(REL_USER_04) FROM '||x.DB_NAME||'.RELEASES 
JOIN '||x.DB_NAME||'.REQ_RELEASES ON RQRL_RELEASE_ID = REL_ID
JOIN '||x.DB_NAME||'.REQ ON RQ_REQ_ID = RQRL_REQ_ID
WHERE RQ_REQ_ID = RQ.RQ_REQ_ID) as jpqa,

CASE WHEN TPR.TPR_NAME = ''Proyecto'' THEN RQ.RQ_USER_12  
     WHEN TPR.TPR_NAME = ''Functional'' OR TPR.TPR_NAME = ''Estática'' OR TPR.TPR_NAME = ''Prueba IDC'' THEN PADRE.RQ_USER_12 
     ELSE PADRE2.RQ_USER_12 END   "coordinador",
RQ.RQ_REQ_DATE,
'''||x.PROJECT_NAME||''' as esquema,
TPR.TPR_NAME,
RC.RCYC_NAME,
R.REL_NAME,

(SELECT  count(DISTINCT  RQ_USER_02)
FROM  '||x.db_name||'.REQ
WHERE RQ_TYPE_ID = 101 
AND RQ_USER_02 NOT IN (''Términado QA'',''Finalizado'',''Cancelado'',''En Producción'',''Pospuesto'',''Cerrado QA'',''Traspaso a Continuidad'') )  as estado

FROM '||x.DB_NAME||'.REQ RQ
JOIN '||x.DB_NAME||'.REQ_TYPE TPR ON TPR.TPR_TYPE_ID = RQ.RQ_TYPE_ID
LEFT JOIN '||x.DB_NAME||'.REQ_COVER RQC ON RQC.RC_REQ_ID = RQ.RQ_REQ_ID
LEFT JOIN '||x.DB_NAME||'.REQ_CYCLES CI ON CI.RQC_REQ_ID = RQ.RQ_REQ_ID
LEFT JOIN '||x.DB_NAME||'.RELEASE_CYCLES RC ON RC.RCYC_ID = CI.RQC_CYCLE_ID
LEFT JOIN '||x.DB_NAME||'.REQ_RELEASES RQR ON RQR.RQRL_REQ_ID = RQ.RQ_REQ_ID
LEFT JOIN '||x.DB_NAME||'.RELEASES R ON R.REL_ID = RQR.RQRL_RELEASE_ID
LEFT JOIN '||x.DB_NAME||'.REQ PADRE ON PADRE.RQ_REQ_ID = RQ.RQ_FATHER_ID
LEFT JOIN '||x.DB_NAME||'.REQ PADRE2 ON PADRE.RQ_FATHER_ID = PADRE2.RQ_REQ_ID

WHERE TPR.TPR_NAME IN (''Functional'')
AND RQC.RC_ENTITY_ID IS NULL 
AND RQ.RQ_REQ_NAME NOT IN (''Requirements'',''Papelera'') 
AND PADRE.RQ_REQ_NAME NOT IN (''Papelera'')
AND PADRE2.RQ_REQ_NAME NOT IN (''Papelera'')
';

end loop;


end;
--TPR.TPR_NAME IN (''Functional'',''Producto IDC'')

/
