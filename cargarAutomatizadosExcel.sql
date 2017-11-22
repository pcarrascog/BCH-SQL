--------------------------------------------------------
--  DDL for Procedure cargarAutomatizadosExcel
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ALM_REPORT"."cargarAutomatizadosExcel" AS
BEGIN

execute immediate 'TRUNCATE TABLE ALM_REPORT.AUTOMATIZADOS_EXCEL';


for x in (select DB_NAME, PROJECT_NAME, DESCRIPTION from alm_siteadmin_db_12.projects where domain_name in ('PROYECTOS') and PR_IS_ACTIVE = 'Y') loop
execute immediate  'insert into ALM_REPORT.AUTOMATIZADOS_EXCEL
SELECT
DISTINCT 
'''||x.PROJECT_NAME||'''  as esquema,
T.TS_CREATION_DATE as fecha_creacion,
'''||x.PROJECT_NAME||''' || ''.''|| T.TS_TEST_ID ,
T.TS_TYPE "TIPO CASO",
''TRADICIONALES'' as dominio,
''FECHA CREACION'' as tipo_fecha,
T.TS_VC_VERSION_NUMBER

FROM
'||x.DB_NAME||'.TEST T

WHERE
T.TS_SUBJECT NOT IN 
(SELECT
AL_ITEM_ID
FROM '||x.DB_NAME||'.ALL_LISTS
CONNECT BY PRIOR AL_ITEM_ID = AL_FATHER_ID
START WITH AL_DESCRIPTION = ''Papelera'')




';
end loop;

for x in (select DB_NAME, PROJECT_NAME, DESCRIPTION from alm_siteadmin_db_12.projects where domain_name in ('PROYECTOS') and PR_IS_ACTIVE = 'Y') loop
execute immediate  'insert into ALM_REPORT.AUTOMATIZADOS_EXCEL
SELECT
DISTINCT 
'''||x.PROJECT_NAME||'''  as esquema,
TC.TC_EXEC_DATE as fecha_ejecucion,
'''||x.PROJECT_NAME||''' || ''.''|| T.TS_TEST_ID  ,
T.TS_TYPE "TIPO CASO",
''TRADICIONALES'' as dominio,
''FECHA EJECUCION'' as tipo_fecha,
T.TS_VC_VERSION_NUMBER

FROM
'||x.DB_NAME||'.TEST T 
LEFT JOIN '||x.DB_NAME||'.TESTCYCL TC ON TC.TC_TEST_ID = T.TS_TEST_ID
LEFT JOIN '||x.DB_NAME||'.CYCLE C ON C.CY_CYCLE_ID = TC.TC_CYCLE_ID
LEFT JOIN '||x.DB_NAME||'.CYCL_FOLD CF ON CF.CF_ITEM_ID = C.CY_FOLDER_ID

WHERE

C.CY_FOLDER_ID NOT IN 
(SELECT
CF_ITEM_ID
FROM '||x.DB_NAME||'.CYCL_FOLD
CONNECT BY PRIOR  CF_ITEM_ID = CF_FATHER_ID 
START WITH CF_ITEM_NAME = ''Papelera'')




';
end loop;


for x in (select DB_NAME, PROJECT_NAME, DESCRIPTION from alm_siteadmin_db_12.projects where domain_name in ('PROYECTOS') and PR_IS_ACTIVE = 'Y') loop
execute immediate  'insert into ALM_REPORT.AUTOMATIZADOS_EXCEL
SELECT
DISTINCT 
'''||x.PROJECT_NAME||'''  as esquema,
to_date(substr(T.TS_VTS,0,10),''yyyy-mm-dd'') as fecha_modificacion,
'''||x.PROJECT_NAME||''' || ''.''|| T.TS_TEST_ID ,
T.TS_TYPE "TIPO CASO",
''TRADICIONALES'' as dominio,
''FECHA MODIFICACION'' as tipo_fecha,
T.TS_VC_VERSION_NUMBER

FROM
 '||x.DB_NAME||'.TEST T

WHERE

T.TS_SUBJECT NOT IN 
(SELECT
AL_ITEM_ID
FROM '||x.DB_NAME||'.ALL_LISTS
CONNECT BY PRIOR AL_ITEM_ID = AL_FATHER_ID
START WITH AL_DESCRIPTION = ''Papelera'')




';
end loop;



------------------------------------------------------------------------------------------



for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME from alm_siteadmin_db_12.projects where DOMAIN_NAME = 'QA') loop

execute immediate  'insert into ALM_REPORT.AUTOMATIZADOS_EXCEL
SELECT
DISTINCT 
''Nueva Internet''  as esquema,
T.TS_CREATION_DATE as fecha_creacion,
'''||x.PROJECT_NAME||''' || ''.''|| T.TS_TEST_ID ,
T.TS_TYPE "TIPO CASO",
''AGILES'' as dominio,
''FECHA CREACION'' as tipo_fecha,
T.TS_VC_VERSION_NUMBER

FROM '||x.DB_NAME||'.TEST T 

WHERE 

T.TS_SUBJECT IN 
(SELECT
AL_ITEM_ID
FROM '||x.DB_NAME||'.ALL_LISTS
CONNECT BY PRIOR AL_ITEM_ID = AL_FATHER_ID
START WITH AL_DESCRIPTION = ''Nueva Internet'') OR

T.TS_SUBJECT IN 
(SELECT
AL_ITEM_ID
FROM '||x.DB_NAME||'.ALL_LISTS
CONNECT BY PRIOR AL_ITEM_ID = AL_FATHER_ID
START WITH AL_DESCRIPTION = ''Nva_ Internet'') 



UNION ALL

SELECT
DISTINCT 
''Plataformas''  as esquema,
T.TS_CREATION_DATE  as fecha_creacion,
'''||x.PROJECT_NAME||''' || ''.''|| T.TS_TEST_ID ,
T.TS_TYPE "TIPO CASO",
''AGILES'' as dominio,
''FECHA CREACION'' as tipo_fecha,
T.TS_VC_VERSION_NUMBER


FROM '||x.DB_NAME||'.TEST T

WHERE
T.TS_SUBJECT  IN 
(SELECT
AL_ITEM_ID
FROM '||x.DB_NAME||'.ALL_LISTS
CONNECT BY PRIOR AL_ITEM_ID = AL_FATHER_ID
START WITH AL_DESCRIPTION = ''Plataformas'')



';


end loop;




for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME from alm_siteadmin_db_12.projects where DOMAIN_NAME = 'QA') loop

execute immediate  'insert into ALM_REPORT.AUTOMATIZADOS_EXCEL
SELECT
DISTINCT 
''Nueva Internet''  as esquema,
TC.TC_EXEC_DATE as fecha_ejecucion,
'''||x.PROJECT_NAME||''' || ''.''|| T.TS_TEST_ID  ,
T.TS_TYPE "TIPO CASO",
''AGILES'' as dominio,
''FECHA EJECUCION'' as tipo_fecha,
T.TS_VC_VERSION_NUMBER


FROM  '||x.db_name||'.TEST T 
LEFT JOIN '||x.db_name||'.TESTCYCL TC ON TC.TC_TEST_ID = T.TS_TEST_ID

WHERE 

T.TS_SUBJECT IN 
(SELECT
AL_ITEM_ID
FROM '||x.DB_NAME||'.ALL_LISTS
CONNECT BY PRIOR AL_ITEM_ID = AL_FATHER_ID
START WITH AL_DESCRIPTION = ''Nueva Internet'') 

OR

T.TS_SUBJECT IN 
(SELECT
AL_ITEM_ID
FROM '||x.DB_NAME||'.ALL_LISTS
CONNECT BY PRIOR AL_ITEM_ID = AL_FATHER_ID
START WITH AL_DESCRIPTION = ''Nva_ Internet'') 



UNION ALL

SELECT
DISTINCT 
''Plataformas''  as esquema,
TC.TC_EXEC_DATE as fecha_ejecucion,
'''||x.PROJECT_NAME||''' || ''.''|| T.TS_TEST_ID  ,
T.TS_TYPE "TIPO CASO",
''AGILES'' as dominio,
''FECHA EJECUCION'' as tipo_fecha,
T.TS_VC_VERSION_NUMBER


FROM  '||x.db_name||'.TEST T 
LEFT JOIN '||x.db_name||'.TESTCYCL TC ON TC.TC_TEST_ID = T.TS_TEST_ID


WHERE
T.TS_SUBJECT IN 
(SELECT
AL_ITEM_ID
FROM '||x.DB_NAME||'.ALL_LISTS
CONNECT BY PRIOR AL_ITEM_ID = AL_FATHER_ID
START WITH AL_DESCRIPTION = ''Plataformas'')

';


end loop;


for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME from alm_siteadmin_db_12.projects where DOMAIN_NAME = 'QA') loop

execute immediate  'insert into ALM_REPORT.AUTOMATIZADOS_EXCEL
SELECT
DISTINCT 
''Nueva Internet''  as esquema,
to_date(substr(T.TS_VTS,0,10),''yyyy-mm-dd'') as fecha_modificacion,
'''||x.PROJECT_NAME||''' || ''.''|| T.TS_TEST_ID ,
T.TS_TYPE "TIPO CASO",
''AGILES'' as dominio,
''FECHA MODIFICACION'' as tipo_fecha,
T.TS_VC_VERSION_NUMBER


FROM  '||x.DB_NAME||'.TEST T 

WHERE

T.TS_SUBJECT IN 
(SELECT
AL_ITEM_ID
FROM '||x.DB_NAME||'.ALL_LISTS
CONNECT BY PRIOR AL_ITEM_ID = AL_FATHER_ID
START WITH AL_DESCRIPTION = ''Nueva Internet'') 

OR

T.TS_SUBJECT IN 
(SELECT
AL_ITEM_ID
FROM '||x.DB_NAME||'.ALL_LISTS
CONNECT BY PRIOR AL_ITEM_ID = AL_FATHER_ID
START WITH AL_DESCRIPTION = ''Nva_ Internet'') 


UNION ALL

SELECT
DISTINCT 
''Plataformas''  as esquema,
to_date(substr(T.TS_VTS,0,10),''yyyy-mm-dd'') as fecha_modificacion,
'''||x.PROJECT_NAME||''' || ''.''|| T.TS_TEST_ID ,
T.TS_TYPE "TIPO CASO",
''AGILES'' as dominio,
''FECHA MODIFICACION'' as tipo_fecha,
T.TS_VC_VERSION_NUMBER


FROM '||x.DB_NAME||'.TEST T 

WHERE
T.TS_SUBJECT  IN 
(SELECT
AL_ITEM_ID
FROM '||x.DB_NAME||'.ALL_LISTS
CONNECT BY PRIOR AL_ITEM_ID = AL_FATHER_ID
START WITH AL_DESCRIPTION = ''Plataformas'')

';


end loop;




END;

/
