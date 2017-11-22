--------------------------------------------------------
--  DDL for Procedure cargarDefectos_fechaManual
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ALM_REPORT"."cargarDefectos_fechaManual" (fecha_inicio in VARCHAR2, fecha_fin in VARCHAR2) AS
BEGIN

execute immediate 'TRUNCATE TABLE ALM_REPORT.DEFECTOS';

for x in (select DB_NAME from alm_siteadmin_db_12.projects where domain_name in ('PROYECTOS')) loop
execute immediate  'insert into ALM_REPORT.DEFECTOS
SELECT
B.BG_BUG_ID "Id Defecto",
B.BG_DETECTION_DATE "Fecha Detección"  ,
CASE WHEN  B.BG_CLOSING_DATE IS NULL THEN  sysdate ELSE  B.BG_CLOSING_DATE END "Fecha de Cierre",
B.BG_PRIORITY "Prioridad" ,
B.BG_SEVERITY "Severidad" ,
B.BG_STATUS "Estado"   ,
B.BG_RESPONSIBLE "Responsable",
'''||x.db_name||'.'' || R.REL_ID "Id Version",
R.REL_NAME "Version Destino",
RC.RCYC_NAME "Nombre Ciclo",
'''||x.db_name||'.'' ||  RC.RCYC_ID "ID Ciclo",

CASE WHEN ((SELECT COUNT(AP.AP_NEW_VALUE )
FROM '||x.db_name||'.AUDIT_LOG AU
JOIN '||x.db_name||'.AUDIT_PROPERTIES AP ON AP.AP_ACTION_ID = AU.AU_ACTION_ID AND AP.AP_NEW_VALUE = ''Ready to Test''
AND AP.AP_PROPERTY_NAME = ''06 - Estado''  --Retrasa los tiempos
WHERE AU.AU_ENTITY_ID = cast(B.BG_BUG_ID as varchar(200)))- 1  ) = -1 THEN 0 ELSE
((SELECT COUNT(AP.AP_NEW_VALUE )
FROM '||x.db_name||'.AUDIT_LOG AU
JOIN '||x.db_name||'.AUDIT_PROPERTIES AP ON AP.AP_ACTION_ID = AU.AU_ACTION_ID AND AP.AP_NEW_VALUE = ''Ready to Test''
AND AP.AP_PROPERTY_NAME = ''06 - Estado''  --Retrasa los tiempos
WHERE AU.AU_ENTITY_ID = cast(B.BG_BUG_ID as varchar(200)))- 1  ) END  "Iteraciones",

'''||x.db_name||''' as esquema,

''PROYECTOS'' as dominio

FROM   '||x.db_name||'.BUG B
JOIN '||x.db_name||'.RELEASES R ON R.REL_ID = B.BG_TARGET_REL
JOIN '||x.db_name||'.RELEASE_CYCLES RC ON RC.RCYC_ID = B.BG_TARGET_RCYC

WHERE
B.BG_STATUS NOT IN (''Canceled'',''Cancelado'') ';

end loop;

for x in (select DB_NAME from alm_siteadmin_db_12.projects where domain_name in ('CONTINUIDAD')) loop
execute immediate  'insert into ALM_REPORT.DEFECTOS
SELECT
B.BG_BUG_ID "Id Defecto",
B.BG_DETECTION_DATE "Fecha Detección"  ,
CASE WHEN  B.BG_CLOSING_DATE IS NULL THEN  sysdate ELSE  B.BG_CLOSING_DATE END "Fecha de Cierre",
B.BG_PRIORITY "Prioridad" ,
B.BG_SEVERITY "Severidad" ,
B.BG_STATUS "Estado"   ,
B.BG_RESPONSIBLE "Responsable",
'''||x.db_name||'.'' ||  R.REL_ID "Id Version",
R.REL_NAME "Version Destino",
RC.RCYC_NAME "Nombre Ciclo",
'''||x.db_name||'.'' ||  RC.RCYC_ID "ID Ciclo",

CASE WHEN ((SELECT COUNT(AP.AP_NEW_VALUE )
FROM '||x.db_name||'.AUDIT_LOG AU
JOIN '||x.db_name||'.AUDIT_PROPERTIES AP ON AP.AP_ACTION_ID = AU.AU_ACTION_ID AND AP.AP_NEW_VALUE = ''Listo para Probar''
AND AP.AP_PROPERTY_NAME = ''06- Estado''  --Retrasa los tiempos
WHERE AU.AU_ENTITY_ID = cast(B.BG_BUG_ID as varchar(200)))- 1  ) = -1 THEN 0 ELSE
((SELECT COUNT(AP.AP_NEW_VALUE )
FROM '||x.db_name||'.AUDIT_LOG AU
JOIN '||x.db_name||'.AUDIT_PROPERTIES AP ON AP.AP_ACTION_ID = AU.AU_ACTION_ID AND AP.AP_NEW_VALUE = ''Listo para Probar''
AND AP.AP_PROPERTY_NAME = ''06- Estado''  --Retrasa los tiempos
WHERE AU.AU_ENTITY_ID = cast(B.BG_BUG_ID as varchar(200)))- 1  ) END  "Iteraciones",

'''||x.db_name||''' as esquema,

''CONTINUIDAD'' as dominio

FROM   '||x.db_name||'.BUG B
JOIN '||x.db_name||'.RELEASES R ON R.REL_ID = B.BG_TARGET_REL
JOIN '||x.db_name||'.RELEASE_CYCLES RC ON RC.RCYC_ID = B.BG_TARGET_RCYC

WHERE
B.BG_STATUS NOT IN (''Canceled'',''Cancelado'')  AND
R.REL_ID IN
(SELECT
R.REL_ID "Id Version"
FROM
'||x.db_name||'.RELEASES R
LEFT JOIN '||x.db_name||'.RELEASE_CYCLES RC ON RC.RCYC_PARENT_ID = R.REL_ID
LEFT JOIN '||x.db_name||'.TESTCYCL TC ON TC.TC_ASSIGN_RCYC = RC.RCYC_ID
WHERE
TC.TC_EXEC_DATE >= TO_DATE('''||fecha_inicio||''',''dd/mm/yyyy'')   AND
TC.TC_EXEC_DATE <= TO_DATE('''||fecha_fin||''', ''dd/mm/yyyy'')

GROUP BY  R.REL_ID)
AND 
R.REL_PARENT_ID IN (SELECT RF.RF_ID FROM '||x.db_name||'.RELEASE_FOLDERS RF  START WITH RF.RF_ID = 128 CONNECT BY PRIOR RF.RF_ID = RF_PARENT_ID)

';

end loop;


for x in (select DB_NAME from alm_siteadmin_db_12.projects WHERE DB_NAME = 'proveedores_testing_sqa_db') loop
execute immediate  'insert into ALM_REPORT.DEFECTOS
SELECT
B.BG_BUG_ID "Id Defecto",
B.BG_DETECTION_DATE "Fecha Detección"  ,
CASE WHEN  B.BG_CLOSING_DATE IS NULL THEN  sysdate ELSE  B.BG_CLOSING_DATE END "Fecha de Cierre",
B.BG_PRIORITY "Prioridad" ,
B.BG_SEVERITY "Severidad" ,
B.BG_STATUS "Estado"   ,
B.BG_RESPONSIBLE "Responsable",
'''||x.db_name||'.'' || R.REL_ID "Id Version",
R.REL_NAME "Version Destino",
RC.RCYC_NAME "Nombre Ciclo",
'''||x.db_name||'.'' ||  RC.RCYC_ID "ID Ciclo",

CASE WHEN ((SELECT COUNT(AP.AP_NEW_VALUE )
FROM '||x.db_name||'.AUDIT_LOG AU
JOIN '||x.db_name||'.AUDIT_PROPERTIES AP ON AP.AP_ACTION_ID = AU.AU_ACTION_ID AND AP.AP_NEW_VALUE = ''Ready to Test''
AND AP.AP_PROPERTY_NAME = ''06 - Estado''  --Retrasa los tiempos
WHERE AU.AU_ENTITY_ID = cast(B.BG_BUG_ID as varchar(200)))- 1  ) = -1 THEN 0 ELSE
((SELECT COUNT(AP.AP_NEW_VALUE )
FROM '||x.db_name||'.AUDIT_LOG AU
JOIN '||x.db_name||'.AUDIT_PROPERTIES AP ON AP.AP_ACTION_ID = AU.AU_ACTION_ID AND AP.AP_NEW_VALUE = ''Ready to Test''
AND AP.AP_PROPERTY_NAME = ''06 - Estado''  --Retrasa los tiempos
WHERE AU.AU_ENTITY_ID = cast(B.BG_BUG_ID as varchar(200)))- 1  ) END  "Iteraciones",

'''||x.db_name||''' as esquema,

''SQA'' as dominio

FROM   '||x.db_name||'.BUG B
JOIN '||x.db_name||'.RELEASES R ON R.REL_ID = B.BG_TARGET_REL
JOIN '||x.db_name||'.RELEASE_CYCLES RC ON RC.RCYC_ID = B.BG_TARGET_RCYC

WHERE
B.BG_STATUS NOT IN (''Canceled'',''Cancelado'')  ';

end loop;



end;


/
