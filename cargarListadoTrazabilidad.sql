--------------------------------------------------------
--  DDL for Procedure cargarListadoTrazabilidad
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ALM_REPORT"."cargarListadoTrazabilidad" AS
BEGIN

execute immediate 'TRUNCATE TABLE ALM_REPORT.LISTADO_TRAZABILIDAD';

for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME from alm_siteadmin_db_12.projects where DB_NAME = 'bch_qcsitebch_db') loop
execute immediate  'insert into ALM_REPORT.LISTADO_TRAZABILIDAD
SELECT
'''||x.PROJECT_NAME||'''  AS esquema,
R.REL_NAME "Nombre Version",

(SELECT DISTINCT  RQ_REQ_DATE
FROM  '||x.db_name||'.REQ,  '||x.db_name||'.REQ_RELEASES 
WHERE RQ_TYPE_ID = 107 AND RQRL_RELEASE_ID = R.REL_ID and RQRL_REQ_ID = RQ_REQ_ID)
 as fecha_creacion_req,


NVL((SELECT DISTINCT  RQ_USER_04
FROM  '||x.db_name||'.REQ,  '||x.db_name||'.REQ_RELEASES 
WHERE RQ_TYPE_ID = 107 AND RQRL_RELEASE_ID = R.REL_ID and RQRL_REQ_ID = RQ_REQ_ID), 
''Sin Trazabilidad'') as estado_requerimiento ,


NVL((SELECT DISTINCT  RQ_USER_03
FROM  '||x.db_name||'.REQ,  '||x.db_name||'.REQ_RELEASES 
WHERE RQ_TYPE_ID = 107 AND RQRL_RELEASE_ID = R.REL_ID and RQRL_REQ_ID = RQ_REQ_ID), 
''Sin Trazabilidad'') as jdp_qa,

NVL((SELECT DISTINCT  RQ_USER_33
FROM  '||x.db_name||'.REQ,  '||x.db_name||'.REQ_RELEASES 
WHERE RQ_TYPE_ID = 107 AND RQRL_RELEASE_ID = R.REL_ID and RQRL_REQ_ID = RQ_REQ_ID), 
''Sin Trazabilidad'') as coordinador,

R.REL_START_DATE "Fecha Replan. Inicio",

MIN(TC.TC_EXEC_DATE) "primera ejecucion",
MAX(TC.TC_EXEC_DATE) "ultima ejecucion"

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
TC.TC_EXEC_DATE >= TO_DATE(''01/11/2015'',''dd/mm/yyyy'')   AND
TC.TC_EXEC_DATE <= TO_DATE(to_char(last_day(SYSDATE),''dd'')||''/''||TO_CHAR(SYSDATE,''mm'')||''/2016'', ''dd/mm/yyyy'')
GROUP BY  R.REL_ID)
AND
R.REL_PARENT_ID IN (SELECT RF.RF_ID FROM  '||x.db_name||'.RELEASE_FOLDERS RF  START WITH RF.RF_ID = 128 CONNECT BY PRIOR RF.RF_ID = RF_PARENT_ID)


GROUP BY  
R.REL_ID,
R.REL_NAME,
R.REL_START_DATE
  ';


end loop;



for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME from alm_siteadmin_db_12.projects where domain_name in ('PROYECTOS') and PR_IS_ACTIVE = 'Y' ) loop
execute immediate  'insert into ALM_REPORT.LISTADO_TRAZABILIDAD
SELECT
'''||x.PROJECT_NAME||'''  AS esquema,
R.REL_NAME "Nombre Version",

(SELECT DISTINCT  MAX(RQ_REQ_DATE)
FROM  '||x.db_name||'.REQ,  '||x.db_name||'.REQ_RELEASES 
WHERE RQ_TYPE_ID = 101 AND RQRL_RELEASE_ID = R.REL_ID and RQRL_REQ_ID = RQ_REQ_ID)
 as fecha_creacion_req,


NVL((SELECT DISTINCT  MAX(RQ_USER_02)
FROM  '||x.db_name||'.REQ,  '||x.db_name||'.REQ_RELEASES 
WHERE RQ_TYPE_ID = 101 AND RQRL_RELEASE_ID = R.REL_ID and RQRL_REQ_ID = RQ_REQ_ID), 
''Sin Trazabilidad'') as estado_requerimiento ,

R.REL_USER_04  jdp_qa,

NVL((SELECT DISTINCT   MAX(RQ_USER_12)
FROM  '||x.db_name||'.REQ,  '||x.db_name||'.REQ_RELEASES 
WHERE RQ_TYPE_ID = 101 AND RQRL_RELEASE_ID = R.REL_ID and RQRL_REQ_ID = RQ_REQ_ID), 
''Sin Trazabilidad'') as coordinador,

R.REL_START_DATE "Fecha Replan. Inicio",

MIN(TC.TC_EXEC_DATE) "primera ejecucion",
MAX(TC.TC_EXEC_DATE) "ultima ejecucion"

FROM
 '||x.db_name||'.RELEASES R
JOIN  '||x.db_name||'.RELEASE_CYCLES RC ON RC.RCYC_PARENT_ID = R.REL_ID
LEFT JOIN  '||x.db_name||'.TESTCYCL TC ON TC.TC_ASSIGN_RCYC = RC.RCYC_ID



GROUP BY  
R.REL_ID,
R.REL_NAME,
R.REL_USER_04 ,
R.REL_START_DATE
  ';

end loop;



for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME from alm_siteadmin_db_12.projects WHERE DB_NAME = 'proveedores_testing_sqa_db') loop
execute immediate  'insert into ALM_REPORT.LISTADO_TRAZABILIDAD
SELECT
'''||x.PROJECT_NAME||'''  AS esquema,
R.REL_NAME "Nombre Version",

(SELECT DISTINCT  RQ_REQ_DATE
FROM  '||x.db_name||'.REQ,  '||x.db_name||'.REQ_RELEASES 
WHERE RQ_TYPE_ID = 101 AND RQRL_RELEASE_ID = R.REL_ID and RQRL_REQ_ID = RQ_REQ_ID)
 as fecha_creacion_req,


NVL((SELECT DISTINCT  RQ_USER_02
FROM  '||x.db_name||'.REQ,  '||x.db_name||'.REQ_RELEASES 
WHERE RQ_TYPE_ID = 101 AND RQRL_RELEASE_ID = R.REL_ID and RQRL_REQ_ID = RQ_REQ_ID), 
''Sin Trazabilidad'') as estado_requerimiento ,

R.REL_USER_04  jdp_qa,

NVL((SELECT DISTINCT   RQ_USER_12
FROM  '||x.db_name||'.REQ,  '||x.db_name||'.REQ_RELEASES 
WHERE RQ_TYPE_ID = 101 AND RQRL_RELEASE_ID = R.REL_ID and RQRL_REQ_ID = RQ_REQ_ID), 
''Sin Trazabilidad'') as coordinador,

R.REL_START_DATE "Fecha Replan. Inicio",

MIN(TC.TC_EXEC_DATE) "primera ejecucion",
MAX(TC.TC_EXEC_DATE) "ultima ejecucion"

FROM
 '||x.db_name||'.RELEASES R
JOIN  '||x.db_name||'.RELEASE_CYCLES RC ON RC.RCYC_PARENT_ID = R.REL_ID
LEFT JOIN  '||x.db_name||'.TESTCYCL TC ON TC.TC_ASSIGN_RCYC = RC.RCYC_ID




GROUP BY  
R.REL_ID,
R.REL_NAME,
R.REL_USER_04 ,
R.REL_START_DATE
  ';

end loop;



END;

/
