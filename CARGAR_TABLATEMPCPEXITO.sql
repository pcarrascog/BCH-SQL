--------------------------------------------------------
--  DDL for Procedure CARGAR_TABLATEMPCPEXITO
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ALM_REPORT"."CARGAR_TABLATEMPCPEXITO" AS 
IDCASO NUMBER;
FECHA_EJE DATE;
HORA_EJE TIMESTAMP;
BEGIN
 execute immediate 'TRUNCATE TABLE ALM_REPORT.TABLATEMPCPEXITO';
 
for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME from alm_siteadmin_db_12.projects where DB_NAME = 'bch_qa_certificación_bch_qa_d') loop
execute immediate  'insert into ALM_REPORT.TABLATEMPCPEXITO 

SELECT
'''||x.DOMAIN_NAME||'''as dominio,
'''||x.PROJECT_NAME||''' as Proyecto,
TS_TEST_ID AS ID_CASO,  
to_date(RN.RN_EXECUTION_DATE,''DD/MM/YYYY''),
--RN.RN_EXECUTION_DATE AS FECHA_EJECUCION,
RN.RN_EXECUTION_TIME AS HORA_EJECUCION,
--to_timestamp(RN.RN_EXECUTION_TIME,''HH24:MI:SS:FF''),
RN.RN_STATUS AS ESTADO_EJECUCION 
--RN.RN_EXECUTION_DATE || '' '' || RN.RN_EXECUTION_TIME 
--to_timestamp(RN.RN_EXECUTION_DATE||'' ''||RN.RN_EXECUTION_TIME,''DD/MM/YYYY HH24:MI:SS:FF'') AS FECHA_HORA_EJECUCION
FROM  '||x.db_name||'.TEST X
LEFT JOIN '||x.db_name||'.TESTCYCL TC ON TC.TC_TEST_ID = TS_TEST_ID
LEFT JOIN '||x.db_name||'.RUN RN ON RN.RN_TESTCYCL_ID = TC.TC_TESTCYCL_ID
INNER JOIN '||x.db_name||'.ALL_LISTS AL ON TS_SUBJECT = AL.AL_ITEM_ID
WHERE 1=1
--AND TS_TEST_ID IN (14163) 
AND(AL.AL_ABSOLUTE_PATH like ''AAAAAPAAA%'')
AND TS_TYPE IN (''SERVICE-TEST'', ''QUICKTEST_TEST'')
AND (RN_RUN_NAME IS NULL OR RN_RUN_NAME NOT LIKE (''%Fast%'')) 
--AND TS_USER_01 = ''BUS''


'; end loop;

for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME  from alm_siteadmin_db_12.projects where DB_NAME = 'qa_qa_db0') loop
execute immediate  'insert into ALM_REPORT.TABLATEMPCPEXITO

SELECT
'''||x.DOMAIN_NAME||'''as dominio,
'''||x.PROJECT_NAME||''' as Proyecto,
TS_TEST_ID AS ID_CASO,  
to_date(RN.RN_EXECUTION_DATE,''DD/MM/YYYY''),
--RN.RN_EXECUTION_DATE AS FECHA_EJECUCION,
RN.RN_EXECUTION_TIME AS HORA_EJECUCION,
--to_timestamp(RN.RN_EXECUTION_TIME,''HH24:MI:SS:FF''),
RN.RN_STATUS AS ESTADO_EJECUCION 
--RN.RN_EXECUTION_DATE || '' '' || RN.RN_EXECUTION_TIME 
--to_timestamp(RN.RN_EXECUTION_DATE||'' ''||RN.RN_EXECUTION_TIME,''DD/MM/YYYY HH24:MI:SS:FF'') AS FECHA_HORA_EJECUCION
FROM  '||x.db_name||'.TEST X
LEFT JOIN '||x.db_name||'.TESTCYCL TC ON TC.TC_TEST_ID = TS_TEST_ID
LEFT JOIN '||x.db_name||'.RUN RN ON RN.RN_TESTCYCL_ID = TC.TC_TESTCYCL_ID
INNER JOIN '||x.db_name||'.ALL_LISTS AL ON TS_SUBJECT = AL.AL_ITEM_ID
WHERE 1=1
--AND TS_TEST_ID IN (14163) 
AND(AL.AL_ABSOLUTE_PATH like ''AAAAAPAAF%'')
AND TS_TYPE IN (''SERVICE-TEST'', ''QUICKTEST_TEST'')
AND (RN_RUN_NAME IS NULL OR RN_RUN_NAME NOT LIKE (''%Fast%'')) 
--AND TS_USER_01 = ''BUS''


'; end loop;

 
END;

/
