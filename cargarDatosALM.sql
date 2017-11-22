--------------------------------------------------------
--  DDL for Procedure cargarDatosALM
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ALM_REPORT"."cargarDatosALM" AS
BEGIN
execute immediate 'TRUNCATE TABLE ALM_REPORT.DATOS_ALM';


------------------------ESTRUCTURA NUEVA-----------------------------------

for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME from alm_siteadmin_db_12.projects where DB_NAME = 'bch_qa_certificación_bch_qa_d') loop
execute immediate  'insert into ALM_REPORT.DATOS_ALM 
SELECT
DISTINCT
'''||x.db_name||'.'' || R.REL_ID "Id Version",
R.REL_NAME "Nombre Version",
R.REL_START_DATE "Fecha Replan. Inicio",
R.REL_END_DATE "Fecha Repla. Fin",
TO_DATE(R.REL_USER_03, ''yyyy/mm/dd'' ) "Fecha Inicio",
TO_DATE(R.REL_USER_02, ''yyyy/mm/dd'' ) "Fecha Fin",
'''||x.db_name||'.'' || RC.RCYC_ID "Id Ciclo",
RC.RCYC_NAME "Nombre Ciclo",
MIN(TC.TC_EXEC_DATE) "Inicio Etapa Dinamica",
MAX(TC.TC_EXEC_DATE) "Fin Etapa Dinamica",
 
(SELECT COUNT(DISTINCT TC_ACTUAL_TESTER) 
FROM '||x.db_name||'.TESTCYCL
JOIN '||x.db_name||'.RELEASE_CYCLES ON RCYC_ID = TC_ASSIGN_RCYC
JOIN '||x.db_name||'.RELEASES ON REL_ID = RCYC_PARENT_ID 
WHERE REL_ID = R.REL_ID   ) AS CANTIDAD_TESTER,
 
COUNT(DISTINCT TC.TC_TESTCYCL_ID) "Casos Definidos",
 
COUNT(DISTINCT CASE WHEN (TC.TC_STATUS = ''Passed'' OR TC.TC_STATUS = ''Failed''  OR TC.TC_STATUS = ''Not Completed'' OR
TC.TC_STATUS = ''Blocked'' ) THEN TC.TC_TESTCYCL_ID END  ) "Casos Ejecutados",
 
COUNT(DISTINCT CASE WHEN TC.TC_STATUS = ''Passed''  THEN TC.TC_TESTCYCL_ID END  ) "Casos Exitosos",
COUNT(DISTINCT CASE WHEN TC.TC_STATUS = ''Failed''  THEN TC.TC_TESTCYCL_ID END  ) "Casos Fallados",
 
 
COUNT(DISTINCT CASE WHEN (TC.TC_STATUS = ''Passed'' OR TC.TC_STATUS = ''Failed'' OR TC.TC_STATUS = ''Not Completed'' OR
TC.TC_STATUS = ''Blocked'') AND
TC.TC_EXEC_DATE >= TO_DATE(''01/''||TO_CHAR(SYSDATE,''mm'')||TO_CHAR(SYSDATE,''YYYY''),''dd/mm/yyyy'')   AND
TC.TC_EXEC_DATE <= TO_DATE(to_char(last_day(SYSDATE),''dd'')||''/''||TO_CHAR(SYSDATE,''mm'')||''/''||TO_CHAR(SYSDATE,''YYYY''), ''dd/mm/yyyy'')
THEN TC.TC_TESTCYCL_ID END  ) "Casos Ejecutados Mes",
 
-------------------------------EJECUCIONES----------------------------------------
COUNT (DISTINCT CASE WHEN (RN.RN_STATUS = ''Passed'' or RN.RN_STATUS = ''Failed'')  THEN RN.RN_RUN_ID END )  "Ejecuciones Ejecutadas" ,
COUNT (DISTINCT CASE WHEN RN.RN_STATUS = ''Passed''  THEN RN.RN_RUN_ID END )  "Ejecuciones Exitosas" ,
COUNT (DISTINCT CASE WHEN RN.RN_STATUS = ''Failed''  THEN RN.RN_RUN_ID END )  "Ejecuciones Falladas" ,
COUNT (DISTINCT CASE WHEN (RN.RN_STATUS = ''Passed'' or RN.RN_STATUS = ''Failed'' ) AND
RN.RN_EXECUTION_DATE >= TO_DATE(''01/''||TO_CHAR(SYSDATE,''mm'')||TO_CHAR(SYSDATE,''YYYY''),''dd/mm/yyyy'') AND
RN.RN_EXECUTION_DATE <= TO_DATE(to_char(last_day(SYSDATE),''dd'')||''/''||TO_CHAR(SYSDATE,''mm'')||''/''||TO_CHAR(SYSDATE,''YYYY''), ''dd/mm/yyyy'')
THEN RN.RN_RUN_ID END )  "Ejecuciones Ej. Mes" ,
 
COUNT (DISTINCT CASE WHEN (RN.RN_STATUS = ''Passed'' or RN.RN_STATUS = ''Failed'' ) AND
RN.RN_EXECUTION_DATE >= TO_DATE(''01/''||TO_CHAR(SYSDATE,''mm'')||TO_CHAR(SYSDATE,''YYYY''),''dd/mm/yyyy'')  AND
RN.RN_EXECUTION_DATE <= TO_DATE(to_char(last_day(SYSDATE),''dd'')||''/''||TO_CHAR(SYSDATE,''mm'')||''/''||TO_CHAR(SYSDATE,''YYYY''), ''dd/mm/yyyy'') AND
(RN.RN_SUBTYPE_ID)  IN (''hp.qc.run.QUICKTEST_TEST'', ''hp.qc.run.SERVICE-TEST'')   THEN RN.RN_RUN_ID END )  "Ejecuciones Auto. Mes",
 
RQ.RQ_REQ_NAME "requerimiento" ,
 
RQ.RQ_USER_04 "estado_requerimiento" ,
 
'''||x.PROJECT_NAME||'''  AS esquema,
 
RQ.RQ_USER_03 "jdp_qa",
 
RC.RCYC_USER_01 "Tipo de Ciclo",
 
'''||x.DOMAIN_NAME||''' as dominio,
 
COUNT(DISTINCT CASE WHEN TC.TC_STATUS = ''Blocked''  THEN TC.TC_TESTCYCL_ID END  ) "Casos Bloqueados",
 
ALM_REPORT.DIAS_LABORABLES(TO_DATE(R.REL_USER_03, ''yyyy/mm/dd'' ), sysdate) "dias transcurridos",
 
(SELECT COUNT(distinct BG_BUG_ID) FROM '||x.db_name||'.BUG WHERE RC.RCYC_ID = BG_TARGET_RCYC) "Cantidad defectos ciclo",
 
NVL((
SELECT
SUM(
CASE WHEN ((SELECT COUNT(AP.AP_NEW_VALUE )
FROM '||x.db_name||'.AUDIT_LOG AU
JOIN '||x.db_name||'.AUDIT_PROPERTIES AP ON AP.AP_ACTION_ID = AU.AU_ACTION_ID AND AP.AP_NEW_VALUE = ''Listo para Probar''
AND AP.AP_PROPERTY_NAME = ''06- Estado''  --Retrasa los tiempos
WHERE AU.AU_ENTITY_ID = cast(B.BG_BUG_ID as varchar(200)))- 1  ) = -1 THEN 0 ELSE
((SELECT COUNT(AP.AP_NEW_VALUE )
FROM '||x.db_name||'.AUDIT_LOG AU
JOIN '||x.db_name||'.AUDIT_PROPERTIES AP ON AP.AP_ACTION_ID = AU.AU_ACTION_ID AND AP.AP_NEW_VALUE = ''Listo para Probar''
AND AP.AP_PROPERTY_NAME = ''06- Estado''  --Retrasa los tiempos
WHERE AU.AU_ENTITY_ID = cast(B.BG_BUG_ID as varchar(200)))- 1  ) END )
 
 
FROM '||x.db_name||'.BUG    B
JOIN '||x.db_name||'.RELEASES  ON REL_ID = B.BG_TARGET_REL
JOIN '||x.db_name||'.RELEASE_CYCLES  ON RCYC_ID = BG_TARGET_RCYC
WHERE RCYC_ID = RC.RCYC_ID
) ,0) "suma iteraciones",
 
NVL((
SELECT
AVG(
CASE WHEN B.BG_CLOSING_DATE IS NULL THEN  ALM_REPORT.DIAS_LABORABLES(B.BG_DETECTION_DATE , SYSDATE ) ELSE 
ALM_REPORT.DIAS_LABORABLES(B.BG_DETECTION_DATE , B.BG_CLOSING_DATE ) END - 1
)
 
FROM '||x.db_name||'.BUG    B
JOIN '||x.db_name||'.RELEASES  ON REL_ID = B.BG_TARGET_REL
JOIN '||x.db_name||'.RELEASE_CYCLES  ON RCYC_ID = BG_TARGET_RCYC
WHERE RCYC_ID = RC.RCYC_ID),0) "añejamiento",
 
NVL((SELECT
AVG(
CASE WHEN B.BG_CLOSING_DATE IS NULL THEN  ALM_REPORT.DIAS_LABORABLES(B.BG_DETECTION_DATE , SYSDATE ) ELSE 
ALM_REPORT.DIAS_LABORABLES(B.BG_DETECTION_DATE , B.BG_CLOSING_DATE ) END -1)
 
FROM '||x.db_name||'.BUG    B
JOIN '||x.db_name||'.RELEASES  ON REL_ID = B.BG_TARGET_REL
JOIN '||x.db_name||'.RELEASE_CYCLES  ON RCYC_ID = BG_TARGET_RCYC
WHERE
B.BG_SEVERITY IN (''2 - Alto'',''1 - Crítico'',''4-Very High'',''5-Urgent'')
AND RCYC_ID = RC.RCYC_ID),0) "Añejamiento invalidante",
 
 
to_date(RC.RCYC_USER_02,''yyyy/mm/dd'' ) "Fecha Inicio CICLO",
to_date(RC.RCYC_USER_03,''yyyy/mm/dd'' ) "Fecha Fin CICLO",
 
ALM_REPORT.DIAS_LABORABLES(
to_date(RC.RCYC_USER_02,''yyyy/mm/dd'' ) , to_date(RC.RCYC_USER_03,''yyyy/mm/dd'' )
) "Dias transcurridos ciclo",
 
NVL(
ALM_REPORT.DIAS_LABORABLES(
MIN(TC.TC_EXEC_DATE) ,
MAX(TC.TC_EXEC_DATE)
),0) "Dias transcurridos Dinamicos",
 
NVL((SELECT DISTINCT  MAX(RQ_USER_33)
FROM  '||x.db_name||'.REQ,  '||x.db_name||'.REQ_RELEASES 
WHERE RQ_TYPE_ID = 107 AND RQRL_RELEASE_ID = R.REL_ID and RQRL_REQ_ID = RQ_REQ_ID), 
''No tiene trazabilidad al requerimiento o se encuentra vacio'') as coordinador,
 
to_date(RC.RCYC_USER_02,''yyyy-mm-dd''),
 
RC.RCYC_START_DATE,
R.REL_USER_01 "N_ART",
CASE
WHEN RF3.RF_NAME = ''Continuidad'' THEN ''MALO''
WHEN RF2.RF_NAME = ''Continuidad'' THEN ''MALO''
WHEN RF.RF_NAME = ''Continuidad'' THEN ''MALO''
ELSE ''OK'' END AS "VALIDACION"
 
-----------------------------------------------------------------------------------
 
FROM
'||x.db_name||'.RELEASES R
LEFT JOIN  '||x.db_name||'.RELEASE_CYCLES RC ON RC.RCYC_PARENT_ID = R.REL_ID
LEFT JOIN  '||x.db_name||'.BUG B ON B.BG_DETECTED_IN_RCYC = RC.RCYC_ID
LEFT JOIN  '||x.db_name||'.TESTCYCL TC ON TC.TC_ASSIGN_RCYC = RC.RCYC_ID
LEFT JOIN  '||x.db_name||'.RUN RN ON RN.RN_TESTCYCL_ID = TC.TC_TESTCYCL_ID
LEFT JOIN  '||x.db_name||'.REQ_RELEASES RQRL ON RQRL.RQRL_REQ_ID = R.REL_ID 
LEFT JOIN  '||x.db_name||'.REQ RQ ON RQ.RQ_REQ_ID = RQRL.RQRL_REQ_ID 
LEFT JOIN  '||x.db_name||'.RELEASE_FOLDERS RF ON RF.RF_ID = R.REL_PARENT_ID
LEFT JOIN  '||x.db_name||'.RELEASE_FOLDERS RF2 ON RF2.RF_ID = RF.RF_PARENT_ID
LEFT JOIN  '||x.db_name||'.RELEASE_FOLDERS RF3 ON RF3.RF_ID = RF2.RF_PARENT_ID



where RC.RCYC_NAME not LIKE (''%IDC%'') and RF.RF_PATH NOT LIKE ''%AAAAAC%''
--and RF.RF_PATH  LIKE ''%AAAAAA%''
AND(RF.RF_PATH not like ''AAAAAD%''  AND RF.RF_PATH not like ''AAAAADAAC%'' AND RF.RF_PATH not like ''AAAAADAAB%'' AND RF.RF_PATH not like ''AAAAAG%'')
 
GROUP BY  RC.RCYC_ID,
R.REL_ID,  
R.REL_NAME, 
R.REL_START_DATE ,
R.REL_END_DATE ,
TO_DATE(R.REL_USER_03, ''yyyy/mm/dd'' ) ,
TO_DATE(R.REL_USER_02, ''yyyy/mm/dd'' ) ,
RC.RCYC_NAME, 
RC.RCYC_USER_01 ,
to_date(RC.RCYC_USER_02,''yyyy/mm/dd'' ) ,
to_date(RC.RCYC_USER_03,''yyyy/mm/dd'' ),
RC.RCYC_USER_02,
RQ.RQ_REQ_NAME, RQ.RQ_USER_04, 
RQ.RQ_USER_03,
RC.RCYC_START_DATE, 
R.REL_USER_01, 
RF3.RF_NAME, 
RF2.RF_NAME, 
RF.RF_NAME, 
B.BG_BUG_ID
';
end loop;


for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME  from alm_siteadmin_db_12.projects where DB_NAME = 'qa_qa_db0') loop
execute immediate  'insert into ALM_REPORT.DATOS_ALM 

SELECT
DISTINCT
'''||x.db_name||'.'' || R.REL_ID "Id Version",
R.REL_NAME "Nombre Version",
R.REL_START_DATE "Fecha Replan. Inicio",
R.REL_END_DATE "Fecha Repla. Fin",
TO_DATE(R.REL_USER_01, ''YYYY/mm/dd'' ) "Fecha Inicio",
TO_DATE(R.REL_USER_03, ''YYYY/mm/dd'' ) "Fecha Fin",
'''||x.db_name||'.'' || RC.RCYC_ID "Id Ciclo",
RC.RCYC_NAME "Nombre Ciclo",
MIN(TC.TC_EXEC_DATE) "Inicio Etapa Dinamica",
MAX(TC.TC_EXEC_DATE) "Fin Etapa Dinamica",
 
(SELECT COUNT(DISTINCT TC_ACTUAL_TESTER) 
FROM '||x.db_name||'.TESTCYCL
JOIN '||x.db_name||'.RELEASE_CYCLES ON RCYC_ID = TC_ASSIGN_RCYC
JOIN '||x.db_name||'.RELEASES ON REL_ID = RCYC_PARENT_ID 
WHERE REL_ID = R.REL_ID   ) AS CANTIDAD_TESTER,
 
COUNT(DISTINCT TC.TC_TESTCYCL_ID) "Casos Definidos",
 
COUNT(DISTINCT CASE WHEN (TC.TC_STATUS = ''Passed'' OR TC.TC_STATUS = ''Failed''  OR TC.TC_STATUS = ''Not Completed'' OR
TC.TC_STATUS = ''Blocked'' ) THEN TC.TC_TESTCYCL_ID END  ) "Casos Ejecutados",
 
COUNT(DISTINCT CASE WHEN TC.TC_STATUS = ''Passed'' THEN TC.TC_TESTCYCL_ID END  ) "Casos Exitosos",
COUNT(DISTINCT CASE WHEN TC.TC_STATUS = ''Failed''  THEN TC.TC_TESTCYCL_ID END  ) "Casos Fallados",
 
 
COUNT(DISTINCT CASE WHEN (TC.TC_STATUS = ''Passed'' OR TC.TC_STATUS = ''Failed'' OR TC.TC_STATUS = ''Not Completed'' OR
TC.TC_STATUS = ''Blocked'') AND
TC.TC_EXEC_DATE >= TO_DATE(''01/''||TO_CHAR(SYSDATE,''mm'')||TO_CHAR(SYSDATE,''YYYY''),''dd/mm/YYYY'')   AND
TC.TC_EXEC_DATE <= TO_DATE(to_char(last_day(SYSDATE),''dd'')||''/''||TO_CHAR(SYSDATE,''mm'')||''/''||TO_CHAR(SYSDATE,''YYYY''), ''dd/mm/yyyy'')
THEN TC.TC_TESTCYCL_ID END  ) "Casos Ejecutados Mes",
 
-------------------------------EJECUCIONES----------------------------------------
COUNT (DISTINCT CASE WHEN (RN.RN_STATUS = ''Passed'' or RN.RN_STATUS = ''Failed'')  THEN RN.RN_RUN_ID END )  "Ejecuciones Ejecutadas" ,
COUNT (DISTINCT CASE WHEN RN.RN_STATUS = ''Passed''  THEN RN.RN_RUN_ID END )  "Ejecuciones Exitosas" ,
COUNT (DISTINCT CASE WHEN RN.RN_STATUS = ''Failed''  THEN RN.RN_RUN_ID END )  "Ejecuciones Falladas" ,
COUNT (DISTINCT CASE WHEN (RN.RN_STATUS = ''Passed'' or RN.RN_STATUS = ''Failed'' ) AND
RN.RN_EXECUTION_DATE >= TO_DATE(''01/''||TO_CHAR(SYSDATE,''mm'')||TO_CHAR(SYSDATE,''YYYY''),''dd/mm/YYYY'') AND
RN.RN_EXECUTION_DATE <= TO_DATE(to_char(last_day(SYSDATE),''dd'')||''/''||TO_CHAR(SYSDATE,''mm'')||''/''||TO_CHAR(SYSDATE,''YYYY''), ''dd/mm/yyyy'')
THEN RN.RN_RUN_ID END )  "Ejecuciones Ej. Mes" ,
 
COUNT (DISTINCT CASE WHEN (RN.RN_STATUS = ''Passed'' or RN.RN_STATUS = ''Failed'' ) AND
RN.RN_EXECUTION_DATE >= TO_DATE(''01/''||TO_CHAR(SYSDATE,''mm'')||TO_CHAR(SYSDATE,''YYYY''),''dd/mm/YYYY'')  AND
RN.RN_EXECUTION_DATE <= TO_DATE(to_char(last_day(SYSDATE),''dd'')||''/''||TO_CHAR(SYSDATE,''mm'')||''/''||TO_CHAR(SYSDATE,''YYYY''), ''dd/mm/yyyy'') AND
(RN.RN_SUBTYPE_ID)  IN (''hp.qc.run.QUICKTEST_TEST'', ''hp.qc.run.SERVICE-TEST'')   THEN RN.RN_RUN_ID END )  "Ejecuciones Auto. Mes",
 
RQ.RQ_REQ_NAME "requerimiento" ,
 
RQ.RQ_USER_02 "estado_requerimiento" ,
 
'''|| x.PROJECT_NAME||'''  AS esquema,
 
RQ.RQ_USER_14 "jdp_qa",
 
RC.RCYC_USER_03 "Tipo de Ciclo",
 
'''||x.DOMAIN_NAME||''' as dominio,
 
COUNT(DISTINCT CASE WHEN TC.TC_STATUS = ''Blocked''  THEN TC.TC_TESTCYCL_ID END  ) "Casos Bloqueados",
 
ALM_REPORT.DIAS_LABORABLES(TO_DATE(R.REL_USER_01, ''YYYY/mm/dd'' ), sysdate) "dias transcurridos",
 
(SELECT COUNT(distinct BG_BUG_ID) FROM '||x.db_name||'.BUG WHERE RC.RCYC_ID = BG_TARGET_RCYC) "Cantidad defectos ciclo",
 
NVL((
SELECT
SUM(
CASE WHEN ((SELECT COUNT(AP.AP_NEW_VALUE )
FROM '||x.db_name||'.AUDIT_LOG AU
JOIN '||x.db_name||'.AUDIT_PROPERTIES AP ON AP.AP_ACTION_ID = AU.AU_ACTION_ID AND AP.AP_NEW_VALUE = ''Listo para Probar''
AND AP.AP_PROPERTY_NAME = ''06- Estado''  --Retrasa los tiempos
WHERE AU.AU_ENTITY_ID = cast(B.BG_BUG_ID as varchar(200)))- 1  ) = -1 THEN 0 ELSE
((SELECT COUNT(AP.AP_NEW_VALUE )
FROM '||x.db_name||'.AUDIT_LOG AU
JOIN '||x.db_name||'.AUDIT_PROPERTIES AP ON AP.AP_ACTION_ID = AU.AU_ACTION_ID AND AP.AP_NEW_VALUE = ''Listo para Probar''
AND AP.AP_PROPERTY_NAME = ''06- Estado''  --Retrasa los tiempos
WHERE AU.AU_ENTITY_ID = cast(B.BG_BUG_ID as varchar(200)))- 1  ) END )
 
 
FROM '||x.db_name||'.BUG    B
JOIN '||x.db_name||'.RELEASES  ON REL_ID = B.BG_TARGET_REL
JOIN '||x.db_name||'.RELEASE_CYCLES  ON RCYC_ID = BG_TARGET_RCYC
WHERE RCYC_ID = RC.RCYC_ID
) ,0) "suma iteraciones",
 
NVL((
SELECT
AVG(
CASE WHEN B.BG_CLOSING_DATE IS NULL THEN  ALM_REPORT.DIAS_LABORABLES(B.BG_DETECTION_DATE , SYSDATE ) ELSE 
ALM_REPORT.DIAS_LABORABLES(B.BG_DETECTION_DATE , B.BG_CLOSING_DATE ) END - 1
)
 
FROM '||x.db_name||'.BUG    B
JOIN '||x.db_name||'.RELEASES  ON REL_ID = B.BG_TARGET_REL
JOIN '||x.db_name||'.RELEASE_CYCLES  ON RCYC_ID = BG_TARGET_RCYC
WHERE RCYC_ID = RC.RCYC_ID),0) "añejamiento",
 
NVL((SELECT
AVG(
CASE WHEN B.BG_CLOSING_DATE IS NULL THEN  ALM_REPORT.DIAS_LABORABLES(B.BG_DETECTION_DATE , SYSDATE ) ELSE 
ALM_REPORT.DIAS_LABORABLES(B.BG_DETECTION_DATE , B.BG_CLOSING_DATE ) END -1)
 
FROM '||x.db_name||'.BUG    B
JOIN '||x.db_name||'.RELEASES  ON REL_ID = B.BG_TARGET_REL
JOIN '||x.db_name||'.RELEASE_CYCLES  ON RCYC_ID = BG_TARGET_RCYC
WHERE
B.BG_SEVERITY IN (''2 - Alto'',''1 - Crítico'',''4-Very High'',''5-Urgent'')
AND RCYC_ID = RC.RCYC_ID),0) "Añejamiento invalidante",
 
 
to_date(RC.RCYC_USER_01,''YYYY/mm/dd'' ) "Fecha Inicio CICLO",
to_date(RC.RCYC_USER_02,''YYYY/mm/dd'' ) "Fecha Fin CICLO",
 
ALM_REPORT.DIAS_LABORABLES(
to_date(RC.RCYC_USER_01,''YYYY/mm/dd'' ) , to_date(RC.RCYC_USER_02,''YYYY/mm/dd'' )
) "Dias transcurridos ciclo",
 
NVL(
ALM_REPORT.DIAS_LABORABLES(
MIN(TC.TC_EXEC_DATE) ,
MAX(TC.TC_EXEC_DATE)
),0) "Dias transcurridos Dinamicos",
 
NVL((SELECT DISTINCT  MAX(RQ_USER_12)
FROM  '||x.db_name||'.REQ,  '||x.db_name||'.REQ_RELEASES 
WHERE RQ_TYPE_ID = 107 AND RQRL_RELEASE_ID = R.REL_ID and RQRL_REQ_ID = RQ_REQ_ID), 
''No tiene trazabilidad al requerimiento o se encuentra vacio'') as coordinador,
 
to_date(RC.RCYC_USER_01,''YYYY-mm-dd''),
 
RC.RCYC_START_DATE,
R.REL_USER_04 "N_ART",
CASE
WHEN RF3.RF_NAME = ''Continuidad'' THEN ''MALO''
WHEN RF2.RF_NAME = ''Continuidad'' THEN ''MALO''
WHEN RF.RF_NAME = ''Continuidad'' THEN ''MALO''
ELSE ''OK'' END AS "VALIDACION"
 
-----------------------------------------------------------------------------------
 
FROM
'||x.db_name||'.RELEASES R
LEFT JOIN  '||x.db_name||'.RELEASE_CYCLES RC ON RC.RCYC_PARENT_ID = R.REL_ID
LEFT JOIN  '||x.db_name||'.BUG B ON B.BG_DETECTED_IN_RCYC = RC.RCYC_ID
LEFT JOIN  '||x.db_name||'.TESTCYCL TC ON TC.TC_ASSIGN_RCYC = RC.RCYC_ID
LEFT JOIN  '||x.db_name||'.RUN RN ON RN.RN_TESTCYCL_ID = TC.TC_TESTCYCL_ID
LEFT JOIN  '||x.db_name||'.REQ_RELEASES RQRL ON RQRL.RQRL_REQ_ID = R.REL_ID 
LEFT JOIN  '||x.db_name||'.REQ RQ ON RQ.RQ_REQ_ID = RQRL.RQRL_REQ_ID 
LEFT JOIN  '||x.db_name||'.RELEASE_FOLDERS RF ON RF.RF_ID = R.REL_PARENT_ID and RF.RF_NAME NOT LIKE ''%Papelera%''
LEFT JOIN  '||x.db_name||'.RELEASE_FOLDERS RF2 ON RF2.RF_ID = RF.RF_PARENT_ID
LEFT JOIN  '||x.db_name||'.RELEASE_FOLDERS RF3 ON RF3.RF_ID = RF2.RF_PARENT_ID

where RC.RCYC_NAME not LIKE (''%IDC%'')
 
GROUP BY  RC.RCYC_ID,
R.REL_ID,  
R.REL_NAME, 
R.REL_START_DATE ,
R.REL_END_DATE ,
TO_DATE(R.REL_USER_01, ''YYYY/mm/dd'' ) ,
TO_DATE(R.REL_USER_03, ''YYYY/mm/dd'' ) ,
RC.RCYC_NAME, 
RC.RCYC_USER_01 ,
to_date(RC.RCYC_USER_01,''YYYY/mm/dd'' ) ,
to_date(RC.RCYC_USER_02,''YYYY/mm/dd'' ),
RC.RCYC_USER_03,
RQ.RQ_REQ_NAME,
RQ.RQ_USER_02, 
RQ.RQ_USER_14,
RC.RCYC_START_DATE, 
R.REL_USER_04, 
RF3.RF_NAME, 
RF2.RF_NAME, 
RF.RF_NAME, 
B.BG_BUG_ID



';

end loop;

end;

/
