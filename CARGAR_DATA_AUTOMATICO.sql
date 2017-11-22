--------------------------------------------------------
--  DDL for Procedure CARGAR_DATA_AUTOMATICO
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ALM_REPORT"."CARGAR_DATA_AUTOMATICO" AS 
BEGIN

 execute immediate 'TRUNCATE TABLE ALM_REPORT.DATA_DSH_AUTOMATICO';

for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME from alm_siteadmin_db_12.projects where DB_NAME = 'bch_qa_certificación_bch_qa_d') loop
execute immediate  'insert into ALM_REPORT.DATA_DSH_AUTOMATICO  


SELECT T.TS_TEST_ID,T.TS_TYPE, TS_USER_01 AS SISTEMA, TS_RESPONSIBLE AS DISEÑADOR, COUNT (distinct AP_NEW_VALUE) TIPO_TOTAL,1 AS TOTAL, 
FECHA, ''CREACIONES'' AS TIPO, USUARIO,
'''||x.PROJECT_NAME||''' as PROYECTO,
'''||x.DOMAIN_NAME||''' as DOMINIO,
T.TS_NAME AS NOMBRE_TEST,
''SERVIDOR TSOFT'' as SERVIDOR,
T.TS_STATUS AS ESTADO_CASO

FROM  '||x.db_name||'.TEST T
INNER JOIN '||x.db_name||'.AUDIT_LOG AU ON AU.AU_ENTITY_ID = T.TS_TEST_ID
INNER JOIN '||x.db_name||'.AUDIT_PROPERTIES AP ON AP.AP_ACTION_ID = AU.AU_ACTION_ID
INNER JOIN '||x.db_name||'.ALL_LISTS AL ON T.TS_SUBJECT = AL.AL_ITEM_ID

  LEFT JOIN (
      
      SELECT DISTINCT TS_TEST_ID, MIN(AU_TIME)  FECHA
      FROM  '||x.db_name||'.TEST 
      INNER JOIN '||x.db_name||'.AUDIT_LOG AU ON AU.AU_ENTITY_ID = TS_TEST_ID
      INNER JOIN '||x.db_name||'.AUDIT_PROPERTIES AP ON AP.AP_ACTION_ID = AU.AU_ACTION_ID
      WHERE AP_NEW_VALUE IN (''Listo para Ejecutar'')
      AND AU.AU_ENTITY_TYPE = ''TEST''
      --AND TS_TYPE IN (''SERVICE-TEST'', ''QUICKTEST_TEST'')
      --AND TS_TEST_ID IN (14236) 
      GROUP BY TS_TEST_ID
      
      ) TAB ON TAB.TS_TEST_ID = T.TS_TEST_ID
      
      LEFT JOIN (
      
      SELECT DISTINCT A.TS_TEST_ID, AU_USER USUARIO
      FROM  '||x.db_name||'.TEST A 
      INNER JOIN '||x.db_name||'.AUDIT_LOG AU ON AU.AU_ENTITY_ID = A.TS_TEST_ID
      INNER JOIN '||x.db_name||'.AUDIT_PROPERTIES AP ON AP.AP_ACTION_ID = AU.AU_ACTION_ID
      WHERE AP_NEW_VALUE IN (''Listo para Ejecutar'')
      AND AU.AU_ENTITY_TYPE = ''TEST''
      AND AU_TIME IN 
                        (SELECT MIN(AU_TIME)
                        FROM  '||x.db_name||'.TEST B
                        INNER JOIN '||x.db_name||'.AUDIT_LOG AU ON AU.AU_ENTITY_ID = TS_TEST_ID
                        INNER JOIN '||x.db_name||'.AUDIT_PROPERTIES AP ON AP.AP_ACTION_ID = AU.AU_ACTION_ID
                        WHERE AP_NEW_VALUE IN (''Listo para Ejecutar'')
                        AND AU.AU_ENTITY_TYPE = ''TEST''
                        AND A.TS_TEST_ID = B.TS_TEST_ID
                        )                         
      --AND A.TS_TEST_ID = ''17106''      
      GROUP BY A.TS_TEST_ID,  AU_USER
      
      ) TAB ON TAB.TS_TEST_ID = T.TS_TEST_ID     
      
      

WHERE AP_NEW_VALUE IN (''Desarrollo'',''Pruebas Internas'',''En Validación'', ''Listo para Ejecutar'')
AND AU.AU_ENTITY_TYPE = ''TEST''
--AND T.TS_TEST_ID IN (14236) 
--AND(AL.AL_ABSOLUTE_PATH not like ''AAAAAPAAH%''  AND AL.AL_ABSOLUTE_PATH not like ''AAAAAPAAF%'') 
AND(AL.AL_ABSOLUTE_PATH not like ''AAAAAPAAH%'')
--AND T.TS_TYPE IN (''SERVICE-TEST'', ''QUICKTEST_TEST'')
GROUP BY T.TS_TEST_ID,T.TS_TYPE, FECHA, TS_USER_01, TS_RESPONSIBLE, USUARIO, T.TS_NAME, T.TS_STATUS
HAVING COUNT (distinct AP_NEW_VALUE) >= 4

UNION ALL -- COMIENZAN LAS MANTENCIONES

SELECT T.TS_TEST_ID, T.TS_TYPE, TS_USER_01 AS SISTEMA, TS_RESPONSIBLE AS DISEÑADOR,  Count(distinct(AP.AP_NEW_VALUE)) TIPO_TOTAL,1 AS TOTAL,
FECHA, ''MANTENCIONES'' AS TIPO, USUARIO,
'''||x.PROJECT_NAME||''' as PROYECTO,
'''||x.DOMAIN_NAME||''' as DOMINIO,
T.TS_NAME AS NOMBRE_TEST,
''SERVIDOR TSOFT'' as SERVIDOR,
T.TS_STATUS AS ESTADO_CASO

FROM  '||x.db_name||'.TEST T
INNER JOIN '||x.db_name||'.AUDIT_LOG AU ON AU.AU_ENTITY_ID = T.TS_TEST_ID
INNER JOIN '||x.db_name||'.AUDIT_PROPERTIES AP ON AP.AP_ACTION_ID = AU.AU_ACTION_ID
INNER JOIN '||x.db_name||'.ALL_LISTS AL ON T.TS_SUBJECT = AL.AL_ITEM_ID

--LEFT JOIN '||x.db_name||'.ALL_LISTS AL ON  AL.AL_ITEM_ID = T.TS_SUBJECT
--LEFT JOIN '||x.db_name||'.ALL_LISTS AL1 ON AL1.AL_ITEM_ID = AL.AL_FATHER_ID
--LEFT JOIN '||x.db_name||'.ALL_LISTS AL2 ON AL2.AL_ITEM_ID = AL1.AL_FATHER_ID
--LEFT JOIN '||x.db_name||'.ALL_LISTS AL3 ON AL3.AL_ITEM_ID = AL2.AL_FATHER_ID
--LEFT JOIN '||x.db_name||'.ALL_LISTS AL4 ON AL4.AL_ITEM_ID = AL3.AL_FATHER_ID
--LEFT JOIN '||x.db_name||'.ALL_LISTS AL5 ON AL5.AL_ITEM_ID = AL4.AL_FATHER_ID

  LEFT JOIN (
      
      SELECT DISTINCT TS_TEST_ID, AU_USER USUARIO, AU_TIME FECHA 
      FROM  '||x.db_name||'.TEST 
      INNER JOIN '||x.db_name||'.AUDIT_LOG AU ON AU.AU_ENTITY_ID = TS_TEST_ID
      INNER JOIN '||x.db_name||'.AUDIT_PROPERTIES AP ON AP.AP_ACTION_ID = AU.AU_ACTION_ID
      WHERE AP_OLD_VALUE IN (''Mantención'')
      AND AU.AU_ENTITY_TYPE = ''TEST''
      --AND AU.AU_TIME BETWEEN ''31/12/2016'' AND ''01/02/2017''
      --AND TS_USER_01 = ''Flexcube Casa''
      --AND TS_TYPE IN (''SERVICE-TEST'', ''QUICKTEST_TEST'')
      --AND TS_TEST_ID IN (15092)   
      GROUP BY TS_TEST_ID,  AU_USER, AU_TIME
      
      ) TAB ON TAB.TS_TEST_ID = T.TS_TEST_ID
      
 -- LEFT JOIN (
      
     -- SELECT DISTINCT TS_TEST_ID, (AU_TIME) FECHA
    --  FROM  '||x.db_name||'.TEST 
    --  INNER JOIN '||x.db_name||'.AUDIT_LOG AU ON AU.AU_ENTITY_ID = TS_TEST_ID
    --  INNER JOIN '||x.db_name||'.AUDIT_PROPERTIES AP ON AP.AP_ACTION_ID = AU.AU_ACTION_ID
    --  WHERE AP_OLD_VALUE IN (''Mantención'')
   --   AND AU.AU_ENTITY_TYPE = ''TEST''
   --   --AND AU.AU_TIME BETWEEN ''31/12/2016'' AND ''01/02/2017''
   --   --AND TS_USER_01 = ''Flexcube Casa''
   --   --AND TS_TYPE IN (''SERVICE-TEST'', ''QUICKTEST_TEST'')
-- --AND TS_TEST_ID IN (15092)   
   --   GROUP BY TS_TEST_ID, AU_TIME
      
    --  ) TAB1 ON TAB1.TS_TEST_ID = T.TS_TEST_ID    
      

WHERE 1=1

AND AU.AU_ENTITY_TYPE = ''TEST''
--AND T.TS_TEST_ID IN (15092)   
--AND T.TS_TYPE IN (''SERVICE-TEST'', ''QUICKTEST_TEST'')
AND AP.AP_NEW_VALUE=''Mantención''
AND T.TS_STATUS NOT IN (''Obsoleto'', ''Detenido'')
--AND AU.AU_TIME BETWEEN ''31/12/2016'' AND ''01/02/2017''
--AND T.TS_USER_01 = ''Flexcube Casa''
--AND(AL.AL_ABSOLUTE_PATH not like ''AAAAAPAAH%''  AND AL.AL_ABSOLUTE_PATH not like ''AAAAAPAAF%'') 
AND(AL.AL_ABSOLUTE_PATH not like ''AAAAAPAAH%'')
GROUP BY T.TS_TEST_ID,T.TS_TYPE, '''', TS_USER_01, TS_RESPONSIBLE, USUARIO, FECHA, T.TS_NAME, T.TS_STATUS


';

end loop;



for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME  from alm_siteadmin_db_12.projects where DB_NAME = 'qa_qa_db0') loop
execute immediate  'insert into ALM_REPORT.DATA_DSH_AUTOMATICO

SELECT T.TS_TEST_ID,T.TS_TYPE, TS_USER_05 AS SISTEMA, TS_RESPONSIBLE AS DISEÑADOR, COUNT (distinct AP_NEW_VALUE) TIPO_TOTAL,1 AS TOTAL, 
FECHA, ''CREACIONES'' AS TIPO, USUARIO,
'''||x.PROJECT_NAME||''' as PROYECTO,
'''||x.DOMAIN_NAME||''' as DOMINIO,
T.TS_NAME AS NOMBRE_TEST,
''SERVIDOR TSOFT'' as SERVIDOR,
T.TS_STATUS AS ESTADO_CASO

FROM  '||x.db_name||'.TEST T
INNER JOIN '||x.db_name||'.AUDIT_LOG AU ON AU.AU_ENTITY_ID = T.TS_TEST_ID
INNER JOIN '||x.db_name||'.AUDIT_PROPERTIES AP ON AP.AP_ACTION_ID = AU.AU_ACTION_ID
INNER JOIN '||x.db_name||'.ALL_LISTS AL ON T.TS_SUBJECT = AL.AL_ITEM_ID

--LEFT JOIN '||x.db_name||'.ALL_LISTS AL ON  AL.AL_ITEM_ID = T.TS_SUBJECT
--LEFT JOIN '||x.db_name||'.ALL_LISTS AL1 ON AL1.AL_ITEM_ID = AL.AL_FATHER_ID
--LEFT JOIN '||x.db_name||'.ALL_LISTS AL2 ON AL2.AL_ITEM_ID = AL1.AL_FATHER_ID
--LEFT JOIN '||x.db_name||'.ALL_LISTS AL3 ON AL3.AL_ITEM_ID = AL2.AL_FATHER_ID
--LEFT JOIN '||x.db_name||'.ALL_LISTS AL4 ON AL4.AL_ITEM_ID = AL3.AL_FATHER_ID
--LEFT JOIN '||x.db_name||'.ALL_LISTS AL5 ON AL5.AL_ITEM_ID = AL4.AL_FATHER_ID

  LEFT JOIN (
      
      SELECT DISTINCT TS_TEST_ID, MIN(AU_TIME)  FECHA
      FROM  '||x.db_name||'.TEST 
      INNER JOIN '||x.db_name||'.AUDIT_LOG AU ON AU.AU_ENTITY_ID = TS_TEST_ID
      INNER JOIN '||x.db_name||'.AUDIT_PROPERTIES AP ON AP.AP_ACTION_ID = AU.AU_ACTION_ID
      WHERE AP_NEW_VALUE IN (''Listo para Ejecutar'')
      AND AU.AU_ENTITY_TYPE = ''TEST''
      --AND TS_TYPE IN (''SERVICE-TEST'', ''QUICKTEST_TEST'')
      --AND TS_TEST_ID IN (14236) 
      GROUP BY TS_TEST_ID
      
      ) TAB ON TAB.TS_TEST_ID = T.TS_TEST_ID
      
      LEFT JOIN (
      
      SELECT DISTINCT A.TS_TEST_ID, AU_USER USUARIO
      FROM  '||x.db_name||'.TEST A 
      INNER JOIN '||x.db_name||'.AUDIT_LOG AU ON AU.AU_ENTITY_ID = A.TS_TEST_ID
      INNER JOIN '||x.db_name||'.AUDIT_PROPERTIES AP ON AP.AP_ACTION_ID = AU.AU_ACTION_ID
      WHERE AP_NEW_VALUE IN (''Listo para Ejecutar'')
      AND AU.AU_ENTITY_TYPE = ''TEST''
      AND AU_TIME IN 
                        (SELECT MIN(AU_TIME)
                        FROM  '||x.db_name||'.TEST B
                        INNER JOIN '||x.db_name||'.AUDIT_LOG AU ON AU.AU_ENTITY_ID = TS_TEST_ID
                        INNER JOIN '||x.db_name||'.AUDIT_PROPERTIES AP ON AP.AP_ACTION_ID = AU.AU_ACTION_ID
                        WHERE AP_NEW_VALUE IN (''Listo para Ejecutar'')
                        AND AU.AU_ENTITY_TYPE = ''TEST''
                        AND A.TS_TEST_ID = B.TS_TEST_ID
                        )                         
      --AND A.TS_TEST_ID = ''17106''      
      GROUP BY A.TS_TEST_ID,  AU_USER
      
      ) TAB ON TAB.TS_TEST_ID = T.TS_TEST_ID     
      
      

WHERE AP_NEW_VALUE IN (''Desarrollo'',''Pruebas Internas'',''En Validación'', ''Listo para Ejecutar'')
AND AU.AU_ENTITY_TYPE = ''TEST''
--AND T.TS_TEST_ID IN (14236) 
--AND T.TS_TYPE IN (''SERVICE-TEST'', ''QUICKTEST_TEST'')
--AND(AL.AL_ABSOLUTE_PATH not like ''AAAAAPAAD%''  AND AL.AL_ABSOLUTE_PATH not like ''AAAAAPAABAACAAB%'' AND AL.AL_ABSOLUTE_PATH not like ''AAAAAPAABAAAAAA%'' AND AL.AL_ABSOLUTE_PATH not like ''AAAAAPAABAADAAC%'')     
AND(AL.AL_ABSOLUTE_PATH not like ''AAAAAPAAD%'')
GROUP BY T.TS_TEST_ID,T.TS_TYPE, FECHA, TS_USER_05, TS_RESPONSIBLE, USUARIO, T.TS_NAME, T.TS_STATUS
HAVING COUNT (distinct AP_NEW_VALUE) >= 4

UNION ALL -- COMIENZAN LAS MANTENCIONES

SELECT T.TS_TEST_ID, T.TS_TYPE, TS_USER_05 AS SISTEMA, TS_RESPONSIBLE AS DISEÑADOR,  Count(distinct(AP.AP_NEW_VALUE)) TIPO_TOTAL,1 AS TOTAL,
FECHA, ''MANTENCIONES'' AS TIPO, USUARIO,
'''||x.PROJECT_NAME||''' as PROYECTO,
'''||x.DOMAIN_NAME||''' as DOMINIO,
T.TS_NAME AS NOMBRE_TEST,
''SERVIDOR TSOFT'' as SERVIDOR,
T.TS_STATUS AS ESTADO_CASO

FROM  '||x.db_name||'.TEST T
INNER JOIN '||x.db_name||'.AUDIT_LOG AU ON AU.AU_ENTITY_ID = T.TS_TEST_ID
INNER JOIN '||x.db_name||'.AUDIT_PROPERTIES AP ON AP.AP_ACTION_ID = AU.AU_ACTION_ID
INNER JOIN '||x.db_name||'.ALL_LISTS AL ON T.TS_SUBJECT = AL.AL_ITEM_ID

--LEFT JOIN '||x.db_name||'.ALL_LISTS AL ON  AL.AL_ITEM_ID = T.TS_SUBJECT
--LEFT JOIN '||x.db_name||'.ALL_LISTS AL1 ON AL1.AL_ITEM_ID = AL.AL_FATHER_ID
--LEFT JOIN '||x.db_name||'.ALL_LISTS AL2 ON AL2.AL_ITEM_ID = AL1.AL_FATHER_ID
--LEFT JOIN '||x.db_name||'.ALL_LISTS AL3 ON AL3.AL_ITEM_ID = AL2.AL_FATHER_ID
--LEFT JOIN '||x.db_name||'.ALL_LISTS AL4 ON AL4.AL_ITEM_ID = AL3.AL_FATHER_ID
--LEFT JOIN '||x.db_name||'.ALL_LISTS AL5 ON AL5.AL_ITEM_ID = AL4.AL_FATHER_ID

  LEFT JOIN (
      
      SELECT DISTINCT TS_TEST_ID, AU_USER USUARIO, AU_TIME FECHA 
      FROM  '||x.db_name||'.TEST 
      INNER JOIN '||x.db_name||'.AUDIT_LOG AU ON AU.AU_ENTITY_ID = TS_TEST_ID
      INNER JOIN '||x.db_name||'.AUDIT_PROPERTIES AP ON AP.AP_ACTION_ID = AU.AU_ACTION_ID
      WHERE AP_OLD_VALUE IN (''Mantención'')
      AND AU.AU_ENTITY_TYPE = ''TEST''
      --AND AU.AU_TIME BETWEEN ''31/12/2016'' AND ''01/02/2017''
      --AND TS_USER_05 = ''Flexcube Casa''
      --AND TS_TYPE IN (''SERVICE-TEST'', ''QUICKTEST_TEST'')
      --AND TS_TEST_ID IN (15092)   
      GROUP BY TS_TEST_ID,  AU_USER, AU_TIME
      
      ) TAB ON TAB.TS_TEST_ID = T.TS_TEST_ID
      
 -- LEFT JOIN (
      
     -- SELECT DISTINCT TS_TEST_ID, (AU_TIME) FECHA
    --  FROM  '||x.db_name||'.TEST 
    --  INNER JOIN '||x.db_name||'.AUDIT_LOG AU ON AU.AU_ENTITY_ID = TS_TEST_ID
    --  INNER JOIN '||x.db_name||'.AUDIT_PROPERTIES AP ON AP.AP_ACTION_ID = AU.AU_ACTION_ID
    --  WHERE AP_OLD_VALUE IN (''Mantención'')
   --   AND AU.AU_ENTITY_TYPE = ''TEST''
   --   --AND AU.AU_TIME BETWEEN ''31/12/2016'' AND ''01/02/2017''
   --   --AND TS_USER_05 = ''Flexcube Casa''
   --   --AND TS_TYPE IN (''SERVICE-TEST'', ''QUICKTEST_TEST'')
-- --AND TS_TEST_ID IN (15092)   
   --   GROUP BY TS_TEST_ID, AU_TIME
      
    --  ) TAB1 ON TAB1.TS_TEST_ID = T.TS_TEST_ID    
      

WHERE 1=1

AND AU.AU_ENTITY_TYPE = ''TEST''
--AND T.TS_TEST_ID IN (15092)   
--AND T.TS_TYPE IN (''SERVICE-TEST'', ''QUICKTEST_TEST'')
AND AP.AP_NEW_VALUE=''Mantención''
AND T.TS_STATUS NOT IN (''Obsoleto'', ''Detenido'')
--AND AU.AU_TIME BETWEEN ''31/12/2016'' AND ''01/02/2017''
--AND T.TS_USER_05 = ''Flexcube Casa''
--AND(AL.AL_ABSOLUTE_PATH not like ''AAAAAPAAD%''  AND AL.AL_ABSOLUTE_PATH not like ''AAAAAPAABAACAAB%'' AND AL.AL_ABSOLUTE_PATH not like ''AAAAAPAABAAAAAA%'' AND AL.AL_ABSOLUTE_PATH not like ''AAAAAPAABAADAAC%'')     
AND(AL.AL_ABSOLUTE_PATH not like ''AAAAAPAAD%'')
GROUP BY T.TS_TEST_ID,T.TS_TYPE, '''', TS_USER_05, TS_RESPONSIBLE, USUARIO, FECHA, T.TS_NAME, T.TS_STATUS
                     


'; end loop;

execute immediate  'insert into ALM_REPORT.DATA_DSH_AUTOMATICO 
select * from DATA_DSH_AUTOMATICO@SERVER_BCH
';

 
END;

/