--------------------------------------------------------
--  DDL for Procedure querysCristian
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ALM_REPORT"."querysCristian" AS
BEGIN
execute immediate 'TRUNCATE TABLE ALM_REPORT.QUERY_CRISTIAN1';
execute immediate 'TRUNCATE TABLE ALM_REPORT.QUERY_CRISTIAN2';

for x in (select DB_NAME, PROJECT_NAME, DESCRIPTION, DOMAIN_NAME from alm_siteadmin_db_12.projects where domain_name in ('PROYECTOS') and PR_IS_ACTIVE = 'Y' ) loop
execute immediate  'insert into ALM_REPORT.QUERY_CRISTIAN1
SELECT 
'''||x.DOMAIN_NAME||''' as dominio,
'''||x.PROJECT_NAME||''' as esquema,
p.TS_TEST_ID ,
p.TS_NAME ,
p.TS_TYPE ,
p.TS_RESPONSIBLE ,
p.TS_CREATION_DATE ,
p.TS_VTS ,
p.TS_USER_01 "Sistema",
p.TS_USER_03 

FROM '||x.DB_NAME||'.TEST p 
LEFT OUTER JOIN '||x.DB_NAME||'.TESTCYCL l ON p.TS_TEST_ID = l.TC_TEST_ID
WHERE l.TC_TEST_ID IS NULL

';
end loop;


for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME, DESCRIPTION from alm_siteadmin_db_12.projects where DB_NAME = 'continuidad_automatización_db') loop
execute immediate  'insert into ALM_REPORT.QUERY_CRISTIAN1
SELECT 
'''||x.DOMAIN_NAME||''' as dominio,
'''||x.PROJECT_NAME||''' as esquema,
p.TS_TEST_ID ,
p.TS_NAME ,
p.TS_TYPE ,
p.TS_RESPONSIBLE ,
p.TS_CREATION_DATE ,
p.TS_VTS ,
p.TS_USER_01 "Sistema",
p.TS_USER_03 

FROM '||x.DB_NAME||'.TEST p 
LEFT OUTER JOIN '||x.DB_NAME||'.TESTCYCL l ON p.TS_TEST_ID = l.TC_TEST_ID
WHERE l.TC_TEST_ID IS NULL

';
end loop;


for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME, DESCRIPTION from alm_siteadmin_db_12.projects WHERE DB_NAME = 'proveedores_testing_sqa_db') loop
execute immediate  'insert into ALM_REPORT.QUERY_CRISTIAN1
SELECT 
'''||x.DOMAIN_NAME||''' as dominio,
'''||x.PROJECT_NAME||''' as esquema,
p.TS_TEST_ID ,
p.TS_NAME ,
p.TS_TYPE ,
p.TS_RESPONSIBLE ,
p.TS_CREATION_DATE ,
p.TS_VTS ,
p.TS_USER_01 "Sistema",
p.TS_USER_03 

FROM '||x.DB_NAME||'.TEST p 
LEFT OUTER JOIN '||x.DB_NAME||'.TESTCYCL l ON p.TS_TEST_ID = l.TC_TEST_ID
WHERE l.TC_TEST_ID IS NULL

';
end loop;

for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME, DESCRIPTION from alm_siteadmin_db_12.projects where DB_NAME = 'bch_qcsitebch_db') loop
execute immediate  'insert into ALM_REPORT.QUERY_CRISTIAN1
SELECT 
'''||x.DOMAIN_NAME||''' as dominio,
'''||x.PROJECT_NAME||''' as esquema,
p.TS_TEST_ID ,
p.TS_NAME ,
p.TS_TYPE ,
p.TS_RESPONSIBLE ,
p.TS_CREATION_DATE ,
p.TS_VTS ,
p.TS_USER_01 "Sistema",
p.TS_USER_03 

FROM '||x.DB_NAME||'.TEST p 
LEFT OUTER JOIN '||x.DB_NAME||'.TESTCYCL l ON p.TS_TEST_ID = l.TC_TEST_ID
WHERE l.TC_TEST_ID IS NULL

';
end loop;

for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME, DESCRIPTION from alm_siteadmin_db_12.projects where domain_name = 'SYSTEM_TEST') loop
execute immediate  'insert into ALM_REPORT.QUERY_CRISTIAN1
SELECT 
'''||x.DOMAIN_NAME||''' as dominio,
'''||x.PROJECT_NAME||''' as esquema,
p.TS_TEST_ID ,
p.TS_NAME ,
p.TS_TYPE ,
p.TS_RESPONSIBLE ,
p.TS_CREATION_DATE ,
p.TS_VTS ,
p.TS_USER_01 "Sistema",
p.TS_USER_03 

FROM '||x.DB_NAME||'.TEST p 
LEFT OUTER JOIN '||x.DB_NAME||'.TESTCYCL l ON p.TS_TEST_ID = l.TC_TEST_ID
WHERE l.TC_TEST_ID IS NULL

';
end loop;

for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME, DESCRIPTION from alm_siteadmin_db_12.projects where DOMAIN_NAME = 'QA') loop
execute immediate  'insert into ALM_REPORT.QUERY_CRISTIAN1
SELECT 
'''||x.DOMAIN_NAME||''' as dominio,
'''||x.PROJECT_NAME||''' as esquema,
p.TS_TEST_ID ,
p.TS_NAME ,
p.TS_TYPE ,
p.TS_RESPONSIBLE ,
p.TS_CREATION_DATE ,
p.TS_VTS ,
p.TS_USER_05 "Sistema",
p.TS_USER_01 

FROM '||x.DB_NAME||'.TEST p 
LEFT OUTER JOIN '||x.DB_NAME||'.TESTCYCL l ON p.TS_TEST_ID = l.TC_TEST_ID
WHERE l.TC_TEST_ID IS NULL

';
end loop;




-----------------------------------------------------------------QUERY 2 ----------------------------------------------------

for x in (select DB_NAME, PROJECT_NAME, DESCRIPTION, DOMAIN_NAME from alm_siteadmin_db_12.projects where domain_name in ('PROYECTOS') and PR_IS_ACTIVE = 'Y' ) loop
execute immediate  'insert into ALM_REPORT.QUERY_CRISTIAN2
SELECT 
'''||x.DOMAIN_NAME||''' as dominio,
'''||x.PROJECT_NAME||''' as esquema,
l.TC_CYCLE_ID "ID_TEST_SET",
p.TS_NAME "Nombre Test",
p.TS_TYPE "Tipo Test",
l.TC_VTS "Fecha Ultima Modificación",
p.TS_USER_01 "Sistema",
p.TS_USER_03 "Funcion de negocio"
FROM '||x.DB_NAME||'.TEST p 
JOIN '||x.DB_NAME||'.TESTCYCL l ON p.TS_TEST_ID=l.TC_TEST_ID
WHERE l.TC_STATUS=''No Run'' 


';
end loop;


for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME, DESCRIPTION from alm_siteadmin_db_12.projects where DB_NAME = 'continuidad_automatización_db') loop
execute immediate  'insert into ALM_REPORT.QUERY_CRISTIAN2
SELECT 
'''||x.DOMAIN_NAME||''' as dominio,
'''||x.PROJECT_NAME||''' as esquema,
l.TC_CYCLE_ID "ID_TEST_SET",
p.TS_NAME "Nombre Test",
p.TS_TYPE "Tipo Test",
l.TC_VTS "Fecha Ultima Modificación",
p.TS_USER_01 "Sistema",
p.TS_USER_03 "Funcion de negocio"
FROM '||x.DB_NAME||'.TEST p 
JOIN '||x.DB_NAME||'.TESTCYCL l ON p.TS_TEST_ID=l.TC_TEST_ID
WHERE l.TC_STATUS=''No Run'' 


';
end loop;


for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME, DESCRIPTION from alm_siteadmin_db_12.projects WHERE DB_NAME = 'proveedores_testing_sqa_db') loop
execute immediate  'insert into ALM_REPORT.QUERY_CRISTIAN2
SELECT 
'''||x.DOMAIN_NAME||''' as dominio,
'''||x.PROJECT_NAME||''' as esquema,
 l.TC_CYCLE_ID "ID_TEST_SET",
p.TS_NAME "Nombre Test",
p.TS_TYPE "Tipo Test",
l.TC_VTS "Fecha Ultima Modificación",
p.TS_USER_01 "Sistema",
p.TS_USER_03 "Funcion de negocio"
FROM '||x.DB_NAME||'.TEST p 
JOIN '||x.DB_NAME||'.TESTCYCL l ON p.TS_TEST_ID=l.TC_TEST_ID
WHERE l.TC_STATUS=''No Run'' 


';
end loop;

for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME, DESCRIPTION from alm_siteadmin_db_12.projects where DB_NAME = 'bch_qcsitebch_db') loop
execute immediate  'insert into ALM_REPORT.QUERY_CRISTIAN2
SELECT 
'''||x.DOMAIN_NAME||''' as dominio,
'''||x.PROJECT_NAME||''' as esquema,
l.TC_CYCLE_ID "ID_TEST_SET",
p.TS_NAME "Nombre Test",
p.TS_TYPE "Tipo Test",
l.TC_VTS "Fecha Ultima Modificación",
p.TS_USER_01 "Sistema",
p.TS_USER_03 "Funcion de negocio"
FROM '||x.DB_NAME||'.TEST p 
JOIN '||x.DB_NAME||'.TESTCYCL l ON p.TS_TEST_ID=l.TC_TEST_ID
WHERE l.TC_STATUS=''No Run'' 


';
end loop;


for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME, DESCRIPTION from alm_siteadmin_db_12.projects where domain_name = 'SYSTEM_TEST') loop
execute immediate  'insert into ALM_REPORT.QUERY_CRISTIAN2
SELECT 
'''||x.DOMAIN_NAME||''' as dominio,
'''||x.PROJECT_NAME||''' as esquema,
l.TC_CYCLE_ID "ID_TEST_SET",
p.TS_NAME "Nombre Test",
p.TS_TYPE "Tipo Test",
l.TC_VTS "Fecha Ultima Modificación",
p.TS_USER_01 "Sistema",
p.TS_USER_03 "Funcion de negocio"
FROM '||x.DB_NAME||'.TEST p 
JOIN '||x.DB_NAME||'.TESTCYCL l ON p.TS_TEST_ID=l.TC_TEST_ID
WHERE l.TC_STATUS=''No Run'' 

';
end loop;

for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME, DESCRIPTION from alm_siteadmin_db_12.projects where DOMAIN_NAME = 'QA') loop
execute immediate  'insert into ALM_REPORT.QUERY_CRISTIAN2
SELECT 
'''||x.DOMAIN_NAME||''' as dominio,
'''||x.PROJECT_NAME||''' as esquema,
l.TC_CYCLE_ID "ID_TEST_SET",
p.TS_NAME "Nombre Test",
p.TS_TYPE "Tipo Test",
l.TC_VTS "Fecha Ultima Modificación",
p.TS_USER_05 "Sistema",
p.TS_USER_01 "Funcion de negocio"
FROM '||x.DB_NAME||'.TEST p 
JOIN '||x.DB_NAME||'.TESTCYCL l ON p.TS_TEST_ID=l.TC_TEST_ID
WHERE l.TC_STATUS=''No Run'' 

';
end loop;










END;

/
