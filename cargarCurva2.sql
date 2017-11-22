--------------------------------------------------------
--  DDL for Procedure cargarCurva2
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ALM_REPORT"."cargarCurva2" AS
BEGIN
execute immediate 'TRUNCATE TABLE ALM_REPORT.CURVA_2';


for x in (select db_name, PROJECT_NAME from alm_siteadmin_db_12.projects where domain_name in ('PROYECTOS') and PR_IS_ACTIVE = 'Y' AND db_name like '%proyectos%' ) loop

execute immediate  'insert into ALM_REPORT.CURVA_2
SELECT 
DISTINCT 
RC.RCYC_ID,
RC.RCYC_NAME,
to_date(RC.RCYC_USER_01,''yyyy/mm/dd'' ) "Fecha Inicio",
to_date(RC.RCYC_USER_02,''yyyy/mm/dd'' ) "Fecha Fin",
TC.TC_TESTCYCL_ID,
TC.TC_STATUS,
TC.TC_EXEC_DATE,
TC.TC_TEST_ID,
ALM_REPORT.DIASENTRE(TO_DATE(RC.RCYC_USER_01 , ''yyyy/mm/dd''), TO_DATE(RC.RCYC_USER_02 , ''yyyy/mm/dd'')) "Dias Diferencia",
B.BG_BUG_ID,
BG_DETECTION_DATE,
R.REL_NAME,
R.REL_ID,
''PROYECTOS'' as dominio,
'''||x.PROJECT_NAME||''' as proyecto,
'''||x.db_name||''' as esquema,
''SERVIDOR TSOFT'' as SERVIDOR


FROM '||x.db_name||'.RELEASES R
LEFT JOIN '||x.db_name||'.RELEASE_CYCLES RC ON RC.RCYC_PARENT_ID = R.REL_ID
LEFT JOIN '||x.db_name||'.TESTCYCL TC ON TC.TC_ASSIGN_RCYC = RC.RCYC_ID
LEFT JOIN '||x.db_name||'.RUN RN ON RN.RN_TESTCYCL_ID = TC.TC_TESTCYCL_ID
LEFT JOIN '||x.db_name||'.STEP ST ON ST.ST_RUN_ID = RN.RN_RUN_ID

LEFT JOIN 
(
SELECT 
BG_BUG_ID,
BG_STATUS,
BG_DETECTION_DATE,
BG_CLOSING_DATE,
LN_ENTITY_ID,
LN_ENTITY_TYPE
FROM '||x.db_name||'.BUG 
JOIN '||x.db_name||'.LINK  ON LN_BUG_ID = BG_BUG_ID AND LN_ENTITY_TYPE IN (''RUN'',''TESTCYCL'',''STEP'')
WHERE BG_STATUS != ''Canceled''
) B ON 
(B.LN_ENTITY_ID = TC.TC_TESTCYCL_ID AND B.LN_ENTITY_TYPE = ''TESTCYCL'') OR
(B.LN_ENTITY_ID = RN.RN_RUN_ID AND B.LN_ENTITY_TYPE = ''RUN'') OR
(B.LN_ENTITY_ID = ST.ST_ID  AND B.LN_ENTITY_TYPE = ''STEP'') 

WHERE B.BG_BUG_ID IS NOT NULL 
ORDER BY B.BG_BUG_ID ASC
';


end loop;




for x in (select DB_NAME, PROJECT_NAME from alm_siteadmin_db_12.projects WHERE DB_NAME = 'proveedores_testing_sqa_db') loop

execute immediate  'insert into ALM_REPORT.CURVA_2
SELECT 
DISTINCT 
RC.RCYC_ID,
RC.RCYC_NAME,
to_date(RC.RCYC_USER_01,''yyyy/mm/dd'' ) "Fecha Inicio",
to_date(RC.RCYC_USER_02,''yyyy/mm/dd'' ) "Fecha Fin",
TC.TC_TESTCYCL_ID,
TC.TC_STATUS,
TC.TC_EXEC_DATE,
TC.TC_TEST_ID,
ALM_REPORT.DIASENTRE(TO_DATE(RC.RCYC_USER_01 , ''yyyy/mm/dd''), TO_DATE(RC.RCYC_USER_02 , ''yyyy/mm/dd'')) "Dias Diferencia",
B.BG_BUG_ID,
BG_DETECTION_DATE,
R.REL_NAME,
R.REL_ID,
''RENOVACION LEASING'' as dominio,
'''||x.PROJECT_NAME||''' as proyecto,
'''||x.db_name||''' as esquema,
''SERVIDOR TSOFT'' as SERVIDOR


FROM '||x.db_name||'.RELEASES R
LEFT JOIN '||x.db_name||'.RELEASE_CYCLES RC ON RC.RCYC_PARENT_ID = R.REL_ID
LEFT JOIN '||x.db_name||'.TESTCYCL TC ON TC.TC_ASSIGN_RCYC = RC.RCYC_ID
LEFT JOIN '||x.db_name||'.RUN RN ON RN.RN_TESTCYCL_ID = TC.TC_TESTCYCL_ID
LEFT JOIN '||x.db_name||'.STEP ST ON ST.ST_RUN_ID = RN.RN_RUN_ID

LEFT JOIN 
(
SELECT 
BG_BUG_ID,
BG_STATUS,
BG_DETECTION_DATE,
BG_CLOSING_DATE,
LN_ENTITY_ID,
LN_ENTITY_TYPE
FROM '||x.db_name||'.BUG 
JOIN '||x.db_name||'.LINK  ON LN_BUG_ID = BG_BUG_ID AND LN_ENTITY_TYPE IN (''RUN'',''TESTCYCL'',''STEP'')
WHERE BG_STATUS != ''Canceled''
) B ON 
(B.LN_ENTITY_ID = TC.TC_TESTCYCL_ID AND B.LN_ENTITY_TYPE = ''TESTCYCL'') OR
(B.LN_ENTITY_ID = RN.RN_RUN_ID AND B.LN_ENTITY_TYPE = ''RUN'') OR
(B.LN_ENTITY_ID = ST.ST_ID  AND B.LN_ENTITY_TYPE = ''STEP'') 

WHERE B.BG_BUG_ID IS NOT NULL 
ORDER BY B.BG_BUG_ID ASC
';

end loop;

for x in (select DB_NAME, PROJECT_NAME from alm_siteadmin_db_12.projects WHERE DB_NAME = 'bch_qa_certificación_bch_qa_d') loop

execute immediate  'insert into ALM_REPORT.CURVA_2
SELECT 
DISTINCT 
RC.RCYC_ID,
RC.RCYC_NAME,
to_date(RC.RCYC_USER_02,''yyyy/mm/dd'' ) "Fecha Inicio",
to_date(RC.RCYC_USER_03,''yyyy/mm/dd'' ) "Fecha Fin",
TC.TC_TESTCYCL_ID,
TC.TC_STATUS,
TC.TC_EXEC_DATE,
TC.TC_TEST_ID,
ALM_REPORT.DIASENTRE(TO_DATE(RC.RCYC_USER_02 , ''yyyy/mm/dd''), TO_DATE(RC.RCYC_USER_03 , ''yyyy/mm/dd'')) "Dias Diferencia",
B.BG_BUG_ID,
BG_DETECTION_DATE,
R.REL_NAME,
R.REL_ID,
''BCH_QA'' as dominio,
'''||x.PROJECT_NAME||''' as proyecto,
'''||x.db_name||''' as esquema,
''SERVIDOR TSOFT'' as SERVIDOR


FROM '||x.db_name||'.RELEASES R
LEFT JOIN '||x.db_name||'.RELEASE_CYCLES RC ON RC.RCYC_PARENT_ID = R.REL_ID
LEFT JOIN '||x.db_name||'.TESTCYCL TC ON TC.TC_ASSIGN_RCYC = RC.RCYC_ID
LEFT JOIN '||x.db_name||'.RUN RN ON RN.RN_TESTCYCL_ID = TC.TC_TESTCYCL_ID
LEFT JOIN '||x.db_name||'.STEP ST ON ST.ST_RUN_ID = RN.RN_RUN_ID

LEFT JOIN 
(
SELECT 
BG_BUG_ID,
BG_STATUS,
BG_DETECTION_DATE,
BG_CLOSING_DATE,
LN_ENTITY_ID,
LN_ENTITY_TYPE
FROM '||x.db_name||'.BUG 
JOIN '||x.db_name||'.LINK  ON LN_BUG_ID = BG_BUG_ID AND LN_ENTITY_TYPE IN (''RUN'',''TESTCYCL'',''STEP'')
WHERE BG_STATUS != ''Canceled''
) B ON 
(B.LN_ENTITY_ID = TC.TC_TESTCYCL_ID AND B.LN_ENTITY_TYPE = ''TESTCYCL'') OR
(B.LN_ENTITY_ID = RN.RN_RUN_ID AND B.LN_ENTITY_TYPE = ''RUN'') OR
(B.LN_ENTITY_ID = ST.ST_ID  AND B.LN_ENTITY_TYPE = ''STEP'') 

WHERE B.BG_BUG_ID IS NOT NULL 
ORDER BY B.BG_BUG_ID ASC
';

end loop;

/*
for x in (select db_name, PROJECT_NAME from alm_siteadmin_db_12.projects where DB_NAME = 'bch_qcsitebch_db') loop

execute immediate  'insert into ALM_REPORT.CURVA_2
SELECT 
DISTINCT 
RC.RCYC_ID,
RC.RCYC_NAME,
to_date(RC.RCYC_USER_02,''yyyy/mm/dd'' ) "Fecha Inicio",
to_date(RC.RCYC_USER_03,''yyyy/mm/dd'' ) "Fecha Fin",
TC.TC_TESTCYCL_ID,
TC.TC_STATUS,
TC.TC_EXEC_DATE,
TC.TC_TEST_ID,
ALM_REPORT.DIASENTRE(TO_DATE(RC.RCYC_USER_02 , ''yyyy/mm/dd''), TO_DATE(RC.RCYC_USER_03 , ''yyyy/mm/dd'')) "Dias Diferencia",
B.BG_BUG_ID,
BG_DETECTION_DATE,
R.REL_NAME,
R.REL_ID,
''CONTINUIDAD'' as dominio,
'''||x.PROJECT_NAME||''' as proyecto,
'''||x.db_name||''' as esquema


FROM '||x.db_name||'.RELEASES R
LEFT JOIN '||x.db_name||'.RELEASE_CYCLES RC ON RC.RCYC_PARENT_ID = R.REL_ID
LEFT JOIN '||x.db_name||'.TESTCYCL TC ON TC.TC_ASSIGN_RCYC = RC.RCYC_ID
LEFT JOIN '||x.db_name||'.RUN RN ON RN.RN_TESTCYCL_ID = TC.TC_TESTCYCL_ID
LEFT JOIN '||x.db_name||'.STEP ST ON ST.ST_RUN_ID = RN.RN_RUN_ID

LEFT JOIN 
(
SELECT 
BG_BUG_ID,
BG_STATUS,
BG_DETECTION_DATE,
BG_CLOSING_DATE,
LN_ENTITY_ID,
LN_ENTITY_TYPE
FROM '||x.db_name||'.BUG 
JOIN '||x.db_name||'.LINK  ON LN_BUG_ID = BG_BUG_ID AND LN_ENTITY_TYPE IN (''RUN'',''TESTCYCL'',''STEP'')
WHERE BG_STATUS != ''Canceled''
) B ON 
(B.LN_ENTITY_ID = TC.TC_TESTCYCL_ID AND B.LN_ENTITY_TYPE = ''TESTCYCL'') OR
(B.LN_ENTITY_ID = RN.RN_RUN_ID AND B.LN_ENTITY_TYPE = ''RUN'') OR
(B.LN_ENTITY_ID = ST.ST_ID  AND B.LN_ENTITY_TYPE = ''STEP'') 

WHERE B.BG_BUG_ID IS NOT NULL 
ORDER BY B.BG_BUG_ID ASC
';

end loop;*/


execute immediate  'insert into ALM_REPORT.CURVA_2 
select * from CURVA_2@SERVER_BCH
';

end;

/
