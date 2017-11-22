--------------------------------------------------------
--  DDL for Procedure cargarProyectosPorMes
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ALM_REPORT"."cargarProyectosPorMes" AS

BEGIN
execute immediate 'TRUNCATE TABLE ALM_REPORT.PROYECTOS_POR_MES';



for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME from alm_siteadmin_db_12.projects where domain_name in ('PROYECTOS') and PR_IS_ACTIVE = 'Y' ) loop
execute immediate  'insert into ALM_REPORT.PROYECTOS_POR_MES

SELECT
TC.TC_TESTCYCL_ID, 
TC.TC_STATUS,
TC.TC_EXEC_DATE,
RC.RCYC_ID,
RC.RCYC_NAME,
'''||x.db_name||'.'' || R.REL_ID ,
R.REL_NAME ,
'''||x.DOMAIN_NAME||''' as dominio,
'''||x.PROJECT_NAME||''' as esquema

FROM 
'||x.db_name||'.TESTCYCL TC
JOIN '||x.db_name||'.RELEASE_CYCLES RC ON RC.RCYC_ID = TC.TC_ASSIGN_RCYC
JOIN '||x.db_name||'.RELEASES R ON R.REL_ID = RC.RCYC_PARENT_ID

 ';


end loop;

for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME from alm_siteadmin_db_12.projects where DB_NAME = 'bch_qcsitebch_db') loop

execute immediate  'insert into ALM_REPORT.PROYECTOS_POR_MES
SELECT
TC.TC_TESTCYCL_ID, 
TC.TC_STATUS,
TC.TC_EXEC_DATE,
RC.RCYC_ID,
RC.RCYC_NAME,
'''||x.db_name||'.'' || R.REL_ID ,
R.REL_NAME ,
'''||x.DOMAIN_NAME||''' as dominio,
'''||x.PROJECT_NAME||''' as esquema

FROM 
'||x.db_name||'.TESTCYCL TC
JOIN '||x.db_name||'.RELEASE_CYCLES RC ON RC.RCYC_ID = TC.TC_ASSIGN_RCYC
JOIN '||x.db_name||'.RELEASES R ON R.REL_ID = RC.RCYC_PARENT_ID

WHERE
R.REL_ID IN (
SELECT
R.REL_ID 
FROM
 '||x.db_name||'.RELEASES R
LEFT JOIN  '||x.db_name||'.RELEASE_CYCLES RC ON RC.RCYC_PARENT_ID = R.REL_ID
LEFT JOIN  '||x.db_name||'.TESTCYCL TC ON TC.TC_ASSIGN_RCYC = RC.RCYC_ID
WHERE
TC.TC_EXEC_DATE >= TO_DATE(''01/08/2015'',''dd/mm/yyyy'')   AND
TC.TC_EXEC_DATE <= TO_DATE(to_char(last_day(SYSDATE),''dd'')||''/''||TO_CHAR(SYSDATE,''mm'')||''/2016'', ''dd/mm/yyyy'')
GROUP BY  R.REL_ID)
AND
R.REL_PARENT_ID IN (SELECT RF.RF_ID FROM  '||x.db_name||'.RELEASE_FOLDERS RF  START WITH RF.RF_ID = 128 CONNECT BY PRIOR RF.RF_ID = RF_PARENT_ID)

 ';

end loop;


for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME from alm_siteadmin_db_12.projects WHERE DB_NAME = 'proveedores_testing_sqa_db') loop

execute immediate  'insert into ALM_REPORT.PROYECTOS_POR_MES

SELECT
TC.TC_TESTCYCL_ID, 
TC.TC_STATUS,
TC.TC_EXEC_DATE,
RC.RCYC_ID,
RC.RCYC_NAME,
'''||x.db_name||'.'' || R.REL_ID ,
R.REL_NAME ,
'''||x.DOMAIN_NAME||''' as dominio,
'''||x.PROJECT_NAME||''' as esquema

FROM 
'||x.db_name||'.TESTCYCL TC
JOIN '||x.db_name||'.RELEASE_CYCLES RC ON RC.RCYC_ID = TC.TC_ASSIGN_RCYC
JOIN '||x.db_name||'.RELEASES R ON R.REL_ID = RC.RCYC_PARENT_ID


 ';

end loop;

for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME from alm_siteadmin_db_12.projects WHERE DB_NAME = 'bch_qa_certificación_bch_qa_d') loop

execute immediate  'insert into ALM_REPORT.PROYECTOS_POR_MES

SELECT
TC.TC_TESTCYCL_ID, 
TC.TC_STATUS,
TC.TC_EXEC_DATE,
RC.RCYC_ID,
RC.RCYC_NAME,
'''||x.db_name||'.'' || R.REL_ID ,
R.REL_NAME ,
'''||x.DOMAIN_NAME||''' as dominio,
'''||x.PROJECT_NAME||''' as esquema

FROM 
'||x.db_name||'.TESTCYCL TC
JOIN '||x.db_name||'.RELEASE_CYCLES RC ON RC.RCYC_ID = TC.TC_ASSIGN_RCYC
JOIN '||x.db_name||'.RELEASES R ON R.REL_ID = RC.RCYC_PARENT_ID

 ';

end loop;

for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME from alm_siteadmin_db_12.projects WHERE DB_NAME = 'qa_qa_db0') loop

execute immediate  'insert into ALM_REPORT.PROYECTOS_POR_MES

SELECT
TC.TC_TESTCYCL_ID, 
TC.TC_STATUS,
TC.TC_EXEC_DATE,
RC.RCYC_ID,
RC.RCYC_NAME,
'''||x.db_name||'.'' || R.REL_ID ,
R.REL_NAME ,
'''||x.DOMAIN_NAME||''' as dominio,
'''||x.PROJECT_NAME||''' as esquema

FROM 
'||x.db_name||'.TESTCYCL TC
JOIN '||x.db_name||'.RELEASE_CYCLES RC ON RC.RCYC_ID = TC.TC_ASSIGN_RCYC
JOIN '||x.db_name||'.RELEASES R ON R.REL_ID = RC.RCYC_PARENT_ID

 ';

end loop;

end;

/
