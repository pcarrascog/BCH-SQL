--------------------------------------------------------
--  DDL for Procedure cargarDatosALM_Vol
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ALM_REPORT"."cargarDatosALM_Vol" AS
BEGIN
execute immediate 'TRUNCATE TABLE ALM_REPORT.DATOS_ALM_VOLUMETRIA';

for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME from alm_siteadmin_db_12.projects where DB_NAME = 'bch_qcsitebch_db') loop
execute immediate  'insert into ALM_REPORT.DATOS_ALM_VOLUMETRIA
SELECT
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
TC.TC_EXEC_DATE >= TO_DATE(''01/''||TO_CHAR(SYSDATE,''mm'')||''/2016'',''dd/mm/yyyy'')   AND
TC.TC_EXEC_DATE <= TO_DATE(to_char(last_day(SYSDATE),''dd'')||''/''||TO_CHAR(SYSDATE,''mm'')||''/2016'', ''dd/mm/yyyy'')
THEN TC.TC_TESTCYCL_ID END  ) "Casos Ejecutados Mes",

-------------------------------EJECUCIONES----------------------------------------
COUNT (DISTINCT CASE WHEN (RN.RN_STATUS = ''Passed'' or RN.RN_STATUS = ''Failed'')  THEN RN.RN_RUN_ID END )  "Ejecuciones Ejecutadas" ,
COUNT (DISTINCT CASE WHEN RN.RN_STATUS = ''Passed''  THEN RN.RN_RUN_ID END )  "Ejecuciones Exitosas" ,
COUNT (DISTINCT CASE WHEN RN.RN_STATUS = ''Failed''  THEN RN.RN_RUN_ID END )  "Ejecuciones Falladas" ,
COUNT (DISTINCT CASE WHEN (RN.RN_STATUS = ''Passed'' or RN.RN_STATUS = ''Failed'' ) AND
RN.RN_EXECUTION_DATE >= TO_DATE(''01/''||TO_CHAR(SYSDATE,''mm'')||''/2016'',''dd/mm/yyyy'') AND
RN.RN_EXECUTION_DATE <= TO_DATE(to_char(last_day(SYSDATE),''dd'')||''/''||TO_CHAR(SYSDATE,''mm'')||''/2016'', ''dd/mm/yyyy'')
THEN RN.RN_RUN_ID END )  "Ejecuciones Ej. Mes" ,

COUNT (DISTINCT CASE WHEN (RN.RN_STATUS = ''Passed'' or RN.RN_STATUS = ''Failed'' ) AND
RN.RN_EXECUTION_DATE >= TO_DATE(''01/''||TO_CHAR(SYSDATE,''mm'')||''/2016'',''dd/mm/yyyy'')  AND
RN.RN_EXECUTION_DATE <= TO_DATE(to_char(last_day(SYSDATE),''dd'')||''/''||TO_CHAR(SYSDATE,''mm'')||''/2016'', ''dd/mm/yyyy'') AND
UPPER(RN.RN_SUBTYPE_ID)  LIKE ''%QUICKTEST_TEST%''   THEN RN.RN_RUN_ID END )  "Ejecuciones Auto. Mes",

NVL((SELECT DISTINCT  max(RQ_REQ_NAME) 
FROM  '||x.db_name||'.REQ,  '||x.db_name||'.REQ_RELEASES 
WHERE RQ_TYPE_ID = 107 AND RQRL_RELEASE_ID = R.REL_ID and RQRL_REQ_ID = RQ_REQ_ID), 
''No tiene trazabilidad al requerimiento'') as requerimiento ,

NVL((SELECT DISTINCT  max(RQ_USER_04)
FROM  '||x.db_name||'.REQ,  '||x.db_name||'.REQ_RELEASES 
WHERE RQ_TYPE_ID = 107 AND RQRL_RELEASE_ID = R.REL_ID and RQRL_REQ_ID = RQ_REQ_ID), 
''No tiene trazabilidad al requerimiento'') as estado_requerimiento ,

'''||x.PROJECT_NAME||'''  AS esquema,

NVL((SELECT DISTINCT  max(RQ_USER_03)
FROM  '||x.db_name||'.REQ,  '||x.db_name||'.REQ_RELEASES 
WHERE RQ_TYPE_ID = 107 AND RQRL_RELEASE_ID = R.REL_ID and RQRL_REQ_ID = RQ_REQ_ID), 
''No tiene trazabilidad al requerimiento'') as jdp_qa,

RC.RCYC_USER_01 "Tipo de Ciclo",

'''||x.DOMAIN_NAME||''' as dominio,

COUNT(DISTINCT CASE WHEN TC.TC_STATUS = ''Blocked''  THEN TC.TC_TESTCYCL_ID END  ) "Casos Bloqueados",

ALM_REPORT.DIASENTRE(TO_DATE(R.REL_USER_03, ''yyyy/mm/dd'' ), sysdate) "dias transcurridos",

(SELECT COUNT(distinct BG_BUG_ID) FROM '||x.db_name||'.BUG WHERE R.REL_ID = BG_TARGET_REL) "Cantidad defectos Release",

NVL((
SELECT
SUM(
CASE WHEN ((SELECT COUNT(AP.AP_NEW_VALUE )
FROM '||x.db_name||'.AUDIT_LOG AU
JOIN '||x.db_name||'.AUDIT_PROPERTIES AP ON AP.AP_ACTION_ID = AU.AU_ACTION_ID AND AP.AP_NEW_VALUE = ''Ready to Test''
AND AP.AP_PROPERTY_NAME = ''06 - Estado''  --Retrasa los tiempos
WHERE AU.AU_ENTITY_ID = cast(B.BG_BUG_ID as varchar(200)))- 1  ) = -1 THEN 0 ELSE
((SELECT COUNT(AP.AP_NEW_VALUE )
FROM '||x.db_name||'.AUDIT_LOG AU
JOIN '||x.db_name||'.AUDIT_PROPERTIES AP ON AP.AP_ACTION_ID = AU.AU_ACTION_ID AND AP.AP_NEW_VALUE = ''Ready to Test''
AND AP.AP_PROPERTY_NAME = ''06 - Estado''  --Retrasa los tiempos
WHERE AU.AU_ENTITY_ID = cast(B.BG_BUG_ID as varchar(200)))- 1  ) END )


FROM '||x.db_name||'.BUG    B
JOIN '||x.db_name||'.RELEASES  ON REL_ID = B.BG_TARGET_REL
JOIN '||x.db_name||'.RELEASE_CYCLES  ON RCYC_ID = BG_TARGET_RCYC
WHERE REL_ID = R.REL_ID
 ) ,0) "suma iteraciones",

NVL((
SELECT
AVG(
CASE WHEN B.BG_CLOSING_DATE IS NULL THEN  ALM_REPORT.DIASENTRE(B.BG_DETECTION_DATE , SYSDATE ) ELSE 
ALM_REPORT.DIASENTRE(B.BG_DETECTION_DATE , B.BG_CLOSING_DATE ) END - 1
)

FROM '||x.db_name||'.BUG    B
JOIN '||x.db_name||'.RELEASES  ON REL_ID = B.BG_TARGET_REL
JOIN '||x.db_name||'.RELEASE_CYCLES  ON RCYC_ID = BG_TARGET_RCYC
WHERE REL_ID = R.REL_ID),0) "añejamiento",

NVL((SELECT
AVG(
CASE WHEN B.BG_CLOSING_DATE IS NULL THEN  ALM_REPORT.DIASENTRE(B.BG_DETECTION_DATE , SYSDATE ) ELSE 
ALM_REPORT.DIASENTRE(B.BG_DETECTION_DATE , B.BG_CLOSING_DATE ) END -1)

FROM '||x.db_name||'.BUG    B
JOIN '||x.db_name||'.RELEASES  ON REL_ID = B.BG_TARGET_REL
JOIN '||x.db_name||'.RELEASE_CYCLES  ON RCYC_ID = BG_TARGET_RCYC
WHERE
B.BG_SEVERITY IN (''2 - Alto'',''1 - Crítico'',''4-Very High'',''5-Urgent'')
AND REL_ID = R.REL_ID),0) "Añejamiento invalidante",


to_date(RC.RCYC_USER_02,''yyyy/mm/dd'' ) "Fecha Inicio CICLO",
to_date(RC.RCYC_USER_03,''yyyy/mm/dd'' ) "Fecha Fin CICLO",

ALM_REPORT.DIASENTRE(
to_date(RC.RCYC_USER_02,''yyyy/mm/dd'' ) , to_date(RC.RCYC_USER_03,''yyyy/mm/dd'' )
) "Dias transcurridos ciclo",

NVL(
ALM_REPORT.DIASENTRE(
MIN(TC.TC_EXEC_DATE) ,
MAX(TC.TC_EXEC_DATE)
),0) "Dias transcurridos Dinamicos",

NVL((SELECT DISTINCT  MAX(RQ_USER_33)
FROM  '||x.db_name||'.REQ,  '||x.db_name||'.REQ_RELEASES 
WHERE RQ_TYPE_ID = 107 AND RQRL_RELEASE_ID = R.REL_ID and RQRL_REQ_ID = RQ_REQ_ID), 
''No tiene trazabilidad al requerimiento o se encuentra vacio'') as coordinador






-----------------------------------------------------------------------------------

FROM
 '||x.db_name||'.RELEASES R
JOIN  '||x.db_name||'.RELEASE_CYCLES RC ON RC.RCYC_PARENT_ID = R.REL_ID
LEFT JOIN  '||x.db_name||'.TESTCYCL TC ON TC.TC_ASSIGN_RCYC = RC.RCYC_ID
LEFT JOIN  '||x.db_name||'.RUN RN ON RN.RN_TESTCYCL_ID = TC.TC_TESTCYCL_ID 

/*
WHERE
R.REL_ID IN (
SELECT
R.REL_ID 
FROM
 '||x.db_name||'.RELEASES R
LEFT JOIN  '||x.db_name||'.RELEASE_CYCLES RC ON RC.RCYC_PARENT_ID = R.REL_ID
LEFT JOIN  '||x.db_name||'.TESTCYCL TC ON TC.TC_ASSIGN_RCYC = RC.RCYC_ID
WHERE
TC.TC_EXEC_DATE >= TO_DATE(01||''/''||(TO_CHAR(SYSDATE,''mm'') - 3)||''/2016'', ''dd/mm/yyyy'')   AND
TC.TC_EXEC_DATE <= TO_DATE(to_char(last_day(SYSDATE),''dd'')||''/''||TO_CHAR(SYSDATE,''mm'')||''/2016'', ''dd/mm/yyyy'')
GROUP BY  R.REL_ID)
AND
R.REL_PARENT_ID IN (SELECT RF.RF_ID FROM  '||x.db_name||'.RELEASE_FOLDERS RF  START WITH RF.RF_ID = 128 CONNECT BY PRIOR RF.RF_ID = RF_PARENT_ID)
*/

GROUP BY  R.REL_ID,  R.REL_NAME, R.REL_START_DATE ,R.REL_END_DATE ,TO_DATE(R.REL_USER_03, ''yyyy/mm/dd'' ) ,
TO_DATE(R.REL_USER_02, ''yyyy/mm/dd'' ) , RC.RCYC_NAME, RC.RCYC_ID, RC.RCYC_USER_01 ,
to_date(RC.RCYC_USER_02,''yyyy/mm/dd'' ) , to_date(RC.RCYC_USER_03,''yyyy/mm/dd'' )
 ';


end loop;




for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME from alm_siteadmin_db_12.projects where domain_name in ('PROYECTOS') and PR_IS_ACTIVE = 'Y' ) loop
execute immediate  'insert into ALM_REPORT.DATOS_ALM_VOLUMETRIA
SELECT
'''||x.db_name||'.'' || R.REL_ID "Id Version",
R.REL_NAME "Nombre Version",
R.REL_START_DATE "Fecha Replan. Inicio",
R.REL_END_DATE "Fecha Repla. Fin",
TO_DATE(R.REL_USER_01, ''yyyy/mm/dd'' ) "Fecha Inicio",
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
TC.TC_EXEC_DATE >= TO_DATE(''01/''||TO_CHAR(SYSDATE,''mm'')||''/2016'',''dd/mm/yyyy'')   AND
TC.TC_EXEC_DATE <= TO_DATE(to_char(last_day(SYSDATE),''dd'')||''/''||TO_CHAR(SYSDATE,''mm'')||''/2016'', ''dd/mm/yyyy'')
THEN TC.TC_TESTCYCL_ID END  ) "Casos Ejecutados Mes",

-------------------------------EJECUCIONES----------------------------------------
COUNT (DISTINCT CASE WHEN (RN.RN_STATUS = ''Passed'' or RN.RN_STATUS = ''Failed'')  THEN RN.RN_RUN_ID END )  "Ejecuciones Ejecutadas" ,
COUNT (DISTINCT CASE WHEN RN.RN_STATUS = ''Passed''  THEN RN.RN_RUN_ID END )  "Ejecuciones Exitosas" ,
COUNT (DISTINCT CASE WHEN RN.RN_STATUS = ''Failed''  THEN RN.RN_RUN_ID END )  "Ejecuciones Falladas" ,
COUNT (DISTINCT CASE WHEN (RN.RN_STATUS = ''Passed'' or RN.RN_STATUS = ''Failed'' ) AND
RN.RN_EXECUTION_DATE >= TO_DATE(''01/''||TO_CHAR(SYSDATE,''mm'')||''/2016'',''dd/mm/yyyy'') AND
RN.RN_EXECUTION_DATE <= TO_DATE(to_char(last_day(SYSDATE),''dd'')||''/''||TO_CHAR(SYSDATE,''mm'')||''/2016'', ''dd/mm/yyyy'')
THEN RN.RN_RUN_ID END )  "Ejecuciones Ej. Mes" ,

COUNT (DISTINCT CASE WHEN (RN.RN_STATUS = ''Passed'' or RN.RN_STATUS = ''Failed'' ) AND
RN.RN_EXECUTION_DATE >= TO_DATE(''01/''||TO_CHAR(SYSDATE,''mm'')||''/2016'',''dd/mm/yyyy'')  AND
RN.RN_EXECUTION_DATE <= TO_DATE(to_char(last_day(SYSDATE),''dd'')||''/''||TO_CHAR(SYSDATE,''mm'')||''/2016'', ''dd/mm/yyyy'') AND
UPPER(RN.RN_SUBTYPE_ID)  LIKE ''%QUICKTEST_TEST%''   THEN RN.RN_RUN_ID END )  "Ejecuciones Auto. Mes",

NVL((SELECT DISTINCT  MAX(RQ_REQ_NAME) 
FROM  '||x.db_name||'.REQ,  '||x.db_name||'.REQ_RELEASES 
WHERE RQ_TYPE_ID = 101 AND RQRL_RELEASE_ID = R.REL_ID and RQRL_REQ_ID = RQ_REQ_ID), 
''No tiene trazabilidad al requerimiento'') as requerimiento ,

NVL((SELECT DISTINCT  MAX(RQ_USER_02)
FROM  '||x.db_name||'.REQ,  '||x.db_name||'.REQ_RELEASES 
WHERE RQ_TYPE_ID = 101 AND RQRL_RELEASE_ID = R.REL_ID and RQRL_REQ_ID = RQ_REQ_ID), 
''No tiene trazabilidad al requerimiento'') as estado_requerimiento ,

'''||x.PROJECT_NAME||'''  AS esquema,

R.REL_USER_04 as jdp_qa,

RC.RCYC_USER_03 "Tipo de Ciclo",


'''||x.DOMAIN_NAME||''' as dominio,

COUNT(DISTINCT CASE WHEN TC.TC_STATUS = ''Blocked''  THEN TC.TC_TESTCYCL_ID END  ) "Casos Bloqueados",

ALM_REPORT.DIASENTRE(TO_DATE(R.REL_USER_01, ''yyyy/mm/dd'' ), sysdate) "dias transcurridos",

(SELECT COUNT(distinct BG_BUG_ID) FROM '||x.db_name||'.BUG WHERE R.REL_ID = BG_TARGET_REL) "Cantidad defectos Release",

NVL((
SELECT
SUM(
CASE WHEN ((SELECT COUNT(AP.AP_NEW_VALUE )
FROM '||x.db_name||'.AUDIT_LOG AU
JOIN '||x.db_name||'.AUDIT_PROPERTIES AP ON AP.AP_ACTION_ID = AU.AU_ACTION_ID AND AP.AP_NEW_VALUE = ''Ready to Test''
AND AP.AP_PROPERTY_NAME = ''06 - Estado''  --Retrasa los tiempos
WHERE AU.AU_ENTITY_ID = cast(B.BG_BUG_ID as varchar(200)))- 1  ) = -1 THEN 0 ELSE
((SELECT COUNT(AP.AP_NEW_VALUE )
FROM '||x.db_name||'.AUDIT_LOG AU
JOIN '||x.db_name||'.AUDIT_PROPERTIES AP ON AP.AP_ACTION_ID = AU.AU_ACTION_ID AND AP.AP_NEW_VALUE = ''Ready to Test''
AND AP.AP_PROPERTY_NAME = ''06 - Estado''  --Retrasa los tiempos
WHERE AU.AU_ENTITY_ID = cast(B.BG_BUG_ID as varchar(200)))- 1  ) END )


FROM '||x.db_name||'.BUG    B
JOIN '||x.db_name||'.RELEASES  ON REL_ID = B.BG_TARGET_REL
JOIN '||x.db_name||'.RELEASE_CYCLES  ON RCYC_ID = BG_TARGET_RCYC
WHERE REL_ID = R.REL_ID
 ) ,0) "suma iteraciones",

NVL((
SELECT
AVG(
CASE WHEN B.BG_CLOSING_DATE IS NULL THEN  ALM_REPORT.DIASENTRE(B.BG_DETECTION_DATE , SYSDATE ) ELSE 
ALM_REPORT.DIASENTRE(B.BG_DETECTION_DATE , B.BG_CLOSING_DATE ) END - 1
)

FROM '||x.db_name||'.BUG    B
JOIN '||x.db_name||'.RELEASES  ON REL_ID = B.BG_TARGET_REL
JOIN '||x.db_name||'.RELEASE_CYCLES  ON RCYC_ID = BG_TARGET_RCYC
WHERE REL_ID = R.REL_ID),0) "añejamiento",

NVL((SELECT
AVG(
CASE WHEN B.BG_CLOSING_DATE IS NULL THEN  ALM_REPORT.DIASENTRE(B.BG_DETECTION_DATE , SYSDATE ) ELSE 
ALM_REPORT.DIASENTRE(B.BG_DETECTION_DATE , B.BG_CLOSING_DATE ) END -1)

FROM '||x.db_name||'.BUG    B
JOIN '||x.db_name||'.RELEASES  ON REL_ID = B.BG_TARGET_REL
JOIN '||x.db_name||'.RELEASE_CYCLES  ON RCYC_ID = BG_TARGET_RCYC
WHERE
B.BG_SEVERITY IN (''2 - Alto'',''1 - Crítico'',''4-Very High'',''5-Urgent'')
AND REL_ID = R.REL_ID) , 0) "Añejamiento invalidante",


to_date(RC.RCYC_USER_01,''yyyy/mm/dd'' ) "Fecha Inicio CICLO",
to_date(RC.RCYC_USER_02,''yyyy/mm/dd'' ) "Fecha Fin CICLO",

ALM_REPORT.DIASENTRE(
to_date(RC.RCYC_USER_01,''yyyy/mm/dd'' ),
to_date(RC.RCYC_USER_02,''yyyy/mm/dd'' ) 
) "Dias transcurridos ciclo",

NVL(
ALM_REPORT.DIASENTRE(
MIN(TC.TC_EXEC_DATE) ,
MAX(TC.TC_EXEC_DATE)
),0) "Dias transcurridos Dinamicos",

NVL((SELECT DISTINCT  MAX(RQ_USER_12)
FROM  '||x.db_name||'.REQ,  '||x.db_name||'.REQ_RELEASES 
WHERE RQ_TYPE_ID = 101 AND RQRL_RELEASE_ID = R.REL_ID and RQRL_REQ_ID = RQ_REQ_ID), 
''No tiene trazabilidad al requerimiento o se encuentra vacio'') as coordinador


-------------------------------------------------------------------------------

FROM
 '||x.db_name||'.RELEASES R
JOIN  '||x.db_name||'.RELEASE_CYCLES RC ON RC.RCYC_PARENT_ID = R.REL_ID
LEFT JOIN  '||x.db_name||'.TESTCYCL TC ON TC.TC_ASSIGN_RCYC = RC.RCYC_ID
LEFT JOIN  '||x.db_name||'.RUN RN ON RN.RN_TESTCYCL_ID = TC.TC_TESTCYCL_ID 

GROUP BY  R.REL_ID,  R.REL_NAME, R.REL_START_DATE ,R.REL_END_DATE ,TO_DATE(R.REL_USER_01, ''yyyy/mm/dd'' ) ,
TO_DATE(R.REL_USER_02, ''yyyy/mm/dd'' ) , RC.RCYC_NAME, RC.RCYC_ID, R.REL_USER_04, RC.RCYC_USER_03,
to_date(RC.RCYC_USER_01,''yyyy/mm/dd'' ) , to_date(RC.RCYC_USER_02,''yyyy/mm/dd'' )

 ';


end loop;



for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME from alm_siteadmin_db_12.projects WHERE DB_NAME = 'proveedores_testing_sqa_db') loop
execute immediate  'insert into ALM_REPORT.DATOS_ALM_VOLUMETRIA
SELECT
'''||x.db_name||'.'' || R.REL_ID "Id Version",
R.REL_NAME "Nombre Version",
R.REL_START_DATE "Fecha Replan. Inicio",
R.REL_END_DATE "Fecha Repla. Fin",
TO_DATE(R.REL_USER_01, ''yyyy/mm/dd'' ) "Fecha Inicio",
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
TC.TC_EXEC_DATE >= TO_DATE(''01/''||TO_CHAR(SYSDATE,''mm'')||''/2016'',''dd/mm/yyyy'')   AND
TC.TC_EXEC_DATE <= TO_DATE(to_char(last_day(SYSDATE),''dd'')||''/''||TO_CHAR(SYSDATE,''mm'')||''/2016'', ''dd/mm/yyyy'')
THEN TC.TC_TESTCYCL_ID END  ) "Casos Ejecutados Mes",

-------------------------------EJECUCIONES----------------------------------------
COUNT (DISTINCT CASE WHEN (RN.RN_STATUS = ''Passed'' or RN.RN_STATUS = ''Failed'')  THEN RN.RN_RUN_ID END )  "Ejecuciones Ejecutadas" ,
COUNT (DISTINCT CASE WHEN RN.RN_STATUS = ''Passed''  THEN RN.RN_RUN_ID END )  "Ejecuciones Exitosas" ,
COUNT (DISTINCT CASE WHEN RN.RN_STATUS = ''Failed''  THEN RN.RN_RUN_ID END )  "Ejecuciones Falladas" ,
COUNT (DISTINCT CASE WHEN (RN.RN_STATUS = ''Passed'' or RN.RN_STATUS = ''Failed'' ) AND
RN.RN_EXECUTION_DATE >= TO_DATE(''01/''||TO_CHAR(SYSDATE,''mm'')||''/2016'',''dd/mm/yyyy'') AND
RN.RN_EXECUTION_DATE <= TO_DATE(to_char(last_day(SYSDATE),''dd'')||''/''||TO_CHAR(SYSDATE,''mm'')||''/2016'', ''dd/mm/yyyy'')
THEN RN.RN_RUN_ID END )  "Ejecuciones Ej. Mes" ,

COUNT (DISTINCT CASE WHEN (RN.RN_STATUS = ''Passed'' or RN.RN_STATUS = ''Failed'' ) AND
RN.RN_EXECUTION_DATE >= TO_DATE(''01/''||TO_CHAR(SYSDATE,''mm'')||''/2016'',''dd/mm/yyyy'')  AND
RN.RN_EXECUTION_DATE <= TO_DATE(to_char(last_day(SYSDATE),''dd'')||''/''||TO_CHAR(SYSDATE,''mm'')||''/2016'', ''dd/mm/yyyy'') AND
UPPER(RN.RN_SUBTYPE_ID)  LIKE ''%QUICKTEST_TEST%''   THEN RN.RN_RUN_ID END )  "Ejecuciones Auto. Mes",

NVL((SELECT DISTINCT  MAX(RQ_REQ_NAME) 
FROM  '||x.db_name||'.REQ,  '||x.db_name||'.REQ_RELEASES 
WHERE RQ_TYPE_ID = 101 AND RQRL_RELEASE_ID = R.REL_ID and RQRL_REQ_ID = RQ_REQ_ID), 
''No tiene trazabilidad al requerimiento'') as requerimiento ,

NVL((SELECT DISTINCT  MAX(RQ_USER_02)
FROM  '||x.db_name||'.REQ,  '||x.db_name||'.REQ_RELEASES 
WHERE RQ_TYPE_ID = 101 AND RQRL_RELEASE_ID = R.REL_ID and RQRL_REQ_ID = RQ_REQ_ID), 
''No tiene trazabilidad al requerimiento'') as estado_requerimiento ,

'''||x.PROJECT_NAME||'''  AS esquema,

R.REL_USER_04 as jdp_qa,

RC.RCYC_USER_03 "Tipo de Ciclo",


'''||x.DOMAIN_NAME||''' as dominio,

COUNT(DISTINCT CASE WHEN TC.TC_STATUS = ''Blocked''  THEN TC.TC_TESTCYCL_ID END  ) "Casos Bloqueados",

ALM_REPORT.DIASENTRE(TO_DATE(R.REL_USER_01, ''yyyy/mm/dd'' ), sysdate) "dias transcurridos",

(SELECT COUNT(distinct BG_BUG_ID) FROM '||x.db_name||'.BUG WHERE R.REL_ID = BG_TARGET_REL) "Cantidad defectos Release",

NVL((
SELECT
SUM(
CASE WHEN ((SELECT COUNT(AP.AP_NEW_VALUE )
FROM '||x.db_name||'.AUDIT_LOG AU
JOIN '||x.db_name||'.AUDIT_PROPERTIES AP ON AP.AP_ACTION_ID = AU.AU_ACTION_ID AND AP.AP_NEW_VALUE = ''Ready to Test''
AND AP.AP_PROPERTY_NAME = ''06 - Estado''  --Retrasa los tiempos
WHERE AU.AU_ENTITY_ID = cast(B.BG_BUG_ID as varchar(200)))- 1  ) = -1 THEN 0 ELSE
((SELECT COUNT(AP.AP_NEW_VALUE )
FROM '||x.db_name||'.AUDIT_LOG AU
JOIN '||x.db_name||'.AUDIT_PROPERTIES AP ON AP.AP_ACTION_ID = AU.AU_ACTION_ID AND AP.AP_NEW_VALUE = ''Ready to Test''
AND AP.AP_PROPERTY_NAME = ''06 - Estado''  --Retrasa los tiempos
WHERE AU.AU_ENTITY_ID = cast(B.BG_BUG_ID as varchar(200)))- 1  ) END )


FROM '||x.db_name||'.BUG    B
JOIN '||x.db_name||'.RELEASES  ON REL_ID = B.BG_TARGET_REL
JOIN '||x.db_name||'.RELEASE_CYCLES  ON RCYC_ID = BG_TARGET_RCYC
WHERE REL_ID = R.REL_ID
 ) ,0) "suma iteraciones",

NVL((
SELECT
AVG(
CASE WHEN B.BG_CLOSING_DATE IS NULL THEN  ALM_REPORT.DIASENTRE(B.BG_DETECTION_DATE , SYSDATE ) ELSE 
ALM_REPORT.DIASENTRE(B.BG_DETECTION_DATE , B.BG_CLOSING_DATE ) END - 1
)

FROM '||x.db_name||'.BUG    B
JOIN '||x.db_name||'.RELEASES  ON REL_ID = B.BG_TARGET_REL
JOIN '||x.db_name||'.RELEASE_CYCLES  ON RCYC_ID = BG_TARGET_RCYC
WHERE REL_ID = R.REL_ID),0) "añejamiento",

NVL((SELECT
AVG(
CASE WHEN B.BG_CLOSING_DATE IS NULL THEN  ALM_REPORT.DIASENTRE(B.BG_DETECTION_DATE , SYSDATE ) ELSE 
ALM_REPORT.DIASENTRE(B.BG_DETECTION_DATE , B.BG_CLOSING_DATE ) END -1)

FROM '||x.db_name||'.BUG    B
JOIN '||x.db_name||'.RELEASES  ON REL_ID = B.BG_TARGET_REL
JOIN '||x.db_name||'.RELEASE_CYCLES  ON RCYC_ID = BG_TARGET_RCYC
WHERE
B.BG_SEVERITY IN (''2 - Alto'',''1 - Crítico'',''4-Very High'',''5-Urgent'')
AND REL_ID = R.REL_ID),0) "Añejamiento invalidante",


to_date(RC.RCYC_USER_01,''yyyy/mm/dd'' ) "Fecha Inicio CICLO",
to_date(RC.RCYC_USER_02,''yyyy/mm/dd'' ) "Fecha Fin CICLO",

ALM_REPORT.DIASENTRE(
to_date(RC.RCYC_USER_01,''yyyy/mm/dd'' ) ,
to_date(RC.RCYC_USER_02,''yyyy/mm/dd'' ) 
)"Dias transcurridos ciclo",

NVL(
ALM_REPORT.DIASENTRE(
MIN(TC.TC_EXEC_DATE) ,
MAX(TC.TC_EXEC_DATE)
),0) "Dias transcurridos Dinamicos",

NVL((SELECT DISTINCT  MAX(RQ_USER_12)
FROM  '||x.db_name||'.REQ,  '||x.db_name||'.REQ_RELEASES 
WHERE RQ_TYPE_ID = 101 AND RQRL_RELEASE_ID = R.REL_ID and RQRL_REQ_ID = RQ_REQ_ID), 
''No tiene trazabilidad al requerimiento o se encuentra vacio'') as coordinador

--------------------------------------------------------------------------

FROM
 '||x.db_name||'.RELEASES R
JOIN  '||x.db_name||'.RELEASE_CYCLES RC ON RC.RCYC_PARENT_ID = R.REL_ID
LEFT JOIN  '||x.db_name||'.TESTCYCL TC ON TC.TC_ASSIGN_RCYC = RC.RCYC_ID
LEFT JOIN  '||x.db_name||'.RUN RN ON RN.RN_TESTCYCL_ID = TC.TC_TESTCYCL_ID 

GROUP BY  R.REL_ID,  R.REL_NAME, R.REL_START_DATE ,R.REL_END_DATE ,TO_DATE(R.REL_USER_01, ''yyyy/mm/dd'' ) ,
TO_DATE(R.REL_USER_02, ''yyyy/mm/dd'' ) , RC.RCYC_NAME, RC.RCYC_ID, R.REL_USER_04, RC.RCYC_USER_03, 
to_date(RC.RCYC_USER_01,''yyyy/mm/dd'' ) , to_date(RC.RCYC_USER_02,''yyyy/mm/dd'' )

';


end loop;

end;


/
