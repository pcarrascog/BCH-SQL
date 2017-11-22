--------------------------------------------------------
--  DDL for Procedure esquemasSinReleases
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ALM_REPORT"."esquemasSinReleases" AS
BEGIN

execute immediate  'truncate table ALM_REPORT.ESQUEMAS_RELEASES';
 
for x in (select DB_NAME, PROJECT_NAME, DESCRIPTION from alm_siteadmin_db_12.projects where domain_name in ('PROYECTOS') and PR_IS_ACTIVE = 'Y' ) loop
execute immediate  'insert into ALM_REPORT.ESQUEMAS_RELEASES
SELECT 
DISTINCT 
'''||x.PROJECT_NAME||''' as esquema,
COUNT(DISTINCT REL_ID),
COUNT(DISTINCT CASE WHEN RQ_TYPE_ID = 101 THEN RQ_REQ_ID END ),
'''||x.DESCRIPTION||''' as descripcion

FROM 
'||x.db_name||'.RELEASES , '||x.db_name||'.REQ 
WHERE  REL_NAME != ''Prueba''
';
end loop;

END;

/
