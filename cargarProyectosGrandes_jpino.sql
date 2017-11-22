--------------------------------------------------------
--  DDL for Procedure cargarProyectosGrandes_jpino
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ALM_REPORT"."cargarProyectosGrandes_jpino" AS
BEGIN

execute immediate  'TRUNCATE TABLE ALM_REPORT.PROYECTOS_GRANDES_JPINO';
for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME from alm_siteadmin_db_12.projects where domain_name in ('PROYECTOS') and PR_IS_ACTIVE = 'Y' ) loop
execute immediate  'insert into ALM_REPORT.PROYECTOS_GRANDES_JPINO
SELECT
'''||x.PROJECT_NAME||'''  AS esquema,
'''||x.DOMAIN_NAME||''' as dominio,
R.REL_NAME "Nombre Version",
'''||x.db_name||'.'' || R.REL_ID "Id Version",
'''||x.db_name||'.'' || RC.RCYC_ID "Id Ciclo",
RC.RCYC_NAME "Nombre Ciclo",
COUNT(DISTINCT TC.TC_TESTCYCL_ID) "Casos Definidos",
COUNT(DISTINCT CASE WHEN TC.TC_STATUS = ''Passed''  THEN TC.TC_TESTCYCL_ID END  ) "Casos Exitosos",
ALM_REPORT.DIASENTRE(TO_DATE(RC.RCYC_USER_01 , ''yyyy/mm/dd''), TO_DATE(RC.RCYC_USER_02 , ''yyyy/mm/dd'')) "Dias Diferencia",
to_date(RC.RCYC_USER_01,''yyyy/mm/dd'' ) "Fecha Inicio",
to_date(RC.RCYC_USER_02,''yyyy/mm/dd'' ) "Fecha Fin",
R.REL_START_DATE "Fecha Replan. Inicio",
R.REL_END_DATE "Fecha Repla. Fin",

COUNT(DISTINCT CASE WHEN (TC.TC_STATUS = ''Passed'' OR TC.TC_STATUS = ''Failed''  OR
TC.TC_STATUS = ''Blocked'' ) THEN TC.TC_TESTCYCL_ID END  ) "Casos Ejecutados",

ALM_REPORT.DIASENTRE(TO_DATE(RC.RCYC_USER_01 , ''yyyy/mm/dd''), 

CASE WHEN  TO_DATE(RC.RCYC_USER_02 , ''yyyy/mm/dd'') > sysdate
THEN sysdate ELSE TO_DATE(RC.RCYC_USER_02 , ''yyyy/mm/dd'') END

) "Dias Diferencia Hoy",

NVL((SELECT DISTINCT  MAX(RQ_USER_02)
FROM  '||x.db_name||'.REQ,  '||x.db_name||'.REQ_RELEASES 
WHERE RQ_TYPE_ID = 108 AND RQRL_RELEASE_ID = R.REL_ID and RQRL_REQ_ID = RQ_REQ_ID and RQ_USER_02 not in (''Rechazado'')), 
''No tiene trazabilidad al requerimiento'') as estado_requerimiento,
MIN(TC.TC_EXEC_DATE) "Inicio Etapa Dinamica",
MAX(TC.TC_EXEC_DATE) "Fin Etapa Dinamica",

R.REL_USER_04 "jpqa",

COUNT(DISTINCT CASE WHEN TC.TC_STATUS = ''Failed''  THEN TC.TC_TESTCYCL_ID END  ) "Casos Fallados",
COUNT(DISTINCT CASE WHEN TC.TC_STATUS = ''Blocked''  THEN TC.TC_TESTCYCL_ID END  ) "Casos Bloqueados",

NVL((SELECT DISTINCT  MAX(RQ_USER_12)
FROM  '||x.db_name||'.REQ,  '||x.db_name||'.REQ_RELEASES 
WHERE RQ_TYPE_ID = 108 AND RQRL_RELEASE_ID = R.REL_ID and RQRL_REQ_ID = RQ_REQ_ID), 
''No tiene trazabilidad al requerimiento o se encuentra vacio'') as coordinador

------------------------------------------------------------------------------------


FROM
 '||x.db_name||'.RELEASES R
JOIN  '||x.db_name||'.RELEASE_CYCLES RC ON RC.RCYC_PARENT_ID = R.REL_ID
LEFT JOIN  '||x.db_name||'.TESTCYCL TC ON TC.TC_ASSIGN_RCYC = RC.RCYC_ID
LEFT JOIN  '||x.db_name||'.REQ_RELEASES RR ON R.REL_ID = RR.RQRL_RELEASE_ID
LEFT JOIN  '||x.db_name||'.REQ RQ ON RQ.RQ_REQ_ID = RR.RQRL_REQ_ID
LEFT JOIN  '||x.db_name||'.REQ_TYPE RT ON RQ_TYPE_ID = RT.TPR_TYPE_ID

WHERE
R.REL_ID IN (
SELECT
R.REL_ID 
FROM
 '||x.db_name||'.RELEASES R
LEFT JOIN  '||x.db_name||'.RELEASE_CYCLES RC ON RC.RCYC_PARENT_ID = R.REL_ID
LEFT JOIN  '||x.db_name||'.TESTCYCL TC ON TC.TC_ASSIGN_RCYC = RC.RCYC_ID
WHERE
TC.TC_EXEC_DATE >= TO_DATE(''01/''||TO_CHAR(SYSDATE,''mm'')||''/2016'',''dd/mm/yyyy'')   AND
TC.TC_EXEC_DATE <= TO_DATE(to_char(last_day(SYSDATE),''dd'')||''/''||TO_CHAR(SYSDATE,''mm'')||''/2016'', ''dd/mm/yyyy'')
GROUP BY  R.REL_ID)

HAVING

NVL((SELECT DISTINCT  MAX(RQ_USER_02)
FROM  '||x.db_name||'.REQ,  '||x.db_name||'.REQ_RELEASES 
WHERE RQ_TYPE_ID = 108 AND RQRL_RELEASE_ID = R.REL_ID and RQRL_REQ_ID = RQ_REQ_ID), 
''No tiene trazabilidad al requerimiento'') NOT IN (''Términado QA'',''Finalizado'',''En Producción'',''Cerrado QA'',''Traspaso a Continuidad'',''Cancelado'') 

AND RQ.RQ_TYPE_ID = 108

GROUP BY  
R.REL_NAME, R.REL_ID,  
RC.RCYC_ID, RC.RCYC_NAME,
to_date(RC.RCYC_USER_01,''yyyy/mm/dd'' ), to_date(RC.RCYC_USER_02,''yyyy/mm/dd'' ),
R.REL_START_DATE ,R.REL_END_DATE ,R.REL_USER_04,RQ.RQ_TYPE_ID';


end loop;


for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME from alm_siteadmin_db_12.projects where DB_NAME = 'bch_qcsitebch_db') loop
execute immediate  'insert into ALM_REPORT.PROYECTOS_GRANDES_JPINO
SELECT
'''||x.PROJECT_NAME||'''  AS esquema,
'''||x.DOMAIN_NAME||''' as dominio,
R.REL_NAME "Nombre Version",
'''||x.db_name||'.'' || R.REL_ID "Id Version",
'''||x.db_name||'.'' || RC.RCYC_ID "Id Ciclo",
RC.RCYC_NAME "Nombre Ciclo",
COUNT(DISTINCT TC.TC_TESTCYCL_ID) "Casos Definidos",
COUNT(DISTINCT CASE WHEN TC.TC_STATUS = ''Passed''  THEN TC.TC_TESTCYCL_ID END  ) "Casos Exitosos",
ALM_REPORT.DIASENTRE(TO_DATE(RC.RCYC_USER_02 , ''yyyy/mm/dd''), TO_DATE(RC.RCYC_USER_03 , ''yyyy/mm/dd'')) "Dias Diferencia",
to_date(RC.RCYC_USER_02,''yyyy/mm/dd'' ) "Fecha Inicio",
to_date(RC.RCYC_USER_03,''yyyy/mm/dd'' ) "Fecha Fin",
R.REL_START_DATE "Fecha Replan. Inicio",
R.REL_END_DATE "Fecha Repla. Fin",

COUNT(DISTINCT CASE WHEN (TC.TC_STATUS = ''Passed'' OR TC.TC_STATUS = ''Failed''  OR
TC.TC_STATUS = ''Blocked'' ) THEN TC.TC_TESTCYCL_ID END  ) "Casos Ejecutados",

ALM_REPORT.DIASENTRE(TO_DATE(RC.RCYC_USER_02 , ''yyyy/mm/dd''), 

CASE WHEN  TO_DATE(RC.RCYC_USER_03 , ''yyyy/mm/dd'') > sysdate
THEN sysdate ELSE TO_DATE(RC.RCYC_USER_03 , ''yyyy/mm/dd'') END

) "Dias Diferencia Hoy",


NVL((SELECT DISTINCT  RQ_USER_04
FROM  '||x.db_name||'.REQ,  '||x.db_name||'.REQ_RELEASES 
WHERE RQ_TYPE_ID = 107 AND RQRL_RELEASE_ID = R.REL_ID and RQRL_REQ_ID = RQ_REQ_ID and RQ_USER_02 not in (''Rechazado'')), 
''No tiene trazabilidad al requerimiento'') as estado_requerimiento,

MIN(TC.TC_EXEC_DATE) "Inicio Etapa Dinamica",
MAX(TC.TC_EXEC_DATE) "Fin Etapa Dinamica",

NVL((SELECT DISTINCT  RQ_USER_03
FROM  '||x.db_name||'.REQ,  '||x.db_name||'.REQ_RELEASES 
WHERE RQ_TYPE_ID = 107 AND RQRL_RELEASE_ID = R.REL_ID and RQRL_REQ_ID = RQ_REQ_ID), 
''No tiene trazabilidad al requerimiento'') as jdp_qa,

COUNT(DISTINCT CASE WHEN TC.TC_STATUS = ''Failed''  THEN TC.TC_TESTCYCL_ID END  ) "Casos Fallados",
COUNT(DISTINCT CASE WHEN TC.TC_STATUS = ''Blocked''  THEN TC.TC_TESTCYCL_ID END  ) "Casos Bloqueados",

NVL((SELECT DISTINCT  RQ_USER_33
FROM  '||x.db_name||'.REQ,  '||x.db_name||'.REQ_RELEASES 
WHERE RQ_TYPE_ID = 107 AND RQRL_RELEASE_ID = R.REL_ID and RQRL_REQ_ID = RQ_REQ_ID), 
''No tiene trazabilidad al requerimiento o se encuentra vacio'') as coordinador



---------------------------------------------------------------------------------------

FROM
 '||x.db_name||'.RELEASES R
JOIN  '||x.db_name||'.RELEASE_CYCLES RC ON RC.RCYC_PARENT_ID = R.REL_ID
LEFT JOIN  '||x.db_name||'.TESTCYCL TC ON TC.TC_ASSIGN_RCYC = RC.RCYC_ID

WHERE
R.REL_ID IN (
SELECT
R.REL_ID 
FROM
 '||x.db_name||'.RELEASES R
LEFT JOIN  '||x.db_name||'.RELEASE_CYCLES RC ON RC.RCYC_PARENT_ID = R.REL_ID
LEFT JOIN  '||x.db_name||'.TESTCYCL TC ON TC.TC_ASSIGN_RCYC = RC.RCYC_ID
WHERE
TC.TC_EXEC_DATE >= TO_DATE(''01/''||TO_CHAR(SYSDATE,''mm'')||''/2016'',''dd/mm/yyyy'')   AND
TC.TC_EXEC_DATE <= TO_DATE(to_char(last_day(SYSDATE),''dd'')||''/''||TO_CHAR(SYSDATE,''mm'')||''/2016'', ''dd/mm/yyyy'')
GROUP BY  R.REL_ID)
AND
R.REL_PARENT_ID IN (SELECT RF.RF_ID FROM  '||x.db_name||'.RELEASE_FOLDERS RF  START WITH RF.RF_ID = 128 CONNECT BY PRIOR RF.RF_ID = RF_PARENT_ID)

HAVING

NVL((SELECT DISTINCT  RQ_USER_04
FROM  '||x.db_name||'.REQ,  '||x.db_name||'.REQ_RELEASES 
WHERE RQ_TYPE_ID = 107 AND RQRL_RELEASE_ID = R.REL_ID and RQRL_REQ_ID = RQ_REQ_ID), 
''No tiene trazabilidad al requerimiento'')  NOT IN (''Términado QA'',''Finalizado'',''En Producción'',''Cerrado QA'',''Traspaso a Continuidad'',''Cancelado'')
AND
NVL((SELECT DISTINCT  RQ_USER_03
FROM  '||x.db_name||'.REQ,  '||x.db_name||'.REQ_RELEASES 
WHERE RQ_TYPE_ID = 107 AND RQRL_RELEASE_ID = R.REL_ID and RQRL_REQ_ID = RQ_REQ_ID), 
''No tiene trazabilidad al requerimiento'') = ''jpino''


GROUP BY  
R.REL_NAME, R.REL_ID,  
RC.RCYC_ID, RC.RCYC_NAME,
to_date(RC.RCYC_USER_02,''yyyy/mm/dd'' ), to_date(RC.RCYC_USER_03,''yyyy/mm/dd'' ),
R.REL_START_DATE ,R.REL_END_DATE ';
end loop;

for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME from alm_siteadmin_db_12.projects WHERE DB_NAME = 'proveedores_testing_sqa_db') loop
execute immediate  'insert into ALM_REPORT.PROYECTOS_GRANDES_JPINO
SELECT
'''||x.PROJECT_NAME||'''  AS esquema,
'''||x.DOMAIN_NAME||''' as dominio,
R.REL_NAME "Nombre Version",
'''||x.db_name||'.'' || R.REL_ID "Id Version",
'''||x.db_name||'.'' || RC.RCYC_ID "Id Ciclo",
RC.RCYC_NAME "Nombre Ciclo",
COUNT(DISTINCT TC.TC_TESTCYCL_ID) "Casos Definidos",
COUNT(DISTINCT CASE WHEN TC.TC_STATUS = ''Passed''  THEN TC.TC_TESTCYCL_ID END  ) "Casos Exitosos",
ALM_REPORT.DIASENTRE(TO_DATE(RC.RCYC_USER_01 , ''yyyy/mm/dd''), TO_DATE(RC.RCYC_USER_02 , ''yyyy/mm/dd'')) "Dias Diferencia",
to_date(RC.RCYC_USER_01,''yyyy/mm/dd'' ) "Fecha Inicio",
to_date(RC.RCYC_USER_02,''yyyy/mm/dd'' ) "Fecha Fin",
R.REL_START_DATE "Fecha Replan. Inicio",
R.REL_END_DATE "Fecha Repla. Fin",

COUNT(DISTINCT CASE WHEN (TC.TC_STATUS = ''Passed'' OR TC.TC_STATUS = ''Failed''  OR
TC.TC_STATUS = ''Blocked'' ) THEN TC.TC_TESTCYCL_ID END  ) "Casos Ejecutados",

ALM_REPORT.DIASENTRE(TO_DATE(RC.RCYC_USER_01 , ''yyyy/mm/dd''), 

CASE WHEN  TO_DATE(RC.RCYC_USER_02 , ''yyyy/mm/dd'') > sysdate
THEN sysdate ELSE TO_DATE(RC.RCYC_USER_02 , ''yyyy/mm/dd'') END

) "Dias Diferencia Hoy",

NVL((SELECT DISTINCT  MAX(RQ_USER_02)
FROM  '||x.db_name||'.REQ,  '||x.db_name||'.REQ_RELEASES 
WHERE RQ_TYPE_ID = 101 AND RQRL_RELEASE_ID = R.REL_ID and RQRL_REQ_ID = RQ_REQ_ID and RQ_USER_02 not in (''Rechazado'')), 
''No tiene trazabilidad al requerimiento'') as estado_requerimiento,

MIN(TC.TC_EXEC_DATE) "Inicio Etapa Dinamica",
MAX(TC.TC_EXEC_DATE) "Fin Etapa Dinamica",

R.REL_USER_04 "jpqa",

COUNT(DISTINCT CASE WHEN TC.TC_STATUS = ''Failed''  THEN TC.TC_TESTCYCL_ID END  ) "Casos Fallados",
COUNT(DISTINCT CASE WHEN TC.TC_STATUS = ''Blocked''  THEN TC.TC_TESTCYCL_ID END  ) "Casos Bloqueados",

NVL((SELECT DISTINCT  RQ_USER_12
FROM  '||x.db_name||'.REQ,  '||x.db_name||'.REQ_RELEASES 
WHERE RQ_TYPE_ID = 101 AND RQRL_RELEASE_ID = R.REL_ID and RQRL_REQ_ID = RQ_REQ_ID), 
''No tiene trazabilidad al requerimiento o se encuentra vacio'') as coordinador

------------------------------------------------------------------------------


FROM
 '||x.db_name||'.RELEASES R
JOIN  '||x.db_name||'.RELEASE_CYCLES RC ON RC.RCYC_PARENT_ID = R.REL_ID
LEFT JOIN  '||x.db_name||'.TESTCYCL TC ON TC.TC_ASSIGN_RCYC = RC.RCYC_ID

WHERE
R.REL_ID IN (
SELECT
R.REL_ID 
FROM
 '||x.db_name||'.RELEASES R
LEFT JOIN  '||x.db_name||'.RELEASE_CYCLES RC ON RC.RCYC_PARENT_ID = R.REL_ID
LEFT JOIN  '||x.db_name||'.TESTCYCL TC ON TC.TC_ASSIGN_RCYC = RC.RCYC_ID
WHERE
TC.TC_EXEC_DATE >= TO_DATE(''01/''||TO_CHAR(SYSDATE,''mm'')||''/2016'',''dd/mm/yyyy'')   AND
TC.TC_EXEC_DATE <= TO_DATE(to_char(last_day(SYSDATE),''dd'')||''/''||TO_CHAR(SYSDATE,''mm'')||''/2016'', ''dd/mm/yyyy'')
GROUP BY  R.REL_ID)

HAVING

NVL((SELECT DISTINCT  MAX(RQ_USER_02)
FROM  '||x.db_name||'.REQ,  '||x.db_name||'.REQ_RELEASES 
WHERE RQ_TYPE_ID = 101 AND RQRL_RELEASE_ID = R.REL_ID and RQRL_REQ_ID = RQ_REQ_ID), 
''No tiene trazabilidad al requerimiento'') NOT IN (''Términado QA'',''Finalizado'',''En Producción'',''Cerrado QA'',''Traspaso a Continuidad'',''Cancelado'')
AND
R.REL_USER_04 = ''jpino''

GROUP BY  
R.REL_NAME, R.REL_ID,  
RC.RCYC_ID, RC.RCYC_NAME,
to_date(RC.RCYC_USER_01,''yyyy/mm/dd'' ), to_date(RC.RCYC_USER_02,''yyyy/mm/dd'' ),
R.REL_START_DATE ,R.REL_END_DATE, R.REL_USER_04 ';

end loop;

for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME from alm_siteadmin_db_12.projects WHERE DB_NAME = 'bch_qa_certificación_bch_qa_d') loop
execute immediate  'insert into ALM_REPORT.PROYECTOS_GRANDES_JPINO
SELECT
'''||x.PROJECT_NAME||'''  AS esquema,
'''||x.DOMAIN_NAME||''' as dominio,
R.REL_NAME "Nombre Version",
'''||x.db_name||'.'' || R.REL_ID "Id Version",
'''||x.db_name||'.'' || RC.RCYC_ID "Id Ciclo",
RC.RCYC_NAME "Nombre Ciclo",

COUNT(DISTINCT TC.TC_TESTCYCL_ID) "Casos Definidos",

COUNT(DISTINCT CASE WHEN TC.TC_STATUS = ''Passed''  THEN TC.TC_TESTCYCL_ID END  ) "Casos Exitosos",

ALM_REPORT.DIASENTRE(TO_DATE(RC.RCYC_USER_02 , ''yyyy/mm/dd''), TO_DATE(RC.RCYC_USER_03 , ''yyyy/mm/dd'')) "Dias Diferencia",

to_date(RC.RCYC_USER_02,''yyyy/mm/dd'' ) "Fecha Inicio",

to_date(RC.RCYC_USER_03,''yyyy/mm/dd'' ) "Fecha Fin",

R.REL_START_DATE "Fecha Replan. Inicio",

R.REL_END_DATE "Fecha Repla. Fin",

COUNT(DISTINCT CASE WHEN (TC.TC_STATUS = ''Passed'' OR TC.TC_STATUS = ''Failed''  OR
TC.TC_STATUS = ''Blocked'' ) THEN TC.TC_TESTCYCL_ID END  ) "Casos Ejecutados",


ALM_REPORT.DIASENTRE(TO_DATE(RC.RCYC_USER_02 , ''yyyy/mm/dd''), 

CASE WHEN  TO_DATE(RC.RCYC_USER_03 , ''yyyy/mm/dd'') > sysdate
THEN sysdate ELSE TO_DATE(RC.RCYC_USER_03 , ''yyyy/mm/dd'') END

) "Dias Diferencia Hoy",

NVL((SELECT DISTINCT  MAX(RQ_USER_02)
FROM  '||x.db_name||'.REQ,  '||x.db_name||'.REQ_RELEASES 
WHERE RQ_TYPE_ID = 119 AND RQRL_RELEASE_ID = R.REL_ID and RQRL_REQ_ID = RQ_REQ_ID and RQ_USER_02 not in (''Rechazado'')), 
''No tiene trazabilidad al requerimiento'') as estado_requerimiento,

MIN(TC.TC_EXEC_DATE) "Inicio Etapa Dinamica",
MAX(TC.TC_EXEC_DATE) "Fin Etapa Dinamica",

R.REL_USER_TEMPLATE_01 "jpqa",

COUNT(DISTINCT CASE WHEN TC.TC_STATUS = ''Failed''  THEN TC.TC_TESTCYCL_ID END  ) "Casos Fallados",
COUNT(DISTINCT CASE WHEN TC.TC_STATUS = ''Blocked''  THEN TC.TC_TESTCYCL_ID END  ) "Casos Bloqueados",

NVL((SELECT DISTINCT  RQ_USER_33
FROM  '||x.db_name||'.REQ,  '||x.db_name||'.REQ_RELEASES 
WHERE RQ_TYPE_ID = 119 AND RQRL_RELEASE_ID = R.REL_ID and RQRL_REQ_ID = RQ_REQ_ID), 
''No tiene trazabilidad al requerimiento o se encuentra vacio'') as coordinador

------------------------------------------------------------------------------


FROM
 '||x.db_name||'.RELEASES R
JOIN  '||x.db_name||'.RELEASE_CYCLES RC ON RC.RCYC_PARENT_ID = R.REL_ID
LEFT JOIN  '||x.db_name||'.TESTCYCL TC ON TC.TC_ASSIGN_RCYC = RC.RCYC_ID
LEFT JOIN  '||x.db_name||'.REQ_RELEASES RR ON R.REL_ID = RR.RQRL_RELEASE_ID
LEFT JOIN  '||x.db_name||'.REQ RQ ON RQ.RQ_REQ_ID = RR.RQRL_REQ_ID

WHERE
R.REL_ID IN (
SELECT
R.REL_ID 
FROM
 '||x.db_name||'.RELEASES R
LEFT JOIN  '||x.db_name||'.RELEASE_CYCLES RC ON RC.RCYC_PARENT_ID = R.REL_ID
LEFT JOIN  '||x.db_name||'.TESTCYCL TC ON TC.TC_ASSIGN_RCYC = RC.RCYC_ID
WHERE
TC.TC_EXEC_DATE >= TO_DATE(''01/''||TO_CHAR(SYSDATE,''mm'')||''/2016'',''dd/mm/yyyy'')   AND
TC.TC_EXEC_DATE <= TO_DATE(to_char(last_day(SYSDATE),''dd'')||''/''||TO_CHAR(SYSDATE,''mm'')||''/2016'', ''dd/mm/yyyy'')
GROUP BY  R.REL_ID)

AND RQ.RQ_TYPE_ID = 119

HAVING

NVL((SELECT DISTINCT  MAX(RQ_USER_02)
FROM  '||x.db_name||'.REQ,  '||x.db_name||'.REQ_RELEASES 
WHERE RQ_TYPE_ID = 119 AND RQRL_RELEASE_ID = R.REL_ID and RQRL_REQ_ID = RQ_REQ_ID), 
''No tiene trazabilidad al requerimiento'') NOT IN (''Términado QA'',''Finalizado'',''En Producción'',''Cerrado QA'',''Traspaso a Continuidad'',''Cancelado'')


GROUP BY  
R.REL_NAME, R.REL_ID,  
RC.RCYC_ID, RC.RCYC_NAME,
to_date(RC.RCYC_USER_02,''yyyy/mm/dd'' ), to_date(RC.RCYC_USER_03,''yyyy/mm/dd'' ),
R.REL_START_DATE ,R.REL_END_DATE, R.REL_USER_TEMPLATE_01'
;

end loop;

END;

/
