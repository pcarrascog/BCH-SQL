--------------------------------------------------------
--  DDL for Procedure cargarAuPActivos_fechaManual
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ALM_REPORT"."cargarAuPActivos_fechaManual" (fecha_inicio in VARCHAR2, fecha_fin in VARCHAR2) AS
BEGIN
execute immediate 'TRUNCATE TABLE ALM_REPORT.PROYECTOS_ACTIVOS_CONTINUIDAD';
for x in (select DB_NAME from alm_siteadmin_db_12.projects where domain_name in ('CONTINUIDAD')) loop
execute immediate  'insert into ALM_REPORT.PROYECTOS_ACTIVOS_CONTINUIDAD
SELECT
R.REL_ID ,
R.REL_NAME ,

(SELECT DISTINCT  RQ_REQ_ID
FROM  '||x.db_name||'.REQ,  '||x.db_name||'.REQ_RELEASES 
WHERE RQ_TYPE_ID = 107 AND RQRL_RELEASE_ID = R.REL_ID and RQRL_REQ_ID = RQ_REQ_ID) 
 as requerimiento,

(SELECT DISTINCT  RQ_REQ_DATE
FROM  '||x.db_name||'.REQ,  '||x.db_name||'.REQ_RELEASES 
WHERE RQ_TYPE_ID = 107 AND RQRL_RELEASE_ID = R.REL_ID and RQRL_REQ_ID = RQ_REQ_ID) as fecha_creacion,

(SELECT DISTINCT  RQ_USER_04
FROM  '||x.db_name||'.REQ,  '||x.db_name||'.REQ_RELEASES 
WHERE RQ_TYPE_ID = 107 AND RQRL_RELEASE_ID = R.REL_ID and RQRL_REQ_ID = RQ_REQ_ID) as estado,

'''||x.db_name||''' as esquema

FROM 
'||x.db_name||'.RELEASES R 

WHERE
R.REL_ID IN (
SELECT
R.REL_ID 
FROM
 '||x.db_name||'.RELEASES R
LEFT JOIN  '||x.db_name||'.RELEASE_CYCLES RC ON RC.RCYC_PARENT_ID = R.REL_ID
LEFT JOIN  '||x.db_name||'.TESTCYCL TC ON TC.TC_ASSIGN_RCYC = RC.RCYC_ID
WHERE
TC.TC_EXEC_DATE >= TO_DATE('''||fecha_inicio||''',''dd/mm/yyyy'')   AND
TC.TC_EXEC_DATE <= TO_DATE('''||fecha_fin||''', ''dd/mm/yyyy'')
GROUP BY  R.REL_ID)
AND

R.REL_PARENT_ID IN (SELECT RF.RF_ID FROM '||x.db_name||'.RELEASE_FOLDERS RF  
START WITH RF.RF_ID = 128 
CONNECT BY PRIOR RF.RF_ID = RF_PARENT_ID) '; 
end loop;
END;

/
