--------------------------------------------------------
--  DDL for Procedure VOLUMETRIA_PROYECTOS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ALM_REPORT"."VOLUMETRIA_PROYECTOS" AS
BEGIN
execute immediate 'TRUNCATE TABLE ALM_REPORT.T_volumetria';

for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME from alm_siteadmin_db_12.projects where DB_NAME = 'bch_qa_certificación_bch_qa_d') loop
execute immediate  '
insert into ALM_REPORT.T_volumetria 
SELECT * FROM (
SELECT 
DISTINCT 
RC.RCYC_ID,
R.REL_ID as ID,
R.REL_NAME "Nombre Release",
RC.RCYC_Name,
R.REL_USER_01 "ART",

COUNT(DISTINCT TC.TC_TESTCYCL_ID) "Casos Definidos",
COUNT(DISTINCT CASE WHEN (TC.TC_STATUS = ''Passed'' OR TC.TC_STATUS = ''Failed''  OR TC.TC_STATUS = ''Not Completed'' OR
TC.TC_STATUS = ''Blocked'' ) THEN TC.TC_TESTCYCL_ID END  ) "Casos Ejecutados",

COUNT(DISTINCT CASE WHEN TC.TC_STATUS = ''Passed''  THEN TC.TC_TESTCYCL_ID END  ) "Casos Exitosos",

COUNT(DISTINCT CASE WHEN (TC.TC_STATUS = ''Passed'' OR TC.TC_STATUS = ''Failed'' OR TC.TC_STATUS = ''Not Completed'' OR
TC.TC_STATUS = ''Blocked'') AND
TC.TC_EXEC_DATE >= TO_DATE(''01/''||TO_CHAR(SYSDATE,''mm'')||''/2016'',''dd/mm/yyyy'')   AND
TC.TC_EXEC_DATE <= TO_DATE(to_char(last_day(SYSDATE),''dd'')||''/''||TO_CHAR(SYSDATE,''mm'')||''/2016'', ''dd/mm/yyyy'')
THEN TC.TC_TESTCYCL_ID END  ) "Casos Ejecutados Mes",

COUNT (DISTINCT CASE WHEN (RN.RN_STATUS = ''Passed'' or RN.RN_STATUS = ''Failed'')  THEN RN.RN_RUN_ID END )  "Total Ejecuciones",

COUNT(DISTINCT CASE WHEN TC.TC_STATUS = ''Failed''  THEN TC.TC_TESTCYCL_ID END  ) "Ejecuciones Fallados",

COUNT (DISTINCT CASE WHEN (RN.RN_STATUS = ''Passed'' or RN.RN_STATUS = ''Failed'' ) AND
RN.RN_EXECUTION_DATE >= TO_DATE(''01/''||TO_CHAR(SYSDATE,''mm'')||''/2016'',''dd/mm/yyyy'') AND
RN.RN_EXECUTION_DATE <= TO_DATE(to_char(last_day(SYSDATE),''dd'')||''/''||TO_CHAR(SYSDATE,''mm'')||''/2016'', ''dd/mm/yyyy'')
THEN RN.RN_RUN_ID END )  "Ejecuciones Ej. Mes" ,

COUNT (DISTINCT 
CASE WHEN (RN.RN_STATUS = ''Passed'' or RN.RN_STATUS = ''Failed'' ) 
AND RN.RN_EXECUTION_DATE >= TO_DATE(''01/''||TO_CHAR(SYSDATE,''mm'')||''/2016'',''dd/mm/yyyy'')  
AND RN.RN_EXECUTION_DATE <= TO_DATE(to_char(last_day(SYSDATE),''dd'')||''/''||TO_CHAR(SYSDATE,''mm'')||''/2016'', ''dd/mm/yyyy'') 
AND UPPER(RN.RN_SUBTYPE_ID)  
LIKE ''%QUICKTEST_TEST%''  
THEN RN.RN_RUN_ID END )  "Ejecuciones Auto. Mes",

case 
when COUNT (BUG.BG_BUG_ID)=0 and ANE.PROM_DIAS_ANE>=1 then -1
else COUNT (BUG.BG_BUG_ID) end  as "Cantidad defectos Release",

NVL((
SELECT
SUM(
CASE WHEN ((SELECT COUNT(AP.AP_NEW_VALUE)
FROM '||x.db_name||'.AUDIT_LOG AU
JOIN '||x.db_name||'.AUDIT_PROPERTIES AP ON AP.AP_ACTION_ID = AU.AU_ACTION_ID AND AP.AP_NEW_VALUE = ''Ready to Test''
AND AP.AP_PROPERTY_NAME = ''06 - Estado''  --Retrasa los tiempos
WHERE AU.AU_ENTITY_ID = cast(B.BG_BUG_ID as varchar(200)))- 1  ) = -1 THEN 0 ELSE
((SELECT COUNT(AP.AP_NEW_VALUE )
FROM '||x.db_name||'.AUDIT_LOG AU
JOIN '||x.db_name||'.AUDIT_PROPERTIES AP ON AP.AP_ACTION_ID = AU.AU_ACTION_ID AND AP.AP_NEW_VALUE = ''Ready to Test''
AND AP.AP_PROPERTY_NAME = ''06 - Estado''  --Retrasa los tiempos
WHERE AU.AU_ENTITY_ID = cast(B.BG_BUG_ID as varchar(200)))- 1  ) END )
 
FROM '||x.db_name||'.BUG  B
JOIN '||x.db_name||'.RELEASES  ON REL_ID = B.BG_TARGET_REL
JOIN '||x.db_name||'.RELEASE_CYCLES  ON RCYC_ID = BG_TARGET_RCYC
) ,0) "suma iteraciones",

NVL(ANE.PROM_DIAS_ANE,0) "A¿ejamiento",
NVL(ANE_INVA.PROM_DIAS_ANE,0) "A¿ejamiento_INVALIDANTE",

'''||x.DOMAIN_NAME||'''  as Esquema,
    
'''||x.DOMAIN_NAME||'''  as Dominio
---------------------------------------------------------------------------------------------------------------------------------
FROM '||x.db_name||'.RELEASES R
LEFT JOIN  '||x.db_name||'.RELEASE_CYCLES RC ON RC.RCYC_PARENT_ID = R.REL_ID
LEFT JOIN  '||x.db_name||'.BUG BUG ON BUG.BG_DETECTED_IN_RCYC = RC.RCYC_ID
LEFT JOIN  '||x.db_name||'.TESTCYCL TC ON TC.TC_ASSIGN_RCYC = RC.RCYC_ID
LEFT JOIN  '||x.db_name||'.RUN RN ON RN.RN_TESTCYCL_ID = TC.TC_TESTCYCL_ID 
LEFT JOIN  '||x.db_name||'.TEST TS ON TS.TS_TEST_ID=RN.RN_RUN_ID
LEFT JOIN  '||x.db_name||'.ALL_LISTS AL ON TS.TS_SUBJECT=AL.AL_ITEM_ID

LEFT JOIN (SELECT REL_ID,
AVG(CASE 
    WHEN B.BG_CLOSING_DATE IS NULL THEN  DIASENTRE(B.BG_DETECTION_DATE , SYSDATE ) -1
    ELSE DIASENTRE(B.BG_DETECTION_DATE , B.BG_CLOSING_DATE ) END - 1) AS PROM_DIAS_ANE
 
FROM '||x.db_name||'.BUG    B
INNER JOIN '||x.db_name||'.RELEASES  ON REL_ID = B.BG_TARGET_REL
GROUP BY REL_ID) ANE ON 
ANE.REL_ID=R.REL_ID

LEFT JOIN (SELECT REL_ID,
			AVG(CASE 
			WHEN B.BG_CLOSING_DATE IS NULL THEN  DIASENTRE(B.BG_DETECTION_DATE , SYSDATE ) -1
			ELSE DIASENTRE(B.BG_DETECTION_DATE , B.BG_CLOSING_DATE ) END - 1) AS PROM_DIAS_ANE
 
			FROM '||x.db_name||'.BUG    B
			INNER JOIN '||x.db_name||'.RELEASES  ON REL_ID = B.BG_TARGET_REL
			where B.BG_SEVERITY in (''2 - Alto'',''1 - Cr¿tico'',''4-Very High'',''5-Urgent'')
			GROUP BY REL_ID)  ANE_INVA ON 
ANE_INVA.REL_ID=R.REL_ID


WHERE 
RN.RN_SUBTYPE_ID  LIKE ''%QUICKTEST_TEST%'' 

GROUP BY
RC.RCYC_ID,
r.rel_id,
R.REL_NAME,
RC.RCYC_Name,
R.REL_USER_01,
BUG.BG_BUG_ID,
ANE.PROM_DIAS_ANE,
ANE_INVA.PROM_DIAS_ANE)
 
';

end loop;

end;

/
