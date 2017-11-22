--------------------------------------------------------
--  DDL for Procedure cargarCurva1
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ALM_REPORT"."cargarCurva1" AS
BEGIN
execute immediate 'TRUNCATE TABLE ALM_REPORT.CURVA_1';


for x in (select db_name, PROJECT_NAME from alm_siteadmin_db_12.projects where domain_name in ('PROYECTOS') AND db_name like '%proyectos%' and PR_IS_ACTIVE = 'Y' ) loop

execute immediate  'insert into ALM_REPORT.CURVA_1
SELECT
TC.TC_TESTCYCL_ID ,
TC.TC_EXEC_DATE  ,
TC.TC_STATUS ,
(SELECT COUNT(DISTINCT  B.BG_BUG_ID) FROM '||x.db_name||'.BUG B 
WHERE B.BG_DETECTION_DATE = TC.TC_EXEC_DATE AND B.BG_TARGET_RCYC = RC.RCYC_ID AND B.BG_STATUS NOT IN (''Canceled'',''Postpone'',''N/A'',''Cancelado'',''Pospuesto'',''No Aplica'') )
as numero_defectos,
(SELECT COUNT(DISTINCT  B.BG_BUG_ID) FROM '||x.db_name||'.BUG B 
WHERE B.BG_CLOSING_DATE = TC.TC_EXEC_DATE AND B.BG_TARGET_RCYC = RC.RCYC_ID AND B.BG_STATUS NOT IN (''Canceled'',''Postpone'',''N/A'', ''Cancelado'',''Pospuesto'',''No Aplica'') )
as numero_defectos_cerrados,

(SELECT  DISTINCT
(SELECT COUNT(DISTINCT BG_BUG_ID)
FROM '||x.db_name||'.BUG  WHERE BG_STATUS NOT IN (''Canceled'',''Postpone'',''N/A'', ''Cancelado'',''Pospuesto'',''No Aplica'') and  BG_DETECTION_DATE < TC1.TC_EXEC_DATE AND  BG_TARGET_RCYC = RC.RCYC_ID)
as defectos_anteriores
FROM
'||x.db_name||'.TESTCYCL  TC1
WHERE
TC1.TC_ASSIGN_RCYC  = RC.RCYC_ID AND
TC1.TC_EXEC_DATE = (select DISTINCT MIN(TC_EXEC_DATE) FROM '||x.db_name||'.TESTCYCL WHERE TC_ASSIGN_RCYC = RC.RCYC_ID))
as defectos_anteriores,

R.REL_ID  ,

R.REL_START_DATE  "Fecha inicio replanificación",
R.REL_END_DATE  "Fecha fin replanificacion",
to_date(RC.RCYC_USER_01 ,''yyyy/mm/dd'' ) "Fecha Inicio Ciclo",
to_date(RC.RCYC_USER_02 ,''yyyy/mm/dd'' ) "Fecha Fin Ciclo",

(SELECT COUNT(TC_TESTCYCL_ID) FROM '||x.db_name||'.TESTCYCL where  RC.RCYC_ID = TC_ASSIGN_RCYC ) as cp_planificados,

RC.RCYC_NAME ,
RC.RCYC_ID,

'''||x.db_name||''' as esquema,



''PROYECTOS'' as dominio,

R.REL_NAME,

'''||x.PROJECT_NAME||''' as proyecto,
''SERVIDOR TSOFT'' as SERVIDOR

FROM
'||x.db_name||'.TESTCYCL  TC

LEFT JOIN '||x.db_name||'.RELEASE_CYCLES RC ON RC.RCYC_ID = TC.TC_ASSIGN_RCYC
LEFT JOIN '||x.db_name||'.RELEASES R ON R.REL_ID = RC.RCYC_PARENT_ID

WHERE
TC.TC_EXEC_DATE IS NOT NULL  AND RC.RCYC_NAME IS NOT NULL

';


end loop;

for x in (select DB_NAME, PROJECT_NAME from alm_siteadmin_db_12.projects WHERE DB_NAME = 'proveedores_testing_sqa_db') loop

execute immediate  'insert into ALM_REPORT.CURVA_1
SELECT
TC.TC_TESTCYCL_ID ,
TC.TC_EXEC_DATE  ,
TC.TC_STATUS ,
(SELECT COUNT(DISTINCT  B.BG_BUG_ID) FROM '||x.db_name||'.BUG B 
WHERE B.BG_DETECTION_DATE = TC.TC_EXEC_DATE AND B.BG_TARGET_RCYC = RC.RCYC_ID AND B.BG_STATUS NOT IN (''Canceled'',''Postpone'',''N/A'',''Cancelado'',''Pospuesto'',''No Aplica'') )
as numero_defectos,
(SELECT COUNT(DISTINCT  B.BG_BUG_ID) FROM '||x.db_name||'.BUG B 
WHERE B.BG_CLOSING_DATE = TC.TC_EXEC_DATE AND B.BG_TARGET_RCYC = RC.RCYC_ID AND B.BG_STATUS NOT IN (''Canceled'',''Postpone'',''N/A'', ''Cancelado'',''Pospuesto'',''No Aplica'') )
as numero_defectos_cerrados,

(SELECT  DISTINCT
(SELECT COUNT(DISTINCT BG_BUG_ID)
FROM '||x.db_name||'.BUG  WHERE BG_STATUS NOT IN (''Canceled'',''Postpone'',''N/A'', ''Cancelado'',''Pospuesto'',''No Aplica'') and  BG_DETECTION_DATE < TC1.TC_EXEC_DATE AND  BG_TARGET_RCYC = RC.RCYC_ID)
as defectos_anteriores
FROM
'||x.db_name||'.TESTCYCL  TC1
WHERE
TC1.TC_ASSIGN_RCYC  = RC.RCYC_ID AND
TC1.TC_EXEC_DATE = (select DISTINCT MIN(TC_EXEC_DATE) FROM '||x.db_name||'.TESTCYCL WHERE TC_ASSIGN_RCYC = RC.RCYC_ID))
as defectos_anteriores,

R.REL_ID  ,

R.REL_START_DATE  "Fecha inicio replanificación",
R.REL_END_DATE  "Fecha fin replanificacion",
to_date(RC.RCYC_USER_01 ,''yyyy/mm/dd'' ) "Fecha Inicio Ciclo",
to_date(RC.RCYC_USER_02 ,''yyyy/mm/dd'' ) "Fecha Fin Ciclo",

(SELECT COUNT(TC_TESTCYCL_ID) FROM '||x.db_name||'.TESTCYCL where  RC.RCYC_ID = TC_ASSIGN_RCYC ) as cp_planificados,

RC.RCYC_NAME ,
RC.RCYC_ID,

'''||x.db_name||''' as esquema,



''PROVEEDORES_TESTING'' as dominio,

R.REL_NAME,

'''||x.PROJECT_NAME||''' as proyecto,
''SERVIDOR TSOFT'' as SERVIDOR

FROM
'||x.db_name||'.TESTCYCL  TC

LEFT JOIN '||x.db_name||'.RELEASE_CYCLES RC ON RC.RCYC_ID = TC.TC_ASSIGN_RCYC
LEFT JOIN '||x.db_name||'.RELEASES R ON R.REL_ID = RC.RCYC_PARENT_ID

WHERE
TC.TC_EXEC_DATE IS NOT NULL  AND RC.RCYC_NAME IS NOT NULL

';

end loop;

for x in (select db_name, PROJECT_NAME from alm_siteadmin_db_12.projects where DB_NAME = 'bch_qa_certificación_bch_qa_d') loop

execute immediate  'insert into ALM_REPORT.CURVA_1

SELECT
TC.TC_TESTCYCL_ID ,
TC.TC_EXEC_DATE  ,
TC.TC_STATUS ,
(SELECT COUNT(DISTINCT  B.BG_BUG_ID) 
FROM '||x.db_name||'.BUG B 
WHERE B.BG_DETECTION_DATE = TC.TC_EXEC_DATE AND B.BG_TARGET_RCYC = RC.RCYC_ID AND B.BG_STATUS NOT IN (''Canceled'',''Postpone'',''N/A'',''Cancelado'',''Pospuesto'',''No Aplica'') )
as numero_defectos,

(SELECT COUNT(DISTINCT  B.BG_BUG_ID) 
FROM '||x.db_name||'.BUG B 
WHERE B.BG_CLOSING_DATE = TC.TC_EXEC_DATE AND B.BG_TARGET_RCYC = RC.RCYC_ID AND B.BG_STATUS NOT IN (''Canceled'',''Postpone'',''N/A'', ''Cancelado'',''Pospuesto'',''No Aplica'') )
as numero_defectos_cerrados,

(SELECT  DISTINCT
(SELECT COUNT(DISTINCT BG_BUG_ID)
FROM '||x.db_name||'.BUG  
WHERE BG_STATUS NOT IN (''Canceled'',''Postpone'',''N/A'', ''Cancelado'',''Pospuesto'',''No Aplica'') and  BG_DETECTION_DATE < TC1.TC_EXEC_DATE AND  BG_TARGET_RCYC = RC.RCYC_ID)
as defectos_anteriores
FROM
'||x.db_name||'.TESTCYCL  TC1
WHERE
TC1.TC_ASSIGN_RCYC  = RC.RCYC_ID AND
TC1.TC_EXEC_DATE = (select DISTINCT MIN(TC_EXEC_DATE) FROM '||x.db_name||'.TESTCYCL WHERE TC_ASSIGN_RCYC = RC.RCYC_ID))
as defectos_anteriores,

R.REL_ID  ,

R.REL_START_DATE  "Fecha inicio replanificación",
R.REL_END_DATE  "Fecha fin replanificacion",
to_date(RC.RCYC_USER_02 ,''yyyy/mm/dd'' ) "Fecha Inicio Ciclo",
to_date(RC.RCYC_USER_03 ,''yyyy/mm/dd'' ) "Fecha Fin Ciclo",

(SELECT COUNT(TC_TESTCYCL_ID) FROM '||x.db_name||'.TESTCYCL where  RC.RCYC_ID = TC_ASSIGN_RCYC ) as cp_planificados,

RC.RCYC_NAME ,
RC.RCYC_ID,

'''||x.db_name||''' as esquema,

''BCH_QA'' as dominio,

R.REL_NAME,

'''||x.PROJECT_NAME||''' as proyecto,
''SERVIDOR TSOFT'' as SERVIDOR

FROM
'||x.db_name||'.TESTCYCL  TC

LEFT JOIN '||x.db_name||'.RELEASE_CYCLES RC ON RC.RCYC_ID = TC.TC_ASSIGN_RCYC
LEFT JOIN '||x.db_name||'.RELEASES R ON R.REL_ID = RC.RCYC_PARENT_ID

WHERE
TC.TC_EXEC_DATE IS NOT NULL  AND RC.RCYC_NAME IS NOT NULL

';

end loop;


/*
for x in (select db_name, PROJECT_NAME from alm_siteadmin_db_12.projects where DB_NAME = 'bch_qcsitebch_db') loop

execute immediate  'insert into ALM_REPORT.CURVA_1
SELECT
TC.TC_TESTCYCL_ID ,
TC.TC_EXEC_DATE  ,
TC.TC_STATUS ,
(SELECT COUNT(DISTINCT  B.BG_BUG_ID) FROM '||x.db_name||'.BUG B 
WHERE B.BG_DETECTION_DATE = TC.TC_EXEC_DATE AND B.BG_TARGET_RCYC = RC.RCYC_ID AND B.BG_STATUS NOT IN (''Canceled'',''Postpone'',''N/A'',''Cancelado'',''Pospuesto'',''No Aplica'') )
as numero_defectos,
(SELECT COUNT(DISTINCT  B.BG_BUG_ID) FROM '||x.db_name||'.BUG B 
WHERE B.BG_CLOSING_DATE = TC.TC_EXEC_DATE AND B.BG_TARGET_RCYC = RC.RCYC_ID AND B.BG_STATUS NOT IN (''Canceled'',''Postpone'',''N/A'', ''Cancelado'',''Pospuesto'',''No Aplica'') )
as numero_defectos_cerrados,

(SELECT  DISTINCT
(SELECT COUNT(DISTINCT BG_BUG_ID)
FROM '||x.db_name||'.BUG  WHERE BG_STATUS NOT IN (''Canceled'',''Postpone'',''N/A'', ''Cancelado'',''Pospuesto'',''No Aplica'') and  BG_DETECTION_DATE < TC1.TC_EXEC_DATE AND  BG_TARGET_RCYC = RC.RCYC_ID)
as defectos_anteriores
FROM
'||x.db_name||'.TESTCYCL  TC1
WHERE
TC1.TC_ASSIGN_RCYC  = RC.RCYC_ID AND
TC1.TC_EXEC_DATE = (select DISTINCT MIN(TC_EXEC_DATE) FROM '||x.db_name||'.TESTCYCL WHERE TC_ASSIGN_RCYC = RC.RCYC_ID))
as defectos_anteriores,

R.REL_ID  ,

R.REL_START_DATE  "Fecha inicio replanificación",
R.REL_END_DATE  "Fecha fin replanificacion",
to_date(RC.RCYC_USER_02 ,''yyyy/mm/dd'' ) "Fecha Inicio Ciclo",
to_date(RC.RCYC_USER_03 ,''yyyy/mm/dd'' ) "Fecha Fin Ciclo",

(SELECT COUNT(TC_TESTCYCL_ID) FROM '||x.db_name||'.TESTCYCL where  RC.RCYC_ID = TC_ASSIGN_RCYC ) as cp_planificados,

RC.RCYC_NAME ,
RC.RCYC_ID,

'''||x.db_name||''' as esquema,



''CONTINUIDAD'' as dominio,

R.REL_NAME,

'''||x.PROJECT_NAME||''' as proyecto 

FROM
'||x.db_name||'.TESTCYCL  TC

LEFT JOIN '||x.db_name||'.RELEASE_CYCLES RC ON RC.RCYC_ID = TC.TC_ASSIGN_RCYC
LEFT JOIN '||x.db_name||'.RELEASES R ON R.REL_ID = RC.RCYC_PARENT_ID

WHERE
TC.TC_EXEC_DATE IS NOT NULL  AND RC.RCYC_NAME IS NOT NULL
AND
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


';
end loop;
*/


execute immediate  'insert into ALM_REPORT.CURVA_1 
select * from CURVA_1@SERVER_BCH
';




end;

/
