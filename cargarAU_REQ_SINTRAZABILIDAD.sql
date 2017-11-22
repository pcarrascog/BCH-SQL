--------------------------------------------------------
--  DDL for Procedure cargarAU_REQ_SINTRAZABILIDAD
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ALM_REPORT"."cargarAU_REQ_SINTRAZABILIDAD" AS
BEGIN
execute immediate 'TRUNCATE TABLE ALM_REPORT.AU_REQ_SINTRAZABILIDAD';

for x in (select DB_NAME, PROJECT_NAME from alm_siteadmin_db_12.projects where domain_name in ('PROYECTOS') and PR_IS_ACTIVE = 'Y' ) loop
execute immediate  'insert into ALM_REPORT.AU_REQ_SINTRAZABILIDAD
SELECT
DISTINCT 
RQ.RQ_REQ_ID "ID REQ",
RQ.RQ_REQ_NAME "Nombre Req",
--''Al no poseer trazabilidad no se puede rescatar el JPQA'' "JPQA",
(SELECT MAX(REL_USER_04) FROM '||x.DB_NAME||'.RELEASES WHERE REL_ID = RQS.RQRL_RELEASE_ID) as jpqa,

CASE WHEN RQR.TPR_NAME = ''Proyecto'' THEN RQ.RQ_USER_12  
     WHEN RQR.TPR_NAME = ''Functional'' OR RQR.TPR_NAME = ''Estática'' OR RQR.TPR_NAME = ''Prueba IDC'' THEN PADRE.RQ_USER_12 
     ELSE PADRE2.RQ_USER_12 END   "coordinador",

RQ.RQ_REQ_DATE "Fecha Creación",
'''||x.PROJECT_NAME||'''  AS esquema,
RQR.TPR_NAME "Tipo Req",

(SELECT  count(DISTINCT  RQ_USER_02)
FROM  '||x.db_name||'.REQ
WHERE RQ_TYPE_ID = 101 
AND RQ_USER_02 NOT IN (''Términado QA'',''Finalizado'',''Cancelado'',''En Producción'',''Pospuesto'',''Cerrado QA'',''Traspaso a Continuidad'') )  as estado


FROM

'||x.DB_NAME||'.REQ RQ
JOIN '||x.DB_NAME||'.REQ_TYPE RQR ON RQR.TPR_TYPE_ID = RQ.RQ_TYPE_ID
LEFT JOIN '||x.DB_NAME||'.REQ_RELEASES RQS  ON RQS.RQRL_REQ_ID = RQ.RQ_REQ_ID
LEFT JOIN '||x.DB_NAME||'.REQ_CYCLES RQC ON RQC.RQC_REQ_ID = RQ.RQ_REQ_ID
LEFT JOIN '||x.DB_NAME||'.REQ PADRE ON PADRE.RQ_REQ_ID = RQ.RQ_FATHER_ID
LEFT JOIN '||x.DB_NAME||'.REQ PADRE2 ON PADRE.RQ_FATHER_ID = PADRE2.RQ_REQ_ID


WHERE 
(RQS.RQRL_REQ_ID IS NULL OR RQC.RQC_REQ_ID IS NULL) AND
RQ.RQ_REQ_NAME NOT IN (''Requirements'',''Papelera'') AND
PADRE.RQ_REQ_NAME NOT IN (''Papelera'')
AND
RQR.TPR_NAME != ''Folder''
';

end loop;


end;

/
