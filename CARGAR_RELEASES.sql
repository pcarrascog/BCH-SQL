--------------------------------------------------------
--  DDL for Procedure CARGAR_RELEASES
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ALM_REPORT"."CARGAR_RELEASES" AS 
BEGIN
 execute immediate 'TRUNCATE TABLE ALM_REPORT.DATA_RELEASES';
 
for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME from alm_siteadmin_db_12.projects where DB_NAME = 'bch_qa_certificación_bch_qa_d') loop
execute immediate  'insert into ALM_REPORT.DATA_RELEASES 

SELECT
''/'' ||  RF5.RF_NAME || ''/'' ||  RF4.RF_NAME || ''/'' ||  RF3.RF_NAME || ''/'' ||  RF2.RF_NAME || ''/'' ||  RF1.RF_NAME || ''/'' || RF.RF_NAME AS RUTA,
RE.REL_ID AS ID_RELEASES,
RE.REL_NAME AS NOMBRE_RELEASES,
'''||x.PROJECT_NAME||''' as Proyecto,
'''||x.DOMAIN_NAME||'''as dominio,
REL_START_DATE as FECHA_INICIO_REL,
REL_USER_TEMPLATE_01 as JP_QA,
TO_DATE(REL_USER_02,''yyyy/mm/dd'') as FECHA_FIN_REL,
RE.REL_USER_01 AS NUM_ART,
''SERVIDOR TSOFT'' as Servidor

FROM '||x.db_name||'.RELEASES RE
LEFT JOIN '||x.db_name||'.RELEASE_FOLDERS RF ON  RF.RF_ID = RE.REL_PARENT_ID
LEFT JOIN '||x.db_name||'.RELEASE_FOLDERS RF1 ON RF1.RF_ID = RF.RF_PARENT_ID
LEFT JOIN '||x.db_name||'.RELEASE_FOLDERS RF2 ON RF2.RF_ID = RF1.RF_PARENT_ID
LEFT JOIN '||x.db_name||'.RELEASE_FOLDERS RF3 ON RF3.RF_ID = RF2.RF_PARENT_ID
LEFT JOIN '||x.db_name||'.RELEASE_FOLDERS RF4 ON RF4.RF_ID = RF3.RF_PARENT_ID
LEFT JOIN '||x.db_name||'.RELEASE_FOLDERS RF5 ON RF5.RF_ID = RF4.RF_PARENT_ID

WHERE 1=1
--AND(RF.RF_PATH not like ''AAAAAB%''  AND RF.RF_PATH not like ''AAAAAF%'' AND RF.RF_PATH not like ''AAAAAC%'' AND RF.RF_PATH not like ''AAAAAD%'' AND RF.RF_PATH not like ''AAAAAE%'')

'; end loop;

for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME  from alm_siteadmin_db_12.projects where DB_NAME = 'qa_qa_db0') loop
execute immediate  'insert into ALM_REPORT.DATA_RELEASES

SELECT
''/'' ||  RF5.RF_NAME || ''/'' ||  RF4.RF_NAME || ''/'' ||  RF3.RF_NAME || ''/'' ||  RF2.RF_NAME || ''/'' ||  RF1.RF_NAME || ''/'' || RF.RF_NAME AS RUTA,
RE.REL_ID AS ID_RELEASES,
RE.REL_NAME AS NOMBRE_RELEASES,
'''||x.PROJECT_NAME||''' as Proyecto,
'''||x.DOMAIN_NAME||'''as dominio,
REL_START_DATE as FECHA_INICIO_REL,
REL_USER_05 as JP_QA,
TO_DATE(REL_USER_03,''yyyy/mm/dd'') as FECHA_FIN_REL,
RE.REL_USER_04 AS NUM_ART,
''SERVIDOR TSOFT'' as Servidor

FROM '||x.db_name||'.RELEASES RE
LEFT JOIN '||x.db_name||'.RELEASE_FOLDERS RF ON  RF.RF_ID = RE.REL_PARENT_ID
LEFT JOIN '||x.db_name||'.RELEASE_FOLDERS RF1 ON RF1.RF_ID = RF.RF_PARENT_ID
LEFT JOIN '||x.db_name||'.RELEASE_FOLDERS RF2 ON RF2.RF_ID = RF1.RF_PARENT_ID
LEFT JOIN '||x.db_name||'.RELEASE_FOLDERS RF3 ON RF3.RF_ID = RF2.RF_PARENT_ID
LEFT JOIN '||x.db_name||'.RELEASE_FOLDERS RF4 ON RF4.RF_ID = RF3.RF_PARENT_ID
LEFT JOIN '||x.db_name||'.RELEASE_FOLDERS RF5 ON RF5.RF_ID = RF4.RF_PARENT_ID


WHERE 1=1
--AND(RF.RF_PATH not like ''AAAAAB%''  AND RF.RF_PATH not like ''AAAAAF%'' AND RF.RF_PATH not like ''AAAAAC%'' AND RF.RF_PATH not like ''AAAAAD%'' AND RF.RF_PATH not like ''AAAAAE%'')

'; end loop;

execute immediate  'insert into ALM_REPORT.DATA_RELEASES 
select * from DATA_RELEASES@SERVER_BCH
';
 
END;

/
