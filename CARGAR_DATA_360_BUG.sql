--------------------------------------------------------
--  DDL for Procedure CARGAR_DATA_360_BUG
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ALM_REPORT"."CARGAR_DATA_360_BUG" AS 
BEGIN
  
execute immediate 'TRUNCATE TABLE ALM_REPORT.DATA_360_BUG';

for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME from alm_siteadmin_db_12.projects where DB_NAME = 'bch_qa_certificación_bch_qa_d') loop
execute immediate  'insert into ALM_REPORT.DATA_360_BUG 

SELECT 
'''||x.PROJECT_NAME||''' as Proyecto,
'''||x.DOMAIN_NAME||''' as dominio,   
REL.rel_id AS ID_REL, REL.REL_USER_TEMPLATE_01 AS JPQA, REL.REL_USER_TEMPLATE_02 AS JEFE_AREA_DESARROLLO, 
RCYC_ID AS NOMBRE_CICLO,
RQ.RQ_USER_04 AS ESTADO_REQUERIMIENTO,
BG_SEVERITY AS SEVERIDAD, BG_USER_08 AS TIPO_ERROR, COUNT(DISTINCT(BG_BUG_ID)) as total_defectos,
''SERVIDOR TSOFT'' as SERVIDOR

FROM  '||x.db_name||'.BUG b
JOIN '||x.db_name||'.RELEASES REL ON b.BG_TARGET_REL = REL.REL_ID      
JOIN '||x.db_name||'.RELEASE_CYCLES ON BG_TARGET_RCYC = RCYC_ID
JOIN '||x.db_name||'.REQ_RELEASES RQR ON RQR.RQRL_RELEASE_ID=REL.REL_ID
JOIN '||x.db_name||'.REQ RQ ON RQ.RQ_REQ_ID=RQR.RQRL_REQ_ID
WHERE 1=1
AND RQ_TYPE_ID IN (''119'',''117'',''107'',''116'')
AND RCYC_NAME NOT LIKE ''%IDC%''
group by REL.rel_id, REL.REL_USER_TEMPLATE_01, REL.REL_USER_TEMPLATE_02,
RCYC_ID, 
RQ.RQ_USER_04,
BG_SEVERITY, BG_USER_08

';
end loop;  


execute immediate  'insert into ALM_REPORT.DATA_360_BUG 
select "DOMINIO",	"PROYECTO",	"ID_RELEASE",	"JPQA",	"JEFE_AREA_DESARROLLO",	"NOMBRE_CICLO",	"ESTADO_REQUERIMIENTO",	"SEVERIDAD",	"TIPO_ERROR",	"TOTAL_DEFECTOS",	"SERVIDOR" from DATA_360_BUG@SERVER_BCH
';

  
END CARGAR_DATA_360_BUG;

/
