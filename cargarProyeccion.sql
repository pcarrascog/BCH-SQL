--------------------------------------------------------
--  DDL for Procedure cargarProyeccion
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ALM_REPORT"."cargarProyeccion" AS
BEGIN

execute immediate 'TRUNCATE TABLE ALM_REPORT.PROYECCION';

for x in (select DB_NAME, PROJECT_NAME, DESCRIPTION, DOMAIN_NAME from alm_siteadmin_db_12.projects where domain_name in ('PROYECTOS') and PR_IS_ACTIVE = 'Y') loop
execute immediate  'insert into ALM_REPORT.PROYECCION
SELECT
DISTINCT
TC.TC_EXEC_DATE,
TC.TC_TESTCYCL_ID,
'''||x.DOMAIN_NAME||''' as dominio


FROM '||x.DB_NAME||'.TESTCYCL TC
WHERE
TC.TC_EXEC_DATE IS NOT NULL
';
end loop;



for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME, DESCRIPTION from alm_siteadmin_db_12.projects WHERE DB_NAME = 'proveedores_testing_sqa_db')loop
execute immediate  'insert into ALM_REPORT.PROYECCION
SELECT
DISTINCT
TC.TC_EXEC_DATE,
TC.TC_TESTCYCL_ID,
'''||X.DOMAIN_NAME||''' as dominio


FROM '||x.DB_NAME||'.TESTCYCL TC
WHERE
TC.TC_EXEC_DATE IS NOT NULL
';

end loop;


for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME from alm_siteadmin_db_12.projects where DOMAIN_NAME = 'QA') loop
execute immediate  'insert into ALM_REPORT.PROYECCION
SELECT
DISTINCT
TC.TC_EXEC_DATE,
TC.TC_TESTCYCL_ID,
'''||X.DOMAIN_NAME||''' as dominio


FROM '||x.DB_NAME||'.TESTCYCL TC
WHERE
TC.TC_EXEC_DATE IS NOT NULL
';

end loop;




for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME, DESCRIPTION from alm_siteadmin_db_12.projects where DB_NAME = 'continuidad_automatización_db') loop
execute immediate  'insert into ALM_REPORT.PROYECCION
SELECT
DISTINCT
TC.TC_EXEC_DATE,
TC.TC_TESTCYCL_ID,
'''||X.DOMAIN_NAME||''' as dominio


FROM '||x.DB_NAME||'.TESTCYCL TC
WHERE
TC.TC_EXEC_DATE IS NOT NULL
';

end loop;


for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME from alm_siteadmin_db_12.projects where DB_NAME = 'bch_qcsitebch_db') loop
execute immediate  'insert into ALM_REPORT.PROYECCION
SELECT
DISTINCT
TC.TC_EXEC_DATE,
TC.TC_TESTCYCL_ID,
'''||X.DOMAIN_NAME||''' as dominio


FROM '||x.DB_NAME||'.TESTCYCL TC
WHERE
TC.TC_EXEC_DATE IS NOT NULL
';

end loop;




END;

/
