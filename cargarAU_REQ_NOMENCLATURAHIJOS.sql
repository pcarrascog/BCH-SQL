--------------------------------------------------------
--  DDL for Procedure cargarAU_REQ_NOMENCLATURAHIJOS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ALM_REPORT"."cargarAU_REQ_NOMENCLATURAHIJOS" AS
BEGIN
execute immediate 'TRUNCATE TABLE ALM_REPORT.AU_REQ_NOMENCLATURAHIJOS';

for x in (select DB_NAME, PROJECT_NAME from alm_siteadmin_db_12.projects where domain_name in ('PROYECTOS') and PR_IS_ACTIVE = 'Y' ) loop
execute immediate  'insert into ALM_REPORT.AU_REQ_NOMENCLATURAHIJOS
SELECT
DISTINCT 
RQ.RQ_REQ_ID "ID REQ",
RQ.RQ_REQ_NAME "Nombre Req",
(SELECT MAX(REL_USER_04) FROM '||x.DB_NAME||'.RELEASES 
JOIN '||x.DB_NAME||'.REQ_RELEASES ON RQRL_RELEASE_ID = REL_ID
JOIN '||x.DB_NAME||'.REQ ON RQ_REQ_ID = RQRL_REQ_ID
WHERE RQ_REQ_ID = RQ.RQ_REQ_ID) as jpqa,

RQ.RQ_USER_12  "coordinador",

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
LEFT JOIN '||x.DB_NAME||'.REQ RQ1 ON RQ1.RQ_FATHER_ID = RQ.RQ_REQ_ID 
LEFT JOIN '||x.DB_NAME||'.REQ PADRE ON PADRE.RQ_REQ_ID = RQ.RQ_FATHER_ID
LEFT JOIN '||x.DB_NAME||'.REQ PADRE2 ON PADRE.RQ_FATHER_ID = PADRE2.RQ_REQ_ID

WHERE 
RQ.RQ_TYPE_ID = 101
AND

(RQ1.RQ_REQ_NAME NOT LIKE ''Pruebas Funcionales_Ciclo1'' AND
RQ1.RQ_REQ_NAME NOT LIKE ''Pruebas Funcionales_Ciclo2'' AND
RQ1.RQ_REQ_NAME NOT LIKE ''Pruebas Funcionales_Ciclo3'' AND
RQ1.RQ_REQ_NAME NOT LIKE ''Pruebas IDC'' AND
RQ1.RQ_REQ_NAME NOT LIKE ''Pruebas Estáticas''  )

';

end loop;

end;

/
