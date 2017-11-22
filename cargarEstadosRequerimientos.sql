--------------------------------------------------------
--  DDL for Procedure cargarEstadosRequerimientos
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ALM_REPORT"."cargarEstadosRequerimientos" AS
BEGIN

execute immediate  'truncate table ALM_REPORT.ESTADOS_REQUERIMIENTOS';
 
for x in (select DB_NAME, PROJECT_NAME, DESCRIPTION from alm_siteadmin_db_12.projects where domain_name in ('PROYECTOS') and PR_IS_ACTIVE = 'Y') loop
execute immediate  'insert into ALM_REPORT.ESTADOS_REQUERIMIENTOS

SELECT 
DISTINCT 
RQ_USER_02 as estado,
COUNT(DISTINCT RQ_USER_02) as cantidad

FROM 
'||x.db_name||'.REQ 
GROUP BY 
RQ_USER_02
';
end loop;

execute immediate  'insert into ALM_REPORT.ESTADOS_REQUERIMIENTOS2

SELECT 
DISTINCT 
ALM_REPORT.ESTADOS_REQUERIMIENTOS."estado_requerimiento",
SUM(ALM_REPORT.ESTADOS_REQUERIMIENTOS."cantidad")

FROM 
ALM_REPORT.ESTADOS_REQUERIMIENTOS
GROUP BY 
ALM_REPORT.ESTADOS_REQUERIMIENTOS."estado_requerimiento"
';
execute immediate  'truncate table ALM_REPORT.ESTADOS_REQUERIMIENTOS';

END;

/
