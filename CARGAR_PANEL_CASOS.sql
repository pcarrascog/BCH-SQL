--------------------------------------------------------
--  DDL for Procedure CARGAR_PANEL_CASOS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ALM_REPORT"."CARGAR_PANEL_CASOS" AS 
BEGIN

 execute immediate 'TRUNCATE TABLE ALM_REPORT.DATA_PANEL_CASOS';

for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME from alm_siteadmin_db_12.projects where DB_NAME = 'bch_qa_certificación_bch_qa_d') loop
execute immediate  'insert into ALM_REPORT.DATA_PANEL_CASOS  

SELECT T.TS_TEST_ID, T.TS_CREATION_DATE, 
--TO_DATE(TS_USER_TEMPLATE_01, ''YYYY/MM/DD'') AS FECHA_PLANIFICADO, 
CASE WHEN TS_USER_TEMPLATE_02 IS NULL THEN TO_DATE(TS_USER_TEMPLATE_01, ''YYYY/MM/DD'') ELSE TO_DATE(TS_USER_TEMPLATE_02, ''YYYY/MM/DD'') END AS FECHA_PLANIFICADO, 
TO_DATE(TS_USER_TEMPLATE_02, ''YYYY/MM/DD'') AS FECHA_RE_PLANIFICADO, ID_TEST_EXITO,  VALOREXITO,  T.TS_TYPE, T.TS_USER_01 AS SISTEMA, T.TS_RESPONSIBLE AS DISEÑADOR, 
T.TS_NAME AS NOMBRE_TEST, T.TS_STATUS,
TC.TC_EXEC_DATE,
COUNT(DISTINCT(TC_TESTCYCL_ID)) AS TOTAL_INS,
COUNT(DISTINCT(RN_RUN_ID)) AS TOTAL_RUN,
CASE WHEN T.TS_TYPE = ''MANUAL'' THEN COUNT(DISTINCT(T.TS_TEST_ID)) ELSE 0 END AS TOTAL_TEST_MANUAL,
CASE WHEN T.TS_TYPE IN (''QUICKTEST_TEST'', ''SERVICE-TEST'') THEN COUNT(DISTINCT(T.TS_TEST_ID)) ELSE 0 END AS TOTAL_TEST_AUTOMATICO,
MAYORCINCORUNS,
NVL(CUMPLEMAYORCINCORUNS,0) AS CUMPLEMAYORCINCORUNS,
'''||x.DOMAIN_NAME||''' as DOMINIO,
'''||x.PROJECT_NAME||''' as PROYECTO,
''SERVIDOR TSOFT'' as SERVIDOR

FROM  '||x.db_name||'.TEST T
LEFT JOIN '||x.db_name||'.TESTCYCL TC ON TC.TC_TEST_ID = T.TS_TEST_ID
LEFT JOIN '||x.db_name||'.RUN RN ON RN.RN_TESTCYCL_ID = TC.TC_TESTCYCL_ID
INNER JOIN '||x.db_name||'.ALL_LISTS AL ON T.TS_SUBJECT = AL.AL_ITEM_ID

      LEFT JOIN (
      SELECT TS_TEST_ID,
      1 AS CUMPLEMAYORCINCORUNS,
      COUNT(DISTINCT(RN_RUN_ID)) AS MAYORCINCORUNS
      --CASE WHEN COUNT(DISTINCT(RN_RUN_ID)) < 5  THEN ''Casos con menos de 5 ejecuciones'' ELSE ''Casos con 5 o más ejecuciones''  END  AS Valor
      FROM  '||x.db_name||'.TEST 
      LEFT JOIN '||x.db_name||'.TESTCYCL TC ON TC.TC_TEST_ID = TS_TEST_ID
      LEFT JOIN '||x.db_name||'.RUN RN ON RN.RN_TESTCYCL_ID = TC.TC_TESTCYCL_ID
      INNER JOIN '||x.db_name||'.ALL_LISTS AL ON TS_SUBJECT = AL.AL_ITEM_ID
      WHERE 1=1
      --AND TS_TEST_ID IN (32742, 32748, 32745) 
      AND(AL.AL_ABSOLUTE_PATH like ''AAAAAPAAA%'')
      AND TS_TYPE IN (''SERVICE-TEST'', ''QUICKTEST_TEST'', ''MANUAL'')
      AND (RN_RUN_NAME IS NULL OR RN_RUN_NAME NOT LIKE (''%Fast%''))
      --AND TS_USER_01 = ''Siebel CRM''
      --Or (RN_RUN_NAME IS NULL)   
      GROUP BY TS_TEST_ID   
      having count(RN_RUN_ID)>=5
      ) TS ON TS.TS_TEST_ID = T.TS_TEST_ID

      
      /*LEFT JOIN (
      SELECT  1 AS VALOREXITO, ID_CASO AS ID_TEST_EXITO
      FROM  DATA_PANEL_CASOS_EXITO      
      WHERE 1=1
      AND DOMINIO = ''BCH_QA''      
      ) TS2 ON TS2.ID_TEST_EXITO = T.TS_TEST_ID*/
      
      LEFT JOIN (      
      SELECT DISTINCT(TS.TS_TEST_ID) ID_TEST_EXITO, RN_STATUS, RN.RN_EXECUTION_DATE, RN_EXECUTION_TIME, 1 AS VALOREXITO
      FROM '||x.db_name||'.TEST TS
      JOIN '||x.db_name||'.RUN RN ON RN.RN_TEST_ID = TS.TS_TEST_ID
      WHERE RN_EXECUTION_DATE in (SELECT MAX(RN_EXECUTION_DATE) FECHA FROM '||x.db_name||'.TEST TS1
                JOIN '||x.db_name||'.RUN RN1 ON RN1.RN_TEST_ID = TS1.TS_TEST_ID WHERE TS1.TS_TEST_ID = TS.TS_TEST_ID)
                AND RN_EXECUTION_TIME in (SELECT MAX(RN_EXECUTION_TIME) HORA FROM '||x.db_name||'.TEST TS2
                JOIN '||x.db_name||'.RUN RN2 ON RN2.RN_TEST_ID = TS2.TS_TEST_ID WHERE TS2.TS_TEST_ID = TS.TS_TEST_ID AND RN.RN_EXECUTION_DATE = RN_EXECUTION_DATE )
      --AND TS_TEST_ID = ''2742''
      AND RN_STATUS IN ''Passed''      
      ) TS2 ON TS2.ID_TEST_EXITO = T.TS_TEST_ID


WHERE 1=1
--AND T.TS_TEST_ID IN (17110) 
--AND T.TS_USER_01 = ''Siebel CRM''
AND(AL.AL_ABSOLUTE_PATH like ''AAAAAPAAA%'')
AND T.TS_TYPE IN (''SERVICE-TEST'', ''QUICKTEST_TEST'', ''MANUAL'')
AND (RN_RUN_NAME IS NULL OR RN_RUN_NAME NOT LIKE (''%Fast%''))
GROUP BY T.TS_TEST_ID,T.TS_TYPE, T.TS_USER_01, T.TS_RESPONSIBLE, T.TS_NAME, TC.TC_EXEC_DATE, T.TS_STATUS, MAYORCINCORUNS, CUMPLEMAYORCINCORUNS, ID_TEST_EXITO, VALOREXITO,   T.TS_CREATION_DATE, TS_USER_TEMPLATE_01, TS_USER_TEMPLATE_02

';

end loop;



for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME  from alm_siteadmin_db_12.projects where DB_NAME = 'qa_qa_db0') loop
execute immediate  'insert into ALM_REPORT.DATA_PANEL_CASOS

SELECT T.TS_TEST_ID, T.TS_CREATION_DATE, 
--TO_DATE(TS_USER_12, ''YYYY/MM/DD'') AS FECHA_PLANIFICADO, 
CASE WHEN TS_USER_13 IS NULL THEN TO_DATE(TS_USER_12, ''YYYY/MM/DD'') ELSE TO_DATE(TS_USER_13, ''YYYY/MM/DD'') END AS FECHA_PLANIFICADO,
TO_DATE(TS_USER_13, ''YYYY/MM/DD'') AS FECHA_RE_PLANIFICADO, ID_TEST_EXITO,  VALOREXITO,  T.TS_TYPE, T.TS_USER_05 AS SISTEMA, T.TS_RESPONSIBLE AS DISEÑADOR, 
T.TS_NAME AS NOMBRE_TEST, T.TS_STATUS, 
TC.TC_EXEC_DATE,
COUNT(DISTINCT(TC_TESTCYCL_ID)) AS TOTAL_INS,
COUNT(DISTINCT(RN_RUN_ID)) AS TOTAL_RUN,
CASE WHEN T.TS_TYPE = ''MANUAL'' THEN COUNT(DISTINCT(T.TS_TEST_ID)) ELSE 0 END AS TOTAL_TEST_MANUAL,
CASE WHEN T.TS_TYPE IN (''QUICKTEST_TEST'', ''SERVICE-TEST'') THEN COUNT(DISTINCT(T.TS_TEST_ID)) ELSE 0 END AS TOTAL_TEST_AUTOMATICO,
MAYORCINCORUNS,
NVL(CUMPLEMAYORCINCORUNS,0) AS CUMPLEMAYORCINCORUNS,
'''||x.DOMAIN_NAME||''' as DOMINIO,
'''||x.PROJECT_NAME||''' as PROYECTO,
''SERVIDOR TSOFT'' as SERVIDOR

FROM  '||x.db_name||'.TEST T
LEFT JOIN '||x.db_name||'.TESTCYCL TC ON TC.TC_TEST_ID = T.TS_TEST_ID
LEFT JOIN '||x.db_name||'.RUN RN ON RN.RN_TESTCYCL_ID = TC.TC_TESTCYCL_ID
INNER JOIN '||x.db_name||'.ALL_LISTS AL ON T.TS_SUBJECT = AL.AL_ITEM_ID

      LEFT JOIN (
       SELECT TS_TEST_ID,
      1 AS CUMPLEMAYORCINCORUNS,
      COUNT(DISTINCT(RN_RUN_ID)) AS MAYORCINCORUNS
      --CASE WHEN COUNT(DISTINCT(RN_RUN_ID)) < 5  THEN ''Casos con menos de 5 ejecuciones'' ELSE ''Casos con 5 o más ejecuciones''  END  AS Valor
      FROM  '||x.db_name||'.TEST 
      LEFT JOIN '||x.db_name||'.TESTCYCL TC ON TC.TC_TEST_ID = TS_TEST_ID
      LEFT JOIN '||x.db_name||'.RUN RN ON RN.RN_TESTCYCL_ID = TC.TC_TESTCYCL_ID
      INNER JOIN '||x.db_name||'.ALL_LISTS AL ON TS_SUBJECT = AL.AL_ITEM_ID
      WHERE 1=1
      --AND TS_TEST_ID IN (32742, 32748, 32745) 
      AND(AL.AL_ABSOLUTE_PATH like ''AAAAAPAAA%'')
      AND TS_TYPE IN (''SERVICE-TEST'', ''QUICKTEST_TEST'', ''MANUAL'')
      AND (RN_RUN_NAME IS NULL OR RN_RUN_NAME NOT LIKE (''%Fast%''))  
      GROUP BY TS_TEST_ID   
      having count(RN_RUN_ID)>=5     
      ) TS ON TS.TS_TEST_ID = T.TS_TEST_ID
      
           
      /*LEFT JOIN (
      SELECT  1 AS VALOREXITO, ID_CASO AS ID_TEST_EXITO
      FROM  DATA_PANEL_CASOS_EXITO      
      WHERE 1=1
      AND DOMINIO = ''QA''      
      ) TS2 ON TS2.ID_TEST_EXITO = T.TS_TEST_ID*/
      
      LEFT JOIN (      
      SELECT DISTINCT(TS.TS_TEST_ID) ID_TEST_EXITO, RN_STATUS, RN.RN_EXECUTION_DATE, RN_EXECUTION_TIME, 1 AS VALOREXITO
      FROM '||x.db_name||'.TEST TS
      JOIN '||x.db_name||'.RUN RN ON RN.RN_TEST_ID = TS.TS_TEST_ID
      WHERE RN_EXECUTION_DATE in (SELECT MAX(RN_EXECUTION_DATE) FECHA FROM '||x.db_name||'.TEST TS1
                JOIN '||x.db_name||'.RUN RN1 ON RN1.RN_TEST_ID = TS1.TS_TEST_ID WHERE TS1.TS_TEST_ID = TS.TS_TEST_ID)
                AND RN_EXECUTION_TIME in (SELECT MAX(RN_EXECUTION_TIME) HORA FROM '||x.db_name||'.TEST TS2
                JOIN '||x.db_name||'.RUN RN2 ON RN2.RN_TEST_ID = TS2.TS_TEST_ID WHERE TS2.TS_TEST_ID = TS.TS_TEST_ID AND RN.RN_EXECUTION_DATE = RN_EXECUTION_DATE )
      --AND TS_TEST_ID = ''2742''
      AND RN_STATUS IN ''Passed''      
      ) TS2 ON TS2.ID_TEST_EXITO = T.TS_TEST_ID
      
            
WHERE 1=1--AP_NEW_VALUE IN (''Desarrollo'',''Pruebas Internas'',''En Validación'', ''Listo para Ejecutar'')

--AND T.TS_TEST_ID IN (14236) 
AND(AL.AL_ABSOLUTE_PATH like ''AAAAAPAAA%'')
AND T.TS_TYPE IN (''SERVICE-TEST'', ''QUICKTEST_TEST'', ''MANUAL'')
AND (RN_RUN_NAME IS NULL OR RN_RUN_NAME NOT LIKE (''%Fast%''))
GROUP BY T.TS_TEST_ID,T.TS_TYPE, T.TS_USER_05, T.TS_RESPONSIBLE, T.TS_NAME, TC.TC_EXEC_DATE, T.TS_STATUS, MAYORCINCORUNS, CUMPLEMAYORCINCORUNS, ID_TEST_EXITO, VALOREXITO,  T.TS_CREATION_DATE, TS_USER_12, TS_USER_13


'; end loop;

execute immediate 'insert into ALM_REPORT.DATA_PANEL_CASOS
SELECT 0 AS "ID_CASO", ''01/01/01'' AS "FECHA_CREACION_CASO", DIAS AS "FECHA_PLANIFICADO", ''01/01/01'' AS "FECHA_RE_PLANIFICADO", 0 AS "ID_TEST_EXITO", 0 AS "VALOR_EXITO", ''-'' AS "TIPO_CASO", ''CALENDARIO'' AS "SISTEMA", ''-'' AS "DISEÑADOR", ''-'' AS "NOMBRE_CASO", ''-'' AS "ESTADO_CASO", ''01/01/01'' AS "FECHA_INSTANCIA", 0 AS "TOTAL_INSTANCIA", 0 AS "TOTAL_RUN", 0 AS "TOTAL_CASO_MANUAL", 0 AS "TOTAL_CASO_AUTOMATICO", 0 AS "MAYOR_CINCO_RUNS", ''0'' AS "CUMPLE_MAYOR_CINCO_RUNS", ''CALENDARIO'' AS "DOMINIO", ''-'' AS "PROYECTO", ''SERVIDOR BCH'' as SERVIDOR 
FROM AÑOS A 


--WHERE NOT EXISTS 
  --(SELECT FECHA_PLANIFICADO FROM DATA_PANEL_CASOS DPC WHERE A.DIAS = DPC.FECHA_PLANIFICADO
  --AND TIPO_CASO IN (''SERVICE-TEST'', ''QUICKTEST_TEST''))
';

execute immediate 'insert into ALM_REPORT.DATA_PANEL_CASOS
SELECT 0 AS "ID_CASO", ''01/01/01'' AS "FECHA_CREACION_CASO", DIAS AS "FECHA_PLANIFICADO", ''01/01/01'' AS "FECHA_RE_PLANIFICADO", 0 AS "ID_TEST_EXITO", 0 AS "VALOR_EXITO", ''-'' AS "TIPO_CASO", ''CALENDARIO'' AS "SISTEMA", ''-'' AS "DISEÑADOR", ''-'' AS "NOMBRE_CASO", ''-'' AS "ESTADO_CASO", ''01/01/01'' AS "FECHA_INSTANCIA", 0 AS "TOTAL_INSTANCIA", 0 AS "TOTAL_RUN", 0 AS "TOTAL_CASO_MANUAL", 0 AS "TOTAL_CASO_AUTOMATICO", 0 AS "MAYOR_CINCO_RUNS", ''0'' AS "CUMPLE_MAYOR_CINCO_RUNS", ''CALENDARIO'' AS "DOMINIO", ''-'' AS "PROYECTO", ''SERVIDOR TSOFT'' as SERVIDOR 
FROM AÑOS A 


--WHERE NOT EXISTS 
  --(SELECT FECHA_PLANIFICADO FROM DATA_PANEL_CASOS DPC WHERE A.DIAS = DPC.FECHA_PLANIFICADO
  --AND TIPO_CASO IN (''SERVICE-TEST'', ''QUICKTEST_TEST''))
';



execute immediate  'insert into ALM_REPORT.DATA_PANEL_CASOS 
select "ID_TEST",	"FECHA_CREACION_CASO",	"FECHA_PLANIFICADO",	"FECHA_RE_PLANIFICADO",	"ID_TEST_EXITO",	"VALOR_EXITO",	"TIPO_CASO",	"SISTEMA",	"DISEÑADOR",	"NOMBRE_CASO",	"ESTADO_CASO",	"FECHA_INSTANCIA",	"TOTAL_INSTANCIA",	"TOTAL_RUN",	"TOTAL_CASO_MANUAL",	"TOTAL_CASO_AUTOMATICO",	"MAYOR_CINCO_RUNS",	"CUMPLE_MAYOR_CINCO_RUNS",	"DOMINIO",	"PROYECTO",	"SERVIDOR" from DATA_PANEL_CASOS@SERVER_BCH
'; 
  
END;

/
