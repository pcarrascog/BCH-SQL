--------------------------------------------------------
--  DDL for Procedure cargarListadoProyectos
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ALM_REPORT"."cargarListadoProyectos" AS
BEGIN

execute immediate 'TRUNCATE TABLE ALM_REPORT.LISTADO_PROYECTOS';


for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME, DESCRIPTION from alm_siteadmin_db_12.projects where domain_name in ('PROYECTOS') and PR_IS_ACTIVE = 'Y' ) loop
execute immediate  'insert into ALM_REPORT.LISTADO_PROYECTOS

SELECT
'''||x.DOMAIN_NAME||'''  AS dominio,
'''||x.PROJECT_NAME||'''  AS esquema,
R.REL_NAME "Nombre Version",
R.REL_USER_04  jdp_qa,

NVL((SELECT DISTINCT   MAX(RQ_USER_12)
FROM  '||x.db_name||'.REQ,  '||x.db_name||'.REQ_RELEASES 
WHERE RQ_TYPE_ID = 101 AND RQRL_RELEASE_ID = R.REL_ID and RQRL_REQ_ID = RQ_REQ_ID), 
''Sin Trazabilidad o Vacío'') as coordinador,


NVL((SELECT DISTINCT  MAX(RQ_USER_02)
FROM  '||x.db_name||'.REQ,  '||x.db_name||'.REQ_RELEASES 
WHERE RQ_TYPE_ID = 101 AND RQRL_RELEASE_ID = R.REL_ID and RQRL_REQ_ID = RQ_REQ_ID), 
''Sin Trazabilidad o Vacío'') as estado_requerimiento ,

R.REL_START_DATE "Fecha Replan. Inicio",
R.REL_END_DATE "Fecha Repla. Fin",
TO_DATE(R.REL_USER_01, ''yyyy/mm/dd'' ) "Fecha pla Inicio",
TO_DATE(R.REL_USER_02, ''yyyy/mm/dd'' ) "Fecha pla Fin",

(SELECT MIN(EL_CREATION_DATE) FROM  '||x.db_name||'.EVENT_LOG) as fecha_creacion, 


MAX(TC.TC_EXEC_DATE) "ultima ejecucion"

FROM
 '||x.db_name||'.RELEASES R
JOIN  '||x.db_name||'.RELEASE_CYCLES RC ON RC.RCYC_PARENT_ID = R.REL_ID
LEFT JOIN  '||x.db_name||'.TESTCYCL TC ON TC.TC_ASSIGN_RCYC = RC.RCYC_ID


GROUP BY  
R.REL_ID,
R.REL_NAME,
R.REL_USER_04 ,
R.REL_START_DATE,
R.REL_END_DATE ,
TO_DATE(R.REL_USER_01, ''yyyy/mm/dd'' ) ,
TO_DATE(R.REL_USER_02, ''yyyy/mm/dd'' ) 
  ';

end loop;

for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME, DESCRIPTION from alm_siteadmin_db_12.projects where DB_NAME = 'bch_qcsitebch_db') loop
execute immediate  'insert into ALM_REPORT.LISTADO_PROYECTOS

SELECT
'''||x.DOMAIN_NAME||'''  AS dominio,
'''||x.PROJECT_NAME||'''  AS esquema,
R.REL_NAME "Nombre Version",

NVL((SELECT DISTINCT  max(RQ_USER_03)
FROM  '||x.db_name||'.REQ,  '||x.db_name||'.REQ_RELEASES 
WHERE RQ_TYPE_ID = 107 AND RQRL_RELEASE_ID = R.REL_ID and RQRL_REQ_ID = RQ_REQ_ID), 
''No tiene trazabilidad al requerimiento'') as jdp_qa,

NVL((SELECT DISTINCT   MAX(RQ_USER_33)
FROM  '||x.db_name||'.REQ,  '||x.db_name||'.REQ_RELEASES 
WHERE RQ_TYPE_ID = 107 AND RQRL_RELEASE_ID = R.REL_ID and RQRL_REQ_ID = RQ_REQ_ID), 
''Sin Trazabilidad o Vacío'') as coordinador,


NVL((SELECT DISTINCT  MAX(RQ_USER_04)
FROM  '||x.db_name||'.REQ,  '||x.db_name||'.REQ_RELEASES 
WHERE RQ_TYPE_ID = 107 AND RQRL_RELEASE_ID = R.REL_ID and RQRL_REQ_ID = RQ_REQ_ID), 
''Sin Trazabilidad o Vacío'') as estado_requerimiento ,

R.REL_START_DATE "Fecha Replan. Inicio",
R.REL_END_DATE "Fecha Repla. Fin",
TO_DATE(R.REL_USER_03, ''yyyy/mm/dd'' ) "Fecha pla Inicio",
TO_DATE(R.REL_USER_02, ''yyyy/mm/dd'' ) "Fecha pla Fin",

(SELECT MIN(EL_CREATION_DATE) FROM  '||x.db_name||'.EVENT_LOG) as fecha_creacion, 


MAX(TC.TC_EXEC_DATE) "ultima ejecucion"

FROM
 '||x.db_name||'.RELEASES R
JOIN  '||x.db_name||'.RELEASE_CYCLES RC ON RC.RCYC_PARENT_ID = R.REL_ID
LEFT JOIN  '||x.db_name||'.TESTCYCL TC ON TC.TC_ASSIGN_RCYC = RC.RCYC_ID


GROUP BY  
R.REL_ID,
R.REL_NAME,
R.REL_START_DATE,
R.REL_END_DATE ,
TO_DATE(R.REL_USER_03, ''yyyy/mm/dd'' ) ,
TO_DATE(R.REL_USER_02, ''yyyy/mm/dd'' ) 
  ';

end loop;

for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME, DESCRIPTION from alm_siteadmin_db_12.projects WHERE DB_NAME = 'proveedores_testing_sqa_db') loop
execute immediate  'insert into ALM_REPORT.LISTADO_PROYECTOS

SELECT
'''||x.DOMAIN_NAME||'''  AS dominio,
'''||x.PROJECT_NAME||'''  AS esquema,
R.REL_NAME "Nombre Version",
R.REL_USER_04  jdp_qa,

NVL((SELECT DISTINCT   MAX(RQ_USER_12)
FROM  '||x.db_name||'.REQ,  '||x.db_name||'.REQ_RELEASES 
WHERE RQ_TYPE_ID = 101 AND RQRL_RELEASE_ID = R.REL_ID and RQRL_REQ_ID = RQ_REQ_ID), 
''Sin Trazabilidad o Vacío'') as coordinador,


NVL((SELECT DISTINCT  MAX(RQ_USER_02)
FROM  '||x.db_name||'.REQ,  '||x.db_name||'.REQ_RELEASES 
WHERE RQ_TYPE_ID = 101 AND RQRL_RELEASE_ID = R.REL_ID and RQRL_REQ_ID = RQ_REQ_ID), 
''Sin Trazabilidad o Vacío'') as estado_requerimiento ,

R.REL_START_DATE "Fecha Replan. Inicio",
R.REL_END_DATE "Fecha Repla. Fin",
TO_DATE(R.REL_USER_01, ''yyyy/mm/dd'' ) "Fecha pla Inicio",
TO_DATE(R.REL_USER_02, ''yyyy/mm/dd'' ) "Fecha pla Fin",

(SELECT MIN(EL_CREATION_DATE) FROM  '||x.db_name||'.EVENT_LOG) as fecha_creacion, 


MAX(TC.TC_EXEC_DATE) "ultima ejecucion"

FROM
 '||x.db_name||'.RELEASES R
JOIN  '||x.db_name||'.RELEASE_CYCLES RC ON RC.RCYC_PARENT_ID = R.REL_ID
LEFT JOIN  '||x.db_name||'.TESTCYCL TC ON TC.TC_ASSIGN_RCYC = RC.RCYC_ID


GROUP BY  
R.REL_ID,
R.REL_NAME,
R.REL_USER_04 ,
R.REL_START_DATE,
R.REL_END_DATE ,
TO_DATE(R.REL_USER_01, ''yyyy/mm/dd'' ) ,
TO_DATE(R.REL_USER_02, ''yyyy/mm/dd'' ) 
  ';

end loop;


for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME, DESCRIPTION from alm_siteadmin_db_12.projects where DB_NAME = 'continuidad_automatización_db') loop
execute immediate  'insert into ALM_REPORT.LISTADO_PROYECTOS

SELECT
'''||x.DOMAIN_NAME||'''  AS dominio,
'''||x.PROJECT_NAME||'''  AS esquema,
R.REL_NAME "Nombre Version",

R.REL_USER_04,

NVL((SELECT DISTINCT   MAX(BG_USER_03)
FROM  '||x.db_name||'.BUG
WHERE BG_TARGET_REL = R.REL_ID) , 
''Sin Trazabilidad o Vacío'') as coordinador,


NVL((SELECT DISTINCT  MAX(RQ_USER_02)
FROM  '||x.db_name||'.REQ,  '||x.db_name||'.REQ_RELEASES 
WHERE RQ_TYPE_ID = 101 AND RQRL_RELEASE_ID = R.REL_ID and RQRL_REQ_ID = RQ_REQ_ID), 
''Sin Trazabilidad o Vacío'') as estado_requerimiento ,

R.REL_START_DATE "Fecha Replan. Inicio",
R.REL_END_DATE "Fecha Repla. Fin",
TO_DATE(R.REL_USER_01, ''yyyy/mm/dd'' ) "Fecha pla Inicio",
TO_DATE(R.REL_USER_02, ''yyyy/mm/dd'' ) "Fecha pla Fin",

(SELECT MIN(EL_CREATION_DATE) FROM  '||x.db_name||'.EVENT_LOG) as fecha_creacion, 


MAX(TC.TC_EXEC_DATE) "ultima ejecucion"

FROM
 '||x.db_name||'.RELEASES R
JOIN  '||x.db_name||'.RELEASE_CYCLES RC ON RC.RCYC_PARENT_ID = R.REL_ID
LEFT JOIN  '||x.db_name||'.TESTCYCL TC ON TC.TC_ASSIGN_RCYC = RC.RCYC_ID


GROUP BY  
R.REL_ID,
R.REL_NAME,
R.REL_USER_04,
R.REL_START_DATE,
R.REL_END_DATE ,
TO_DATE(R.REL_USER_01, ''yyyy/mm/dd'' ) ,
TO_DATE(R.REL_USER_02, ''yyyy/mm/dd'' ) 
  ';
end loop;


for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME from alm_siteadmin_db_12.projects where DOMAIN_NAME = 'QA') loop
execute immediate  'insert into ALM_REPORT.LISTADO_PROYECTOS

SELECT
'''||x.DOMAIN_NAME||'''  AS dominio,
'''||x.PROJECT_NAME||'''  AS esquema,
R.REL_NAME "Nombre Version",

R.REL_USER_05,

NVL((SELECT DISTINCT   MAX(BG_USER_03)
FROM  '||x.db_name||'.BUG
WHERE BG_TARGET_REL = R.REL_ID) , 
''Sin Trazabilidad o Vacío'') as coordinador,


NVL((SELECT DISTINCT  MAX(RQ_USER_05)
FROM  '||x.db_name||'.REQ,  '||x.db_name||'.REQ_RELEASES 
WHERE RQ_TYPE_ID = 103 AND RQRL_RELEASE_ID = R.REL_ID and RQRL_REQ_ID = RQ_REQ_ID), 
''Sin Trazabilidad o Vacío'') as estado_requerimiento ,

R.REL_START_DATE "Fecha Replan. Inicio",
R.REL_END_DATE "Fecha Repla. Fin",
TO_DATE(R.REL_USER_01, ''yyyy/mm/dd'' ) "Fecha pla Inicio",
TO_DATE(R.REL_USER_03, ''yyyy/mm/dd'' ) "Fecha pla Fin",

(SELECT MIN(EL_CREATION_DATE) FROM  '||x.db_name||'.EVENT_LOG) as fecha_creacion, 


MAX(TC.TC_EXEC_DATE) "ultima ejecucion"

FROM
 '||x.db_name||'.RELEASES R
JOIN  '||x.db_name||'.RELEASE_CYCLES RC ON RC.RCYC_PARENT_ID = R.REL_ID
LEFT JOIN  '||x.db_name||'.TESTCYCL TC ON TC.TC_ASSIGN_RCYC = RC.RCYC_ID


GROUP BY  
R.REL_ID,
R.REL_NAME,
R.REL_USER_05,
R.REL_START_DATE,
R.REL_END_DATE ,
TO_DATE(R.REL_USER_01, ''yyyy/mm/dd'' ) ,
TO_DATE(R.REL_USER_03, ''yyyy/mm/dd'' ) 
  ';

end loop;


end;

/
