--------------------------------------------------------
--  DDL for Procedure cargarProyectosAgiles
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ALM_REPORT"."cargarProyectosAgiles" AS
BEGIN
execute immediate 'TRUNCATE TABLE ALM_REPORT.PROYECTOS_AGILES';
for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME from alm_siteadmin_db_12.projects where DOMAIN_NAME = 'QA') loop
execute immediate 'insert into ALM_REPORT.PROYECTOS_AGILES
SELECT
DISTINCT
R.REL_NAME,
R.REL_ID,
''Nueva Internet'' as proyecto,
RC.RCYC_ID "Id Ciclo",
RC.RCYC_NAME,

COUNT(DISTINCT TC.TC_TESTCYCL_ID) "Casos Definidos",
COUNT(DISTINCT CASE WHEN (TC.TC_STATUS = ''Passed'' OR TC.TC_STATUS = ''Failed''  OR
TC.TC_STATUS = ''Blocked'' ) THEN TC.TC_TESTCYCL_ID END  ) "Casos Ejecutados",
COUNT(DISTINCT CASE WHEN TC.TC_STATUS = ''Passed''  THEN TC.TC_TESTCYCL_ID END  ) "Casos Exitosos",
COUNT(DISTINCT CASE WHEN TC.TC_STATUS = ''Failed''  THEN TC.TC_TESTCYCL_ID END  ) "Casos Fallados",
COUNT(DISTINCT CASE WHEN TC.TC_STATUS = ''Blocked''  THEN TC.TC_TESTCYCL_ID END  ) "Casos Bloqueados",


to_date(RC.RCYC_USER_01,''yyyy/mm/dd'' ) "Fecha Inicio",
to_date(RC.RCYC_USER_02,''yyyy/mm/dd'' ) "Fecha Fin",
R.REL_START_DATE "Fecha Replan. Inicio",
R.REL_END_DATE "Fecha Repla. Fin",


NVL((SELECT DISTINCT  MAX(RQ_USER_05)
FROM  '||x.db_name||'.REQ,  '||x.db_name||'.REQ_RELEASES
WHERE RQ_TYPE_ID = 103 AND RQRL_RELEASE_ID = R.REL_ID and RQRL_REQ_ID = RQ_REQ_ID and RQ_USER_02 not in (''Rechazado'')),
''No tiene trazabilidad al requerimiento'') as estado_requerimiento,


MIN(TC.TC_EXEC_DATE) "Inicio Etapa Dinamica",
MAX(TC.TC_EXEC_DATE) "Fin Etapa Dinamica",

R.REL_USER_05 "jpqa",



ALM_REPORT.DIASENTRE(TO_DATE(RC.RCYC_USER_01 , ''yyyy/mm/dd''), TO_DATE(RC.RCYC_USER_02 , ''yyyy/mm/dd'')) "Dias Diferencia",

ALM_REPORT.DIASENTRE(TO_DATE(RC.RCYC_USER_01 , ''yyyy/mm/dd''),
CASE WHEN  TO_DATE(RC.RCYC_USER_02 , ''yyyy/mm/dd'') > sysdate
THEN sysdate ELSE TO_DATE(RC.RCYC_USER_02 , ''yyyy/mm/dd'') END
) "Dias Diferencia Hoy",

RF.RF_NAME ,

(SELECT COUNT(DISTINCT RQ_REQ_ID) 
FROM '||x.db_name||'.REQ 
JOIN '||x.db_name||'.REQ_RELEASES ON RQRL_REQ_ID = RQ_REQ_ID
WHERE 
RQRL_RELEASE_ID = R.REL_ID ) "Historias"



FROM '||x.db_name||'.RELEASE_FOLDERS RF
LEFT JOIN '||x.db_name||'.RELEASES R ON R.REL_PARENT_ID = RF.RF_ID
LEFT JOIN '||x.db_name||'.RELEASE_CYCLES RC ON RC.RCYC_PARENT_ID = R.REL_ID
LEFT JOIN '||x.db_name||'.TESTCYCL TC ON TC.TC_ASSIGN_RCYC = RC.RCYC_ID

WHERE R.REL_NAME != '' ''

START WITH RF.RF_ID = 105
CONNECT BY PRIOR RF.RF_ID = RF_PARENT_ID

GROUP BY
R.REL_NAME,
R.REL_ID,
RC.RCYC_ID ,
RC.RCYC_NAME,
to_date(RC.RCYC_USER_01,''yyyy/mm/dd'' ) ,
to_date(RC.RCYC_USER_02,''yyyy/mm/dd'' ) ,
R.REL_START_DATE ,
R.REL_END_DATE ,
R.REL_USER_05 ,
RF.RF_NAME


UNION ALL

SELECT
DISTINCT
R.REL_NAME,
R.REL_ID,
''Plataformas'' as proyecto,
RC.RCYC_ID "Id Ciclo",
RC.RCYC_NAME,

COUNT(DISTINCT TC.TC_TESTCYCL_ID) "Casos Definidos",
COUNT(DISTINCT CASE WHEN (TC.TC_STATUS = ''Passed'' OR TC.TC_STATUS = ''Failed''  OR
TC.TC_STATUS = ''Blocked'' ) THEN TC.TC_TESTCYCL_ID END  ) "Casos Ejecutados",
COUNT(DISTINCT CASE WHEN TC.TC_STATUS = ''Passed''  THEN TC.TC_TESTCYCL_ID END  ) "Casos Exitosos",
COUNT(DISTINCT CASE WHEN TC.TC_STATUS = ''Failed''  THEN TC.TC_TESTCYCL_ID END  ) "Casos Fallados",
COUNT(DISTINCT CASE WHEN TC.TC_STATUS = ''Blocked''  THEN TC.TC_TESTCYCL_ID END  ) "Casos Bloqueados",


to_date(RC.RCYC_USER_01,''yyyy/mm/dd'' ) "Fecha Inicio",
to_date(RC.RCYC_USER_02,''yyyy/mm/dd'' ) "Fecha Fin",
R.REL_START_DATE "Fecha Replan. Inicio",
R.REL_END_DATE "Fecha Repla. Fin",


NVL((SELECT DISTINCT  MAX(RQ_USER_05)
FROM  '||x.db_name||'.REQ,  '||x.db_name||'.REQ_RELEASES
WHERE RQ_TYPE_ID = 103 AND RQRL_RELEASE_ID = R.REL_ID and RQRL_REQ_ID = RQ_REQ_ID and RQ_USER_02 not in (''Rechazado'')),
''No tiene trazabilidad al requerimiento'') as estado_requerimiento,


MIN(TC.TC_EXEC_DATE) "Inicio Etapa Dinamica",
MAX(TC.TC_EXEC_DATE) "Fin Etapa Dinamica",

R.REL_USER_05 "jpqa",



ALM_REPORT.DIASENTRE(TO_DATE(RC.RCYC_USER_01 , ''yyyy/mm/dd''), TO_DATE(RC.RCYC_USER_02 , ''yyyy/mm/dd'')) "Dias Diferencia",

ALM_REPORT.DIASENTRE(TO_DATE(RC.RCYC_USER_01 , ''yyyy/mm/dd''),
CASE WHEN  TO_DATE(RC.RCYC_USER_02 , ''yyyy/mm/dd'') > sysdate
THEN sysdate ELSE TO_DATE(RC.RCYC_USER_02 , ''yyyy/mm/dd'') END
) "Dias Diferencia Hoy",

RF.RF_NAME ,

(SELECT COUNT(DISTINCT RQ_REQ_ID) 
FROM '||x.db_name||'.REQ 
JOIN '||x.db_name||'.REQ_RELEASES ON RQRL_REQ_ID = RQ_REQ_ID
WHERE 
RQRL_RELEASE_ID = R.REL_ID ) "Historias"

FROM '||x.db_name||'.RELEASE_FOLDERS RF
LEFT JOIN '||x.db_name||'.RELEASES R ON R.REL_PARENT_ID = RF.RF_ID
LEFT JOIN '||x.db_name||'.RELEASE_CYCLES RC ON RC.RCYC_PARENT_ID = R.REL_ID
LEFT JOIN '||x.db_name||'.TESTCYCL TC ON TC.TC_ASSIGN_RCYC = RC.RCYC_ID

WHERE R.REL_NAME != '' ''

START WITH RF.RF_ID = 150
CONNECT BY PRIOR RF.RF_ID = RF_PARENT_ID

GROUP BY
R.REL_NAME,
R.REL_ID,
RC.RCYC_ID ,
RC.RCYC_NAME,
to_date(RC.RCYC_USER_01,''yyyy/mm/dd'' ) ,
to_date(RC.RCYC_USER_02,''yyyy/mm/dd'' ) ,
R.REL_START_DATE ,
R.REL_END_DATE ,
R.REL_USER_05 ,
RF.RF_NAME
';

end loop;

END;

/
