--------------------------------------------------------
--  DDL for Procedure cargarAU_TEST_CAMPOSVACIOS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ALM_REPORT"."cargarAU_TEST_CAMPOSVACIOS" AS
BEGIN
execute immediate 'TRUNCATE TABLE ALM_REPORT.AU_TEST_CAMPOSVACIOS';

for x in (select DB_NAME, PROJECT_NAME from alm_siteadmin_db_12.projects where domain_name in ('PROYECTOS') and PR_IS_ACTIVE = 'Y' ) loop
execute immediate  'insert into ALM_REPORT.AU_TEST_CAMPOSVACIOS
SELECT
DISTINCT 
T.TS_TEST_ID,
T.TS_STATUS,
T.TS_NAME,
T.TS_RESPONSIBLE,
T.TS_CREATION_DATE,
(SELECT MAX(PADRE.RQ_USER_12) 
FROM '||x.DB_NAME||'.TEST 
LEFT JOIN '||x.DB_NAME||'.REQ_COVER RC ON RC.RC_ENTITY_ID = TS_TEST_ID AND RC.RC_ENTITY_TYPE = ''TEST''
LEFT JOIN '||x.DB_NAME||'.REQ RQ ON RQ.RQ_REQ_ID = RC.RC_REQ_ID 
LEFT JOIN '||x.DB_NAME||'.REQ PADRE ON PADRE.RQ_REQ_ID = RQ.RQ_FATHER_ID
WHERE TS_TEST_ID = T.TS_TEST_ID) as coordinador ,

(SELECT MAX(REL_USER_04) 
FROM '||x.DB_NAME||'.TEST 
LEFT JOIN '||x.DB_NAME||'.REQ_COVER RC ON RC.RC_ENTITY_ID = TS_TEST_ID AND RC.RC_ENTITY_TYPE = ''TEST''
LEFT JOIN '||x.DB_NAME||'.REQ RQ ON RQ.RQ_REQ_ID = RC.RC_REQ_ID 
LEFT JOIN '||x.DB_NAME||'.REQ_RELEASES ON RQRL_REQ_ID = RQ_REQ_ID
LEFT JOIN '||x.DB_NAME||'.RELEASES ON REL_ID = RQRL_RELEASE_ID
WHERE TS_TEST_ID = T.TS_TEST_ID) as jpqa ,

T.TS_VTS,
'''||x.PROJECT_NAME||''' as esquema,
T.TS_USER_03 "funcion de negocio",
T.TS_USER_01 "sistema",
T.TS_USER_05 "tipo de caso",
T.TS_TYPE "tipo",
T.TS_USER_02 "Producto",
T.TS_USER_07 "tipo de prueba",
T.TS_USER_06,
(SELECT  count(DISTINCT  RQ_USER_02)
FROM  '||x.db_name||'.REQ
WHERE RQ_TYPE_ID = 101 
AND RQ_USER_02 NOT IN (''Términado QA'',''Finalizado'',''Cancelado'',''En Producción'',''Pospuesto'',''Cerrado QA'',''Traspaso a Continuidad'') )  as estado

FROM
'||x.DB_NAME||'.TEST T
 


WHERE 
(
T.TS_USER_03 IS NULL OR 
T.TS_USER_01 IS NULL OR
T.TS_USER_05 IS NULL OR
T.TS_TYPE    IS NULL OR
T.TS_USER_02 IS NULL OR
T.TS_USER_07 IS NULL OR
T.TS_USER_06 IS NULL
)


';

end loop;


end;

/
