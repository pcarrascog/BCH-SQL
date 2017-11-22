--------------------------------------------------------
--  DDL for Procedure cargarAutomatCreaYMod
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ALM_REPORT"."cargarAutomatCreaYMod" AS
BEGIN
execute immediate 'TRUNCATE TABLE ALM_REPORT.CASOS_AUTOMATICOS_CRE_MAN';

for x in (select DB_NAME, PROJECT_NAME, DESCRIPTION from alm_siteadmin_db_12.projects where domain_name in ('PROYECTOS') and PR_IS_ACTIVE = 'Y') loop
execute immediate  'insert into ALM_REPORT.CASOS_AUTOMATICOS_CRE_MAN
SELECT
DISTINCT 
'''||x.PROJECT_NAME||'''  as esquema,
R.REL_USER_04 AS JPQA,
T.TS_CREATION_DATE as fecha_creacion,
'''||x.PROJECT_NAME||''' || ''.''|| T.TS_TEST_ID ,
T.TS_TYPE "TIPO CASO",
''TRADICIONALES'' as dominio,
''FECHA CREACION'' as tipo_fecha,
null

FROM
'||x.DB_NAME||'.RELEASES R 
LEFT JOIN '||x.DB_NAME||'.REQ_RELEASES RQRL ON RQRL.RQRL_RELEASE_ID = R.REL_ID
LEFT JOIN '||x.DB_NAME||'.REQ RQ ON RQ.RQ_REQ_ID = RQRL.RQRL_REQ_ID 
LEFT JOIN '||x.DB_NAME||'.REQ_COVER RC ON RC.RC_REQ_ID = RQ.RQ_REQ_ID
LEFT JOIN '||x.DB_NAME||'.TEST T ON T.TS_TEST_ID = RC.RC_ENTITY_ID AND RC.RC_ENTITY_TYPE = ''TEST''



WHERE
R.REL_NAME != ''Prueba''

AND T.TS_SUBJECT NOT IN 
(SELECT
AL_ITEM_ID
FROM '||x.DB_NAME||'.ALL_LISTS
CONNECT BY PRIOR AL_ITEM_ID = AL_FATHER_ID
START WITH AL_DESCRIPTION = ''Papelera'')




';
end loop;

for x in (select DB_NAME, PROJECT_NAME, DESCRIPTION from alm_siteadmin_db_12.projects where domain_name in ('PROYECTOS') and PR_IS_ACTIVE = 'Y' ) loop
execute immediate  'insert into ALM_REPORT.CASOS_AUTOMATICOS_CRE_MAN
SELECT
DISTINCT 
'''||x.PROJECT_NAME||'''  as esquema,
R.REL_USER_04 AS JPQA,
TC.TC_EXEC_DATE as fecha_ejecucion,
'''||x.PROJECT_NAME||''' || ''.''|| TC.TC_TESTCYCL_ID  ,
T.TS_TYPE "TIPO CASO",
''TRADICIONALES'' as dominio,
''FECHA EJECUCION'' as tipo_fecha,
null

FROM
'||x.DB_NAME||'.RELEASES R 
LEFT JOIN '||x.DB_NAME||'.RELEASE_CYCLES RC ON RC.RCYC_PARENT_ID = R.REL_ID
LEFT JOIN '||x.DB_NAME||'.TESTCYCL TC ON TC.TC_ASSIGN_RCYC = RC.RCYC_ID 
LEFT JOIN '||x.DB_NAME||'.TEST T ON T.TS_TEST_ID = TC.TC_TEST_ID
LEFT JOIN '||x.DB_NAME||'.CYCLE C ON C.CY_CYCLE_ID = TC.TC_CYCLE_ID
LEFT JOIN '||x.DB_NAME||'.CYCL_FOLD CF ON CF.CF_ITEM_ID = C.CY_FOLDER_ID


WHERE

R.REL_NAME != ''Prueba''

AND

C.CY_FOLDER_ID NOT IN 
(SELECT
CF_ITEM_ID
FROM '||x.DB_NAME||'.CYCL_FOLD
CONNECT BY PRIOR  CF_ITEM_ID = CF_FATHER_ID 
START WITH CF_ITEM_NAME = ''Papelera'')




';
end loop;


for x in (select DB_NAME, PROJECT_NAME, DESCRIPTION from alm_siteadmin_db_12.projects where domain_name in ('PROYECTOS') and PR_IS_ACTIVE = 'Y') loop
execute immediate  'insert into ALM_REPORT.CASOS_AUTOMATICOS_CRE_MAN
SELECT
DISTINCT 
'''||x.PROJECT_NAME||'''  as esquema,
R.REL_USER_04 AS JPQA,
to_date(substr(T.TS_VTS,0,10),''yyyy-mm-dd'') as fecha_modificacion,
'''||x.PROJECT_NAME||''' || ''.''|| T.TS_TEST_ID ,
T.TS_TYPE "TIPO CASO",
''TRADICIONALES'' as dominio,
''FECHA MODIFICACION'' as tipo_fecha,
null

FROM
'||x.DB_NAME||'.RELEASES R 
LEFT JOIN '||x.DB_NAME||'.REQ_RELEASES RQRL ON RQRL.RQRL_RELEASE_ID = R.REL_ID
LEFT JOIN '||x.DB_NAME||'.REQ RQ ON RQ.RQ_REQ_ID = RQRL.RQRL_REQ_ID 
LEFT JOIN '||x.DB_NAME||'.REQ_COVER RC ON RC.RC_REQ_ID = RQ.RQ_REQ_ID
LEFT JOIN '||x.DB_NAME||'.TEST T ON T.TS_TEST_ID = RC.RC_ENTITY_ID AND RC.RC_ENTITY_TYPE = ''TEST''

WHERE
R.REL_NAME != ''Prueba''

AND T.TS_SUBJECT NOT IN 
(SELECT
AL_ITEM_ID
FROM '||x.DB_NAME||'.ALL_LISTS
CONNECT BY PRIOR AL_ITEM_ID = AL_FATHER_ID
START WITH AL_DESCRIPTION = ''Papelera'')




';
end loop;

-----------------------------------------------------------------------------------



for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME from alm_siteadmin_db_12.projects where DOMAIN_NAME = 'QA') loop

execute immediate  'insert into ALM_REPORT.CASOS_AUTOMATICOS_CRE_MAN
SELECT
DISTINCT 
''Nueva Internet''  as esquema,
R.REL_USER_05 AS JPQA,
T.TS_CREATION_DATE as fecha_creacion,
'''||x.PROJECT_NAME||''' || ''.''|| T.TS_TEST_ID ,
T.TS_TYPE "TIPO CASO",
''AGILES'' as dominio,
''FECHA CREACION'' as tipo_fecha,
null


FROM '||x.db_name||'.RELEASE_FOLDERS RF
LEFT JOIN '||x.db_name||'.RELEASES R ON R.REL_PARENT_ID = RF.RF_ID
LEFT JOIN '||x.DB_NAME||'.REQ_RELEASES RQRL ON RQRL.RQRL_RELEASE_ID = R.REL_ID
LEFT JOIN '||x.DB_NAME||'.REQ RQ ON RQ.RQ_REQ_ID = RQRL.RQRL_REQ_ID 
LEFT JOIN '||x.DB_NAME||'.REQ_COVER RC ON RC.RC_REQ_ID = RQ.RQ_REQ_ID
LEFT JOIN '||x.DB_NAME||'.TEST T ON T.TS_TEST_ID = RC.RC_ENTITY_ID AND RC.RC_ENTITY_TYPE = ''TEST''

WHERE R.REL_NAME != '' ''

AND T.TS_SUBJECT NOT IN 
(SELECT
AL_ITEM_ID
FROM '||x.DB_NAME||'.ALL_LISTS
CONNECT BY PRIOR AL_ITEM_ID = AL_FATHER_ID
START WITH AL_DESCRIPTION = ''Papelera'')





START WITH RF.RF_ID = 105
CONNECT BY PRIOR RF.RF_ID = RF_PARENT_ID


UNION ALL

SELECT
DISTINCT 
''Plataformas''  as esquema,
R.REL_USER_05 AS JPQA,
T.TS_CREATION_DATE  as fecha_creacion,
'''||x.PROJECT_NAME||''' || ''.''|| T.TS_TEST_ID ,
T.TS_TYPE "TIPO CASO",
''AGILES'' as dominio,
''FECHA CREACION'' as tipo_fecha,
null


FROM '||x.db_name||'.RELEASE_FOLDERS RF
LEFT JOIN '||x.db_name||'.RELEASES R ON R.REL_PARENT_ID = RF.RF_ID
LEFT JOIN '||x.DB_NAME||'.REQ_RELEASES RQRL ON RQRL.RQRL_RELEASE_ID = R.REL_ID
LEFT JOIN '||x.DB_NAME||'.REQ RQ ON RQ.RQ_REQ_ID = RQRL.RQRL_REQ_ID 
LEFT JOIN '||x.DB_NAME||'.REQ_COVER RC ON RC.RC_REQ_ID = RQ.RQ_REQ_ID
LEFT JOIN '||x.DB_NAME||'.TEST T ON T.TS_TEST_ID = RC.RC_ENTITY_ID AND RC.RC_ENTITY_TYPE = ''TEST''


WHERE R.REL_NAME != '' ''

AND T.TS_SUBJECT NOT IN 
(SELECT
AL_ITEM_ID
FROM '||x.DB_NAME||'.ALL_LISTS
CONNECT BY PRIOR AL_ITEM_ID = AL_FATHER_ID
START WITH AL_DESCRIPTION = ''Papelera'')



START WITH RF.RF_ID = 150
CONNECT BY PRIOR RF.RF_ID = RF_PARENT_ID

';


end loop;
for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME from alm_siteadmin_db_12.projects where DOMAIN_NAME = 'QA') loop

execute immediate  'insert into ALM_REPORT.CASOS_AUTOMATICOS_CRE_MAN
SELECT
DISTINCT 
''Nueva Internet''  as esquema,
R.REL_USER_05 AS JPQA,
TC.TC_EXEC_DATE as fecha_ejecucion,
'''||x.PROJECT_NAME||''' || ''.''|| TC.TC_TESTCYCL_ID  ,
T.TS_TYPE "TIPO CASO",
''AGILES'' as dominio,
''FECHA EJECUCION'' as tipo_fecha,
null


FROM '||x.db_name||'.RELEASE_FOLDERS RF
LEFT JOIN '||x.db_name||'.RELEASES R ON R.REL_PARENT_ID = RF.RF_ID
LEFT JOIN '||x.db_name||'.RELEASE_CYCLES RC ON RC.RCYC_PARENT_ID = R.REL_ID
LEFT JOIN '||x.db_name||'.TESTCYCL TC ON TC.TC_ASSIGN_RCYC = RC.RCYC_ID
LEFT JOIN '||x.db_name||'.TEST T ON T.TS_TEST_ID = TC.TC_TEST_ID


WHERE R.REL_NAME != '' ''

AND T.TS_SUBJECT NOT IN 
(SELECT
AL_ITEM_ID
FROM '||x.DB_NAME||'.ALL_LISTS
CONNECT BY PRIOR AL_ITEM_ID = AL_FATHER_ID
START WITH AL_DESCRIPTION = ''Papelera'')



START WITH RF.RF_ID = 105
CONNECT BY PRIOR RF.RF_ID = RF_PARENT_ID


UNION ALL

SELECT
DISTINCT 
''Plataformas''  as esquema,
R.REL_USER_05 AS JPQA,
TC.TC_EXEC_DATE as fecha_ejecucion,
'''||x.PROJECT_NAME||''' || ''.''|| TC.TC_TESTCYCL_ID  ,
T.TS_TYPE "TIPO CASO",
''AGILES'' as dominio,
''FECHA EJECUCION'' as tipo_fecha,
null


FROM '||x.db_name||'.RELEASE_FOLDERS RF
LEFT JOIN '||x.db_name||'.RELEASES R ON R.REL_PARENT_ID = RF.RF_ID
LEFT JOIN '||x.db_name||'.RELEASE_CYCLES RC ON RC.RCYC_PARENT_ID = R.REL_ID
LEFT JOIN '||x.db_name||'.TESTCYCL TC ON TC.TC_ASSIGN_RCYC = RC.RCYC_ID
LEFT JOIN '||x.db_name||'.TEST T ON T.TS_TEST_ID = TC.TC_TEST_ID


WHERE R.REL_NAME != '' ''

AND T.TS_SUBJECT NOT IN 
(SELECT
AL_ITEM_ID
FROM '||x.DB_NAME||'.ALL_LISTS
CONNECT BY PRIOR AL_ITEM_ID = AL_FATHER_ID
START WITH AL_DESCRIPTION = ''Papelera'')




START WITH RF.RF_ID = 150
CONNECT BY PRIOR RF.RF_ID = RF_PARENT_ID

';


end loop;


for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME from alm_siteadmin_db_12.projects where DOMAIN_NAME = 'QA') loop

execute immediate  'insert into ALM_REPORT.CASOS_AUTOMATICOS_CRE_MAN
SELECT
DISTINCT 
''Nueva Internet''  as esquema,
R.REL_USER_05 AS JPQA,
to_date(substr(T.TS_VTS,0,10),''yyyy-mm-dd'') as fecha_modificacion,
'''||x.PROJECT_NAME||''' || ''.''|| T.TS_TEST_ID ,
T.TS_TYPE "TIPO CASO",
''AGILES'' as dominio,
''FECHA MODIFICACION'' as tipo_fecha,
null


FROM '||x.db_name||'.RELEASE_FOLDERS RF
LEFT JOIN '||x.db_name||'.RELEASES R ON R.REL_PARENT_ID = RF.RF_ID
LEFT JOIN '||x.DB_NAME||'.REQ_RELEASES RQRL ON RQRL.RQRL_RELEASE_ID = R.REL_ID
LEFT JOIN '||x.DB_NAME||'.REQ RQ ON RQ.RQ_REQ_ID = RQRL.RQRL_REQ_ID 
LEFT JOIN '||x.DB_NAME||'.REQ_COVER RC ON RC.RC_REQ_ID = RQ.RQ_REQ_ID
LEFT JOIN '||x.DB_NAME||'.TEST T ON T.TS_TEST_ID = RC.RC_ENTITY_ID AND RC.RC_ENTITY_TYPE = ''TEST''

WHERE R.REL_NAME != '' ''

AND T.TS_SUBJECT NOT IN 
(SELECT
AL_ITEM_ID
FROM '||x.DB_NAME||'.ALL_LISTS
CONNECT BY PRIOR AL_ITEM_ID = AL_FATHER_ID
START WITH AL_DESCRIPTION = ''Papelera'')



START WITH RF.RF_ID = 105
CONNECT BY PRIOR RF.RF_ID = RF_PARENT_ID


UNION ALL

SELECT
DISTINCT 
''Plataformas''  as esquema,
R.REL_USER_05 AS JPQA,
to_date(substr(T.TS_VTS,0,10),''yyyy-mm-dd'') as fecha_modificacion,
'''||x.PROJECT_NAME||''' || ''.''|| T.TS_TEST_ID ,
T.TS_TYPE "TIPO CASO",
''AGILES'' as dominio,
''FECHA MODIFICACION'' as tipo_fecha,
null


FROM '||x.db_name||'.RELEASE_FOLDERS RF
LEFT JOIN '||x.db_name||'.RELEASES R ON R.REL_PARENT_ID = RF.RF_ID
LEFT JOIN '||x.DB_NAME||'.REQ_RELEASES RQRL ON RQRL.RQRL_RELEASE_ID = R.REL_ID
LEFT JOIN '||x.DB_NAME||'.REQ RQ ON RQ.RQ_REQ_ID = RQRL.RQRL_REQ_ID 
LEFT JOIN '||x.DB_NAME||'.REQ_COVER RC ON RC.RC_REQ_ID = RQ.RQ_REQ_ID
LEFT JOIN '||x.DB_NAME||'.TEST T ON T.TS_TEST_ID = RC.RC_ENTITY_ID AND RC.RC_ENTITY_TYPE = ''TEST''

WHERE R.REL_NAME != '' ''

AND T.TS_SUBJECT NOT IN 
(SELECT
AL_ITEM_ID
FROM '||x.DB_NAME||'.ALL_LISTS
CONNECT BY PRIOR AL_ITEM_ID = AL_FATHER_ID
START WITH AL_DESCRIPTION = ''Papelera'')




START WITH RF.RF_ID = 150
CONNECT BY PRIOR RF.RF_ID = RF_PARENT_ID

';


end loop;



for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME, DESCRIPTION from alm_siteadmin_db_12.projects where DB_NAME = 'continuidad_automatización_db') loop
execute immediate  'insert into ALM_REPORT.CASOS_AUTOMATICOS_CRE_MAN
SELECT
DISTINCT 

null as esquema,
null as jpqa,
T.TS_CREATION_DATE as fecha_creacion,
'''||x.PROJECT_NAME||''' || ''.''|| T.TS_TEST_ID ,
T.TS_TYPE "TIPO CASO",
''AUTOMATIZACION'' as dominio,
''FECHA CREACION'' as tipo_fecha,
NVL(T.TS_USER_01, ''Sin Sistema'') as sistema

FROM
'||x.DB_NAME||'.TEST T

WHERE

T.TS_SUBJECT IN 
(SELECT
AL_ITEM_ID
FROM '||x.DB_NAME||'.ALL_LISTS
CONNECT BY PRIOR AL_ITEM_ID = AL_FATHER_ID
START WITH AL_DESCRIPTION = ''Continuidad'')

--T.TS_SUBJECT NOT IN 
--(SELECT
--AL_ITEM_ID
--FROM '||x.DB_NAME||'.ALL_LISTS
--CONNECT BY PRIOR AL_ITEM_ID = AL_FATHER_ID
--START WITH AL_DESCRIPTION = ''Papelera'')

--AND
--T.TS_SUBJECT NOT IN 
--(SELECT
--AL_ITEM_ID
--FROM '||x.DB_NAME||'.ALL_LISTS
--CONNECT BY PRIOR AL_ITEM_ID = AL_FATHER_ID
--START WITH AL_DESCRIPTION = ''Proyectos'')

';
end loop;

for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME, DESCRIPTION from alm_siteadmin_db_12.projects where DB_NAME = 'continuidad_automatización_db') loop
execute immediate  'insert into ALM_REPORT.CASOS_AUTOMATICOS_CRE_MAN
SELECT
DISTINCT 

null as esquema,
null as jpqa,
to_date(substr(T.TS_VTS,0,10),''yyyy-mm-dd'') as fecha_modificacion,
'''||x.PROJECT_NAME||''' || ''.''|| T.TS_TEST_ID ,
T.TS_TYPE "TIPO CASO",
''AUTOMATIZACION'' as dominio,
''FECHA MODIFICACION'' as tipo_fecha,
NVL(T.TS_USER_01, ''Sin Sistema'') as sistema

FROM
'||x.DB_NAME||'.TEST T

WHERE

T.TS_SUBJECT IN 
(SELECT
AL_ITEM_ID
FROM '||x.DB_NAME||'.ALL_LISTS
CONNECT BY PRIOR AL_ITEM_ID = AL_FATHER_ID
START WITH AL_DESCRIPTION = ''Continuidad'')

--T.TS_SUBJECT NOT IN 
--(SELECT
--AL_ITEM_ID
--FROM '||x.DB_NAME||'.ALL_LISTS
--CONNECT BY PRIOR AL_ITEM_ID = AL_FATHER_ID
--START WITH AL_DESCRIPTION = ''Papelera'')

--AND
--T.TS_SUBJECT NOT IN 
--(SELECT
--AL_ITEM_ID
--FROM '||x.DB_NAME||'.ALL_LISTS
--CONNECT BY PRIOR AL_ITEM_ID = AL_FATHER_ID
--START WITH AL_DESCRIPTION = ''Proyectos'')


';
end loop;

for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME, DESCRIPTION from alm_siteadmin_db_12.projects where DB_NAME = 'continuidad_automatización_db') loop
execute immediate  'insert into ALM_REPORT.CASOS_AUTOMATICOS_CRE_MAN
SELECT
DISTINCT 

null as esquema,
null as jpqa,
TC.TC_EXEC_DATE as fecha_ejecucion,
'''||x.PROJECT_NAME||''' || ''.''|| TC.TC_TESTCYCL_ID  ,
T.TS_TYPE "TIPO CASO",
''AUTOMATIZACION'' as dominio,
''FECHA EJECUCION'' as tipo_fecha,
NVL(T.TS_USER_01, ''Sin Sistema'') as sistema

FROM
'||x.DB_NAME||'.TEST T
LEFT JOIN '||x.DB_NAME||'.TESTCYCL TC ON TC.TC_TEST_ID = T.TS_TEST_ID
LEFT JOIN '||x.DB_NAME||'.CYCLE C ON C.CY_CYCLE_ID = TC.TC_CYCLE_ID
LEFT JOIN '||x.DB_NAME||'.CYCL_FOLD CF ON CF.CF_ITEM_ID = C.CY_FOLDER_ID


WHERE

T.TS_SUBJECT IN 
(SELECT
AL_ITEM_ID
FROM '||x.DB_NAME||'.ALL_LISTS
CONNECT BY PRIOR AL_ITEM_ID = AL_FATHER_ID
START WITH AL_DESCRIPTION = ''Continuidad'')

--T.TS_SUBJECT NOT IN 
--(SELECT
--AL_ITEM_ID
--FROM '||x.DB_NAME||'.ALL_LISTS
--CONNECT BY PRIOR AL_ITEM_ID = AL_FATHER_ID
--START WITH AL_DESCRIPTION = ''Papelera'')

--AND
--T.TS_SUBJECT NOT IN 
--(SELECT
--AL_ITEM_ID
--FROM '||x.DB_NAME||'.ALL_LISTS
--CONNECT BY PRIOR AL_ITEM_ID = AL_FATHER_ID
--START WITH AL_DESCRIPTION = ''Proyectos'')


';
end loop;


---------------------------------------------CASOS POR PROYECTO EN ESQUEMA AUTMATIZACION--------------------------------------

/*

for x in (select DB_NAME, PROJECT_NAME, DESCRIPTION from alm_siteadmin_db_12.projects where domain_name in ('PROYECTOS')) loop
execute immediate  'insert into ALM_REPORT.CASOS_AUTOMATICOS_CRE_MAN
SELECT
DISTINCT 
'''||x.PROJECT_NAME||'''  as esquema,
R.REL_USER_04 AS JPQA,
T.TS_CREATION_DATE as fecha_creacion,
'''||x.PROJECT_NAME||''' || ''.CONTINUIDAD_AUTOMATIZACIÓN_DB.''|| T.TS_TEST_ID ,
T.TS_TYPE "TIPO CASO",
''TRADICIONALES'' as dominio,
''FECHA CREACION'' as tipo_fecha,
null

FROM
'||x.DB_NAME||'.RELEASES R1
LEFT JOIN CONTINUIDAD_AUTOMATIZACIÓN_DB.RELEASES R ON R.REL_USER_03 = R1.REL_USER_03 AND R1.REL_USER_03 != ''0''
LEFT JOIN CONTINUIDAD_AUTOMATIZACIÓN_DB.RELEASE_CYCLES RC ON RC.RCYC_PARENT_ID = R.REL_ID
LEFT JOIN CONTINUIDAD_AUTOMATIZACIÓN_DB.TESTCYCL TC ON TC.TC_ASSIGN_RCYC = RC.RCYC_ID 
LEFT JOIN CONTINUIDAD_AUTOMATIZACIÓN_DB.TEST T ON T.TS_TEST_ID = TC.TC_TEST_ID
LEFT JOIN CONTINUIDAD_AUTOMATIZACIÓN_DB.RUN RN ON RN.RN_TEST_ID = T.TS_TEST_ID

WHERE
R.REL_NAME != ''Prueba''

AND T.TS_SUBJECT NOT IN 
(SELECT
AL_ITEM_ID
FROM CONTINUIDAD_AUTOMATIZACIÓN_DB.ALL_LISTS
CONNECT BY PRIOR AL_ITEM_ID = AL_FATHER_ID
START WITH AL_DESCRIPTION = ''Papelera'')




';
end loop;

*/



for x in (select DB_NAME, PROJECT_NAME, DESCRIPTION from alm_siteadmin_db_12.projects where domain_name in ('PROYECTOS') and PR_IS_ACTIVE = 'Y') loop
execute immediate  'insert into ALM_REPORT.CASOS_AUTOMATICOS_CRE_MAN
SELECT
DISTINCT 
'''||x.PROJECT_NAME||'''  as esquema,
R.REL_USER_04 AS JPQA,
TC.TC_EXEC_DATE as fecha_ejecucion,
'''||x.PROJECT_NAME||''' || ''.''|| TC.TC_TESTCYCL_ID  ,
T.TS_TYPE "TIPO CASO",
''TRADICIONALES'' as dominio,
''FECHA EJECUCION'' as tipo_fecha,
null


FROM
'||x.DB_NAME||'.RELEASES R1
LEFT JOIN CONTINUIDAD_AUTOMATIZACIÓN_DB.RELEASES R ON R.REL_USER_03 = R1.REL_USER_03 AND R1.REL_USER_03 != ''0''
LEFT JOIN CONTINUIDAD_AUTOMATIZACIÓN_DB.RELEASE_CYCLES RC ON RC.RCYC_PARENT_ID = R.REL_ID
LEFT JOIN CONTINUIDAD_AUTOMATIZACIÓN_DB.TESTCYCL TC ON TC.TC_ASSIGN_RCYC = RC.RCYC_ID 
LEFT JOIN CONTINUIDAD_AUTOMATIZACIÓN_DB.TEST T ON T.TS_TEST_ID = TC.TC_TEST_ID
LEFT JOIN CONTINUIDAD_AUTOMATIZACIÓN_DB.CYCLE C ON C.CY_CYCLE_ID = TC.TC_CYCLE_ID
LEFT JOIN CONTINUIDAD_AUTOMATIZACIÓN_DB.CYCL_FOLD CF ON CF.CF_ITEM_ID = C.CY_FOLDER_ID



WHERE
R.REL_NAME != ''Prueba''

AND T.TS_SUBJECT NOT IN 
(SELECT
AL_ITEM_ID
FROM '||x.DB_NAME||'.ALL_LISTS
CONNECT BY PRIOR AL_ITEM_ID = AL_FATHER_ID
START WITH AL_DESCRIPTION = ''Papelera'')

';
end loop;




for x in (select DB_NAME, PROJECT_NAME, DESCRIPTION from alm_siteadmin_db_12.projects where domain_name in ('PROYECTOS') and PR_IS_ACTIVE = 'Y') loop
execute immediate  'insert into ALM_REPORT.CASOS_AUTOMATICOS_CRE_MAN
SELECT
DISTINCT 
'''||x.PROJECT_NAME||'''  as esquema,
R.REL_USER_04 AS JPQA,
to_date(substr(T.TS_VTS,0,10),''yyyy-mm-dd'') as fecha_modificacion,
T.TS_TEST_ID "CASOS EXISTENTES",
T.TS_TYPE "TIPO CASO",
''TRADICIONALES'' as dominio,
''FECHA MODIFICACION'' as tipo_fecha,
null


FROM
'||x.DB_NAME||'.RELEASES R1
LEFT JOIN CONTINUIDAD_AUTOMATIZACIÓN_DB.RELEASES R ON R.REL_USER_03 = R1.REL_USER_03 AND R1.REL_USER_03 != ''0''
LEFT JOIN '||x.DB_NAME||'.REQ_RELEASES RQRL ON RQRL.RQRL_RELEASE_ID = R.REL_ID
LEFT JOIN '||x.DB_NAME||'.REQ RQ ON RQ.RQ_REQ_ID = RQRL.RQRL_REQ_ID 
LEFT JOIN '||x.DB_NAME||'.REQ_COVER RC ON RC.RC_REQ_ID = RQ.RQ_REQ_ID
LEFT JOIN '||x.DB_NAME||'.TEST T ON T.TS_TEST_ID = RC.RC_ENTITY_ID AND RC.RC_ENTITY_TYPE = ''TEST''

WHERE
R.REL_NAME != ''Prueba''

AND T.TS_SUBJECT NOT IN 
(SELECT
AL_ITEM_ID
FROM CONTINUIDAD_AUTOMATIZACIÓN_DB.ALL_LISTS
CONNECT BY PRIOR AL_ITEM_ID = AL_FATHER_ID
START WITH AL_DESCRIPTION = ''Papelera'')



';
end loop;




end;

/
