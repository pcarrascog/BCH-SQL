--------------------------------------------------------
--  DDL for Procedure cargarAU_TEST_PASOS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ALM_REPORT"."cargarAU_TEST_PASOS" AS
BEGIN
execute immediate 'TRUNCATE TABLE ALM_REPORT.AU_TEST_PASOS';

for x in (select DB_NAME, PROJECT_NAME from alm_siteadmin_db_12.projects where domain_name in ('PROYECTOS') and PR_IS_ACTIVE = 'Y' ) loop
execute immediate  'insert into ALM_REPORT.AU_TEST_PASOS
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
COUNT(DISTINCT DS_ID) as numero_pasos,
T.TS_TYPE,

(SELECT  count(DISTINCT  RQ_USER_02)
FROM  '||x.db_name||'.REQ
WHERE RQ_TYPE_ID = 101 
AND RQ_USER_02 NOT IN (''Términado QA'',''Finalizado'',''Cancelado'',''En Producción'',''Pospuesto'',''Cerrado QA'',''Traspaso a Continuidad'') )  as estado

FROM
'||x.DB_NAME||'.TEST T

JOIN '||x.DB_NAME||'.DESSTEPS DS ON DS.DS_TEST_ID = T.TS_TEST_ID
LEFT JOIN '||x.DB_NAME||'.ALL_LISTS AL ON T.TS_SUBJECT = AL.AL_ITEM_ID

WHERE T.TS_TYPE LIKE ''%MANUAL%'' 
and TS_STATUS  not like ''%Cancelado%'' 
and  ts_user_02 not like ''%Genérico%''
AND AL.AL_DESCRIPTION NOT IN ''Genericos''

HAVING 
COUNT(DISTINCT DS_ID) <= 2

GROUP BY
T.TS_TEST_ID,
T.TS_STATUS,
T.TS_NAME,
T.TS_RESPONSIBLE,
T.TS_CREATION_DATE,
T.TS_VTS,
T.TS_TYPE

';

end loop;


end;

/
