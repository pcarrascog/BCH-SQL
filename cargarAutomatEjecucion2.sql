--------------------------------------------------------
--  DDL for Procedure cargarAutomatEjecucion2
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ALM_REPORT"."cargarAutomatEjecucion2" AS
BEGIN
execute immediate  'TRUNCATE TABLE ALM_REPORT.CASOS_AUTOMATICOS_EJECUCION2';
for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME from alm_siteadmin_db_12.projects where domain_name in ('PROYECTOS') and PR_IS_ACTIVE = 'Y' ) loop
execute immediate  'insert into ALM_REPORT.CASOS_AUTOMATICOS_EJECUCION2
SELECT
DISTINCT 
'''||x.PROJECT_NAME||''' as esquema,
R.REL_NAME ,
R.REL_START_DATE ,
R.REL_END_DATE ,
ALM_REPORT.DIASENTRE(R.REL_START_DATE , R.REL_END_DATE) as diferencia,
TC.TC_TESTCYCL_ID,
TC.TC_SUBTYPE_ID,
TC.TC_EXEC_DATE,
''A'' as asociacion
 


FROM
'||x.DB_NAME||'.RELEASES R 
JOIN '||x.DB_NAME||'.RELEASE_CYCLES RC ON RC.RCYC_PARENT_ID = R.REL_ID
LEFT JOIN '||x.DB_NAME||'.TESTCYCL TC ON TC.TC_ASSIGN_RCYC = RC.RCYC_ID

';


end loop;

for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME from alm_siteadmin_db_12.projects where domain_name in ('PROYECTOS') and PR_IS_ACTIVE = 'Y' ) loop
execute immediate  'insert into ALM_REPORT.CASOS_AUTOMATICOS_EJECUCION2
SELECT
DISTINCT 
'''||x.PROJECT_NAME||''' as esquema,
R.REL_NAME ,
R.REL_START_DATE ,
R.REL_END_DATE ,
ALM_REPORT.DIASENTRE(R.REL_START_DATE , R.REL_END_DATE) as diferencia,
TC.TC_TESTCYCL_ID,
TC.TC_SUBTYPE_ID,
TC.TC_EXEC_DATE,
''A'' as asociacion
 


FROM
'||x.DB_NAME||'.RELEASES R1
LEFT JOIN CONTINUIDAD_AUTOMATIZACIÓN_DB.RELEASES R ON R.REL_USER_03 = R1.REL_USER_03
LEFT JOIN CONTINUIDAD_AUTOMATIZACIÓN_DB.RELEASE_CYCLES RC ON RC.RCYC_PARENT_ID = R.REL_ID
LEFT JOIN CONTINUIDAD_AUTOMATIZACIÓN_DB.TESTCYCL TC ON TC.TC_ASSIGN_RCYC = RC.RCYC_ID 

';


end loop;

end;


/
