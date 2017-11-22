--------------------------------------------------------
--  DDL for Procedure CARGAR_DEFEC
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ALM_REPORT"."CARGAR_DEFEC" AS 
BEGIN
execute immediate 'TRUNCATE TABLE ALM_REPORT.DEFEC_LINKIADOS';


for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME from alm_siteadmin_db_12.projects 
          where domain_name in ('PROYECTOS') and PR_IS_ACTIVE = 'Y' ) loop
execute immediate  'insert into ALM_REPORT.DEFEC_LINKIADOS 
SELECT 
BG_BUG_ID Id_bug, 
BG_RESPONSIBLE Responsable,  
BG_USER_05 Sistema,  
TEST.TS_NAME Nombre_Caso,  
BUG.BG_USER_01  Estado, 
TEST.TS_EXEC_STATUS Estado_Caso ,
R.REL_NAME Release,
RC.RCYC_NAME nombre_ciclo,
'''||x.PROJECT_NAME||''' as Proyecto,
'''||x.DOMAIN_NAME||'''as dominio,
LN_ENTITY_TYPE as entidad,

BG_DETECTION_DATE as Fecha_detect,
BG_SUMMARY AS Comentario,
BG_USER_06 as tipo_error ,
BG_STATUS AS estado_defec,
R.REL_ID AS REL_ID ,
nvl (re.Cant_rea,0),
''SERVIDOR TSOFT'' as SERVIDOR

--RUN
FROM '||x.db_name||'.BUG
inner JOIN '||x.db_name||'.LINK ON LN_BUG_ID = BG_BUG_ID AND LN_ENTITY_TYPE = ''RUN''
LEFT JOIN '||x.db_name||'.RUN ON LN_ENTITY_ID = RN_RUN_ID
LEFT JOIN '||x.db_name||'.TEST  ON RN_TEST_ID = TS_TEST_ID
left JOIN '||x.db_name||'.RELEASES R ON R.REL_ID = BG_TARGET_REL OR BG_DETECTED_IN_REL = R.REL_ID
LEFT JOIN '||x.db_name||'.RELEASE_CYCLES RC ON RC.RCYC_ID = BG_DETECTED_IN_RCYC OR BG_TARGET_RCYC = RC.RCYC_ID 
LEFT JOIN (
SELECT b.BG_BUG_ID as id_BG ,
COUNT (AP_NEW_VALUE) as Cant_rea
FROM  '||x.db_name||'.BUG b
JOIN  '||x.db_name||'.AUDIT_LOG  ON AU_ENTITY_ID = BG_BUG_ID
JOIN '||x.db_name||'.AUDIT_PROPERTIES  ON AP_ACTION_ID = AU_ACTION_ID
WHERE AU_ENTITY_TYPE = ''BUG''
AND AP_PROPERTY_NAME like ''%06- Estado%''
AND AP_NEW_VALUE  = ''Listo para Probar''
group by BG_BUG_ID
) Re  on re.ID_BG=BG_BUG_ID

--------------------------------------------------------------------------------------------------------------------------------
union all
SELECT 
BG_BUG_ID Id_bug, 
BG_RESPONSIBLE Responsable,  
BG_USER_05 Sistema,  
TEST.TS_NAME Nombre_Caso,  
BUG.BG_USER_01  Estado, 
TEST.TS_EXEC_STATUS Estado_Caso ,
R.REL_NAME Release,
RC.RCYC_NAME nombre_ciclo,
'''||x.PROJECT_NAME||''' as Proyecto,
'''||x.DOMAIN_NAME||'''as dominio,
LN_ENTITY_TYPE as entidad,

BG_DETECTION_DATE as Fecha_detect,
BG_SUMMARY AS Comentario,
BG_USER_06 as tipo_error ,
BG_STATUS AS estado_defec,
R.REL_ID AS REL_ID ,
nvl (re.Cant_rea,0),
''SERVIDOR TSOFT'' as SERVIDOR

--STEP
FROM '||x.db_name||'.BUG
inner JOIN '||x.db_name||'.LINK ON LN_BUG_ID = BG_BUG_ID AND LN_ENTITY_TYPE = ''STEP''
LEFT JOIN '||x.db_name||'.RELEASES R ON R.REL_ID = BG_TARGET_REL OR BG_DETECTED_IN_REL = R.REL_ID
LEFT JOIN '||x.db_name||'.RELEASE_CYCLES RC ON RC.RCYC_ID = BG_DETECTED_IN_RCYC OR BG_TARGET_RCYC = RC.RCYC_ID 
LEFT JOIN '||x.db_name||'.STEP ON st_id = LN_ENTITY_ID
LEFT JOIN '||x.db_name||'.RUN ON RN_RUN_ID=ST_RUN_ID
LEFT JOIN '||x.db_name||'.TEST ON RN_test_ID=TS_TEST_ID
LEFT JOIN (
SELECT b.BG_BUG_ID as id_BG ,
COUNT (AP_NEW_VALUE) as Cant_rea
FROM  '||x.db_name||'.BUG b
JOIN  '||x.db_name||'.AUDIT_LOG  ON AU_ENTITY_ID = BG_BUG_ID
JOIN '||x.db_name||'.AUDIT_PROPERTIES  ON AP_ACTION_ID = AU_ACTION_ID
WHERE AU_ENTITY_TYPE = ''BUG''
AND AP_PROPERTY_NAME like ''%06- Estado%''
AND AP_NEW_VALUE  = ''Listo para Probar''
group by BG_BUG_ID
) Re  on re.ID_BG=BG_BUG_ID
--------------------------------------------------------------------------------------------------------------------------------
union all 
SELECT 
BG_BUG_ID Id_bug, 
BG_RESPONSIBLE Responsable,  
BG_USER_05 Sistema,  
TEST.TS_NAME Nombre_Caso,  
BUG.BG_USER_01  Estado, 
TEST.TS_EXEC_STATUS Estado_Caso ,
R.REL_NAME Release,
RC.RCYC_NAME  nombre_ciclo,
'''||x.PROJECT_NAME||''' as Proyecto,
'''||x.DOMAIN_NAME||'''as dominio,
LN_ENTITY_TYPE as entidad,

BG_DETECTION_DATE as Fecha_detect,
BG_SUMMARY AS Comentario,
BG_USER_06 as tipo_error ,
BG_STATUS AS estado_defec,
R.REL_ID AS REL_ID ,
nvl (re.Cant_rea,0),
''SERVIDOR TSOFT'' as SERVIDOR

--INSTANCIA
FROM '||x.db_name||'.BUG
inner JOIN '||x.db_name||'.LINK ON LN_BUG_ID = BG_BUG_ID  AND LN_ENTITY_TYPE = ''TESTCYCL''
LEFT JOIN '||x.db_name||'.TESTCYCL ON TC_TESTCYCL_ID = LN_ENTITY_ID
LEFT JOIN '||x.db_name||'.TEST ON TC_TEST_ID = TS_TEST_ID
left JOIN '||x.db_name||'.RELEASES R ON R.REL_ID = BG_TARGET_REL OR BG_DETECTED_IN_REL = R.REL_ID
LEFT JOIN '||x.db_name||'.RELEASE_CYCLES RC ON RC.RCYC_ID = BG_DETECTED_IN_RCYC OR BG_TARGET_RCYC = RC.RCYC_ID 
LEFT JOIN (
SELECT b.BG_BUG_ID as id_BG ,
COUNT (AP_NEW_VALUE) as Cant_rea
FROM  '||x.db_name||'.BUG b
JOIN  '||x.db_name||'.AUDIT_LOG  ON AU_ENTITY_ID = BG_BUG_ID
JOIN '||x.db_name||'.AUDIT_PROPERTIES  ON AP_ACTION_ID = AU_ACTION_ID
WHERE AU_ENTITY_TYPE = ''BUG''
AND AP_PROPERTY_NAME like ''%06- Estado%''
AND AP_NEW_VALUE  = ''Listo para Probar''
group by BG_BUG_ID
) Re  on re.ID_BG=BG_BUG_ID
--------------------------------------------------------------------------------------------------------------------------------
union all 
--TEST
SELECT 
BG_BUG_ID Id_bug, 
BG_RESPONSIBLE Responsable,  
BG_USER_05 Sistema,  
TEST.TS_NAME Nombre_Caso,  
BUG.BG_USER_01  Estado, 
TEST.TS_EXEC_STATUS Estado_Caso ,
R.REL_NAME Release,
RC.RCYC_NAME nombre_ciclo,
'''||x.PROJECT_NAME||''' as Proyecto,
'''||x.DOMAIN_NAME||'''as dominio,
LN_ENTITY_TYPE as entidad,

BG_DETECTION_DATE as Fecha_detect,
BG_SUMMARY AS Comentario,
BG_USER_06 as tipo_error ,
BG_STATUS AS estado_defec,
R.REL_ID AS REL_ID ,
nvl (re.Cant_rea,0),
''SERVIDOR TSOFT'' as SERVIDOR

FROM '||x.db_name||'.BUG
inner JOIN '||x.db_name||'.LINK ON LN_BUG_ID = BG_BUG_ID  AND LN_ENTITY_TYPE = ''TEST''
LEFT JOIN '||x.db_name||'.TESTCYCL ON TC_TESTCYCL_ID = LN_ENTITY_ID
LEFT JOIN '||x.db_name||'.TEST ON TS_TEST_ID  = LN_ENTITY_ID
left JOIN '||x.db_name||'.RELEASES R ON R.REL_ID = BG_TARGET_REL OR BG_DETECTED_IN_REL = R.REL_ID
LEFT JOIN '||x.db_name||'.RELEASE_CYCLES RC ON RC.RCYC_ID = BG_DETECTED_IN_RCYC OR BG_TARGET_RCYC = RC.RCYC_ID 
LEFT JOIN (
SELECT b.BG_BUG_ID as id_BG ,
COUNT (AP_NEW_VALUE) as Cant_rea
FROM  '||x.db_name||'.BUG b
JOIN  '||x.db_name||'.AUDIT_LOG  ON AU_ENTITY_ID = BG_BUG_ID
JOIN '||x.db_name||'.AUDIT_PROPERTIES  ON AP_ACTION_ID = AU_ACTION_ID
WHERE AU_ENTITY_TYPE = ''BUG''
AND AP_PROPERTY_NAME like ''%06- Estado%''
AND AP_NEW_VALUE  = ''Listo para Probar''
group by BG_BUG_ID
) Re  on re.ID_BG=BG_BUG_ID 
';
 
 
end loop;

 
for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME from alm_siteadmin_db_12.projects WHERE DB_NAME = 'proveedores_testing_sqa_db') loop
execute immediate  'insert into ALM_REPORT.DEFEC_LINKIADOS 
SELECT 
BG_BUG_ID Id_bug, 
BG_RESPONSIBLE Responsable,  
BG_USER_05 Sistema,  
TEST.TS_NAME Nombre_Caso,  
BUG.BG_USER_01  Estado, 
TEST.TS_EXEC_STATUS Estado_Caso ,
R.REL_NAME Release,
RC.RCYC_NAME nombre_ciclo,
'''||x.PROJECT_NAME||''' as Proyecto,
'''||x.DOMAIN_NAME||'''as dominio,
LN_ENTITY_TYPE as entidad,

BG_DETECTION_DATE as Fecha_detect,
BG_SUMMARY AS Comentario,
BG_USER_06 as tipo_error ,
BG_STATUS AS estado_defec,
R.REL_ID AS REL_ID ,
nvl (re.Cant_rea,0),
''SERVIDOR TSOFT'' as SERVIDOR

--RUN
FROM '||x.db_name||'.BUG
inner JOIN '||x.db_name||'.LINK ON LN_BUG_ID = BG_BUG_ID AND LN_ENTITY_TYPE = ''RUN''
LEFT JOIN '||x.db_name||'.RUN ON LN_ENTITY_ID = RN_RUN_ID
LEFT JOIN '||x.db_name||'.TEST  ON RN_TEST_ID = TS_TEST_ID
left JOIN '||x.db_name||'.RELEASES R ON R.REL_ID = BG_TARGET_REL OR BG_DETECTED_IN_REL = R.REL_ID
LEFT JOIN '||x.db_name||'.RELEASE_CYCLES RC ON RC.RCYC_ID = BG_DETECTED_IN_RCYC OR BG_TARGET_RCYC = RC.RCYC_ID 
LEFT JOIN (
SELECT b.BG_BUG_ID as id_BG ,
COUNT (AP_NEW_VALUE) as Cant_rea
FROM  '||x.db_name||'.BUG b
JOIN  '||x.db_name||'.AUDIT_LOG  ON AU_ENTITY_ID = BG_BUG_ID
JOIN '||x.db_name||'.AUDIT_PROPERTIES  ON AP_ACTION_ID = AU_ACTION_ID
WHERE AU_ENTITY_TYPE = ''BUG''
AND AP_PROPERTY_NAME like ''%06- Estado%''
AND AP_NEW_VALUE  = ''Listo para Probar''
group by BG_BUG_ID
) Re  on re.ID_BG=BG_BUG_ID

--------------------------------------------------------------------------------------------------------------------------------
union all
SELECT 
BG_BUG_ID Id_bug, 
BG_RESPONSIBLE Responsable,  
BG_USER_05 Sistema,  
TEST.TS_NAME Nombre_Caso,  
BUG.BG_USER_01  Estado, 
TEST.TS_EXEC_STATUS Estado_Caso ,
R.REL_NAME Release,
RC.RCYC_NAME nombre_ciclo,
'''||x.PROJECT_NAME||''' as Proyecto,
'''||x.DOMAIN_NAME||'''as dominio,
LN_ENTITY_TYPE as entidad,

BG_DETECTION_DATE as Fecha_detect,
BG_SUMMARY AS Comentario,
BG_USER_06 as tipo_error ,
BG_STATUS AS estado_defec,
R.REL_ID AS REL_ID ,
nvl (re.Cant_rea,0),
''SERVIDOR TSOFT'' as SERVIDOR

--STEP
FROM '||x.db_name||'.BUG
inner JOIN '||x.db_name||'.LINK ON LN_BUG_ID = BG_BUG_ID AND LN_ENTITY_TYPE = ''STEP''
LEFT JOIN '||x.db_name||'.RELEASES R ON R.REL_ID = BG_TARGET_REL OR BG_DETECTED_IN_REL = R.REL_ID
LEFT JOIN '||x.db_name||'.RELEASE_CYCLES RC ON RC.RCYC_ID = BG_DETECTED_IN_RCYC OR BG_TARGET_RCYC = RC.RCYC_ID 
LEFT JOIN '||x.db_name||'.STEP ON st_id = LN_ENTITY_ID
LEFT JOIN '||x.db_name||'.RUN ON RN_RUN_ID=ST_RUN_ID
LEFT JOIN '||x.db_name||'.TEST ON RN_test_ID=TS_TEST_ID
LEFT JOIN (
SELECT b.BG_BUG_ID as id_BG ,
COUNT (AP_NEW_VALUE) as Cant_rea
FROM  '||x.db_name||'.BUG b
JOIN  '||x.db_name||'.AUDIT_LOG  ON AU_ENTITY_ID = BG_BUG_ID
JOIN '||x.db_name||'.AUDIT_PROPERTIES  ON AP_ACTION_ID = AU_ACTION_ID
WHERE AU_ENTITY_TYPE = ''BUG''
AND AP_PROPERTY_NAME like ''%06- Estado%''
AND AP_NEW_VALUE  = ''Listo para Probar''
group by BG_BUG_ID
) Re  on re.ID_BG=BG_BUG_ID
--------------------------------------------------------------------------------------------------------------------------------
union all 
SELECT 
BG_BUG_ID Id_bug, 
BG_RESPONSIBLE Responsable,  
BG_USER_05 Sistema,  
TEST.TS_NAME Nombre_Caso,  
BUG.BG_USER_01  Estado, 
TEST.TS_EXEC_STATUS Estado_Caso ,
R.REL_NAME Release,
RC.RCYC_NAME  nombre_ciclo,
'''||x.PROJECT_NAME||''' as Proyecto,
'''||x.DOMAIN_NAME||'''as dominio,
LN_ENTITY_TYPE as entidad,

BG_DETECTION_DATE as Fecha_detect,
BG_SUMMARY AS Comentario,
BG_USER_06 as tipo_error ,
BG_STATUS AS estado_defec,
R.REL_ID AS REL_ID ,
nvl (re.Cant_rea,0),
''SERVIDOR TSOFT'' as SERVIDOR

--INSTANCIA
FROM '||x.db_name||'.BUG
inner JOIN '||x.db_name||'.LINK ON LN_BUG_ID = BG_BUG_ID  AND LN_ENTITY_TYPE = ''TESTCYCL''
LEFT JOIN '||x.db_name||'.TESTCYCL ON TC_TESTCYCL_ID = LN_ENTITY_ID
LEFT JOIN '||x.db_name||'.TEST ON TC_TEST_ID = TS_TEST_ID
left JOIN '||x.db_name||'.RELEASES R ON R.REL_ID = BG_TARGET_REL OR BG_DETECTED_IN_REL = R.REL_ID
LEFT JOIN '||x.db_name||'.RELEASE_CYCLES RC ON RC.RCYC_ID = BG_DETECTED_IN_RCYC OR BG_TARGET_RCYC = RC.RCYC_ID 
LEFT JOIN (
SELECT b.BG_BUG_ID as id_BG ,
COUNT (AP_NEW_VALUE) as Cant_rea
FROM  '||x.db_name||'.BUG b
JOIN  '||x.db_name||'.AUDIT_LOG  ON AU_ENTITY_ID = BG_BUG_ID
JOIN '||x.db_name||'.AUDIT_PROPERTIES  ON AP_ACTION_ID = AU_ACTION_ID
WHERE AU_ENTITY_TYPE = ''BUG''
AND AP_PROPERTY_NAME like ''%06- Estado%''
AND AP_NEW_VALUE  = ''Listo para Probar''
group by BG_BUG_ID
) Re  on re.ID_BG=BG_BUG_ID
--------------------------------------------------------------------------------------------------------------------------------
union all 
--TEST
SELECT 
BG_BUG_ID Id_bug, 
BG_RESPONSIBLE Responsable,  
BG_USER_05 Sistema,  
TEST.TS_NAME Nombre_Caso,  
BUG.BG_USER_01  Estado, 
TEST.TS_EXEC_STATUS Estado_Caso ,
R.REL_NAME Release,
RC.RCYC_NAME nombre_ciclo,
'''||x.PROJECT_NAME||''' as Proyecto,
'''||x.DOMAIN_NAME||'''as dominio,
LN_ENTITY_TYPE as entidad,

BG_DETECTION_DATE as Fecha_detect,
BG_SUMMARY AS Comentario,
BG_USER_06 as tipo_error ,
BG_STATUS AS estado_defec,
R.REL_ID AS REL_ID ,
nvl (re.Cant_rea,0),
''SERVIDOR TSOFT'' as SERVIDOR

FROM '||x.db_name||'.BUG
inner JOIN '||x.db_name||'.LINK ON LN_BUG_ID = BG_BUG_ID  AND LN_ENTITY_TYPE = ''TEST''
LEFT JOIN '||x.db_name||'.TESTCYCL ON TC_TESTCYCL_ID = LN_ENTITY_ID
LEFT JOIN '||x.db_name||'.TEST ON TS_TEST_ID  = LN_ENTITY_ID
left JOIN '||x.db_name||'.RELEASES R ON R.REL_ID = BG_TARGET_REL OR BG_DETECTED_IN_REL = R.REL_ID
LEFT JOIN '||x.db_name||'.RELEASE_CYCLES RC ON RC.RCYC_ID = BG_DETECTED_IN_RCYC OR BG_TARGET_RCYC = RC.RCYC_ID 
LEFT JOIN (
SELECT b.BG_BUG_ID as id_BG ,
COUNT (AP_NEW_VALUE) as Cant_rea
FROM  '||x.db_name||'.BUG b
JOIN  '||x.db_name||'.AUDIT_LOG  ON AU_ENTITY_ID = BG_BUG_ID
JOIN '||x.db_name||'.AUDIT_PROPERTIES  ON AP_ACTION_ID = AU_ACTION_ID
WHERE AU_ENTITY_TYPE = ''BUG''
AND AP_PROPERTY_NAME like ''%06- Estado%''
AND AP_NEW_VALUE  = ''Listo para Probar''
group by BG_BUG_ID
) Re  on re.ID_BG=BG_BUG_ID 
';
 
end loop;
 

------------------------ESTRUCTURA NUEVA-----------------------------------

for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME from alm_siteadmin_db_12.projects where DB_NAME = 'bch_qa_certificación_bch_qa_d') loop
execute immediate  'insert into ALM_REPORT.DEFEC_LINKIADOS 
SELECT 
BG_BUG_ID Id_bug, 
BG_RESPONSIBLE Responsable,  
BG_USER_05 Sistema,  
TEST.TS_NAME Nombre_Caso,  
BUG.BG_USER_01  Estado, 
TEST.TS_EXEC_STATUS Estado_Caso ,
R.REL_NAME Release,
RC.RCYC_NAME nombre_ciclo,
'''||x.PROJECT_NAME||''' as Proyecto,
'''||x.DOMAIN_NAME||'''as dominio,
LN_ENTITY_TYPE as entidad,

BG_DETECTION_DATE as Fecha_detect,
BG_SUMMARY AS Comentario,
BG_USER_08 as tipo_error ,
BG_USER_01 AS estado_defec,
R.REL_ID AS REL_ID ,
nvl (re.Cant_rea,0),
''SERVIDOR TSOFT'' as SERVIDOR

--RUN
FROM '||x.db_name||'.BUG
inner JOIN '||x.db_name||'.LINK ON LN_BUG_ID = BG_BUG_ID AND LN_ENTITY_TYPE = ''RUN''
LEFT JOIN '||x.db_name||'.RUN ON LN_ENTITY_ID = RN_RUN_ID
LEFT JOIN '||x.db_name||'.TEST  ON RN_TEST_ID = TS_TEST_ID
left JOIN '||x.db_name||'.RELEASES R ON R.REL_ID = BG_TARGET_REL OR BG_DETECTED_IN_REL = R.REL_ID
LEFT JOIN '||x.db_name||'.RELEASE_CYCLES RC ON RC.RCYC_ID = BG_DETECTED_IN_RCYC OR BG_TARGET_RCYC = RC.RCYC_ID 
LEFT JOIN (
SELECT b.BG_BUG_ID as id_BG ,
COUNT (AP_NEW_VALUE) as Cant_rea
FROM  '||x.db_name||'.BUG b
JOIN  '||x.db_name||'.AUDIT_LOG  ON AU_ENTITY_ID = BG_BUG_ID
JOIN '||x.db_name||'.AUDIT_PROPERTIES  ON AP_ACTION_ID = AU_ACTION_ID
WHERE AU_ENTITY_TYPE = ''BUG''
AND AP_PROPERTY_NAME like ''%06- Estado%''
AND AP_NEW_VALUE  = ''Listo para Probar''
group by BG_BUG_ID
) Re  on re.ID_BG=BG_BUG_ID

--------------------------------------------------------------------------------------------------------------------------------
union all
SELECT 
BG_BUG_ID Id_bug, 
BG_RESPONSIBLE Responsable,  
BG_USER_05 Sistema,  
TEST.TS_NAME Nombre_Caso,  
BUG.BG_USER_01  Estado, 
TEST.TS_EXEC_STATUS Estado_Caso ,
R.REL_NAME Release,
RC.RCYC_NAME nombre_ciclo,
'''||x.PROJECT_NAME||''' as Proyecto,
'''||x.DOMAIN_NAME||'''as dominio,
LN_ENTITY_TYPE as entidad,

BG_DETECTION_DATE as Fecha_detect,
BG_SUMMARY AS Comentario,
BG_USER_08 as tipo_error ,
BG_USER_01 AS estado_defec,
R.REL_ID AS REL_ID ,
nvl (re.Cant_rea,0),
''SERVIDOR TSOFT'' as SERVIDOR

--STEP
FROM '||x.db_name||'.BUG
inner JOIN '||x.db_name||'.LINK ON LN_BUG_ID = BG_BUG_ID AND LN_ENTITY_TYPE = ''STEP''
LEFT JOIN '||x.db_name||'.RELEASES R ON R.REL_ID = BG_TARGET_REL OR BG_DETECTED_IN_REL = R.REL_ID
LEFT JOIN '||x.db_name||'.RELEASE_CYCLES RC ON RC.RCYC_ID = BG_DETECTED_IN_RCYC OR BG_TARGET_RCYC = RC.RCYC_ID 
LEFT JOIN '||x.db_name||'.STEP ON st_id = LN_ENTITY_ID
LEFT JOIN '||x.db_name||'.RUN ON RN_RUN_ID=ST_RUN_ID
LEFT JOIN '||x.db_name||'.TEST ON RN_test_ID=TS_TEST_ID
LEFT JOIN (
SELECT b.BG_BUG_ID as id_BG ,
COUNT (AP_NEW_VALUE) as Cant_rea
FROM  '||x.db_name||'.BUG b
JOIN  '||x.db_name||'.AUDIT_LOG  ON AU_ENTITY_ID = BG_BUG_ID
JOIN '||x.db_name||'.AUDIT_PROPERTIES  ON AP_ACTION_ID = AU_ACTION_ID
WHERE AU_ENTITY_TYPE = ''BUG''
AND AP_PROPERTY_NAME like ''%06- Estado%''
AND AP_NEW_VALUE  = ''Listo para Probar''
group by BG_BUG_ID
) Re  on re.ID_BG=BG_BUG_ID
--------------------------------------------------------------------------------------------------------------------------------
union all 
SELECT 
BG_BUG_ID Id_bug, 
BG_RESPONSIBLE Responsable,  
BG_USER_05 Sistema,  
TEST.TS_NAME Nombre_Caso,  
BUG.BG_USER_01  Estado, 
TEST.TS_EXEC_STATUS Estado_Caso ,
R.REL_NAME Release,
RC.RCYC_NAME  nombre_ciclo,
'''||x.PROJECT_NAME||''' as Proyecto,
'''||x.DOMAIN_NAME||'''as dominio,
LN_ENTITY_TYPE as entidad,

BG_DETECTION_DATE as Fecha_detect,
BG_SUMMARY AS Comentario,
BG_USER_08 as tipo_error ,
BG_USER_01 AS estado_defec,
R.REL_ID AS REL_ID ,
nvl (re.Cant_rea,0),
''SERVIDOR TSOFT'' as SERVIDOR

--INSTANCIA
FROM '||x.db_name||'.BUG
inner JOIN '||x.db_name||'.LINK ON LN_BUG_ID = BG_BUG_ID  AND LN_ENTITY_TYPE = ''TESTCYCL''
LEFT JOIN '||x.db_name||'.TESTCYCL ON TC_TESTCYCL_ID = LN_ENTITY_ID
LEFT JOIN '||x.db_name||'.TEST ON TC_TEST_ID = TS_TEST_ID
left JOIN '||x.db_name||'.RELEASES R ON R.REL_ID = BG_TARGET_REL OR BG_DETECTED_IN_REL = R.REL_ID
LEFT JOIN '||x.db_name||'.RELEASE_CYCLES RC ON RC.RCYC_ID = BG_DETECTED_IN_RCYC OR BG_TARGET_RCYC = RC.RCYC_ID 
LEFT JOIN (
SELECT b.BG_BUG_ID as id_BG ,
COUNT (AP_NEW_VALUE) as Cant_rea
FROM  '||x.db_name||'.BUG b
JOIN  '||x.db_name||'.AUDIT_LOG  ON AU_ENTITY_ID = BG_BUG_ID
JOIN '||x.db_name||'.AUDIT_PROPERTIES  ON AP_ACTION_ID = AU_ACTION_ID
WHERE AU_ENTITY_TYPE = ''BUG''
AND AP_PROPERTY_NAME like ''%06- Estado%''
AND AP_NEW_VALUE  = ''Listo para Probar''
group by BG_BUG_ID
) Re  on re.ID_BG=BG_BUG_ID
--------------------------------------------------------------------------------------------------------------------------------
union all 
--TEST
SELECT 
BG_BUG_ID Id_bug, 
BG_RESPONSIBLE Responsable,  
BG_USER_05 Sistema,  
TEST.TS_NAME Nombre_Caso,  
BUG.BG_USER_01  Estado, 
TEST.TS_EXEC_STATUS Estado_Caso ,
R.REL_NAME Release,
RC.RCYC_NAME nombre_ciclo,
'''||x.PROJECT_NAME||''' as Proyecto,
'''||x.DOMAIN_NAME||'''as dominio,
LN_ENTITY_TYPE as entidad,

BG_DETECTION_DATE as Fecha_detect,
BG_SUMMARY AS Comentario,
BG_USER_08 as tipo_error ,
BG_USER_01 AS estado_defec,
R.REL_ID AS REL_ID ,
nvl (re.Cant_rea,0),
''SERVIDOR TSOFT'' as SERVIDOR

FROM '||x.db_name||'.BUG
inner JOIN '||x.db_name||'.LINK ON LN_BUG_ID = BG_BUG_ID  AND LN_ENTITY_TYPE = ''TEST''
LEFT JOIN '||x.db_name||'.TESTCYCL ON TC_TESTCYCL_ID = LN_ENTITY_ID
LEFT JOIN '||x.db_name||'.TEST ON TS_TEST_ID  = LN_ENTITY_ID
left JOIN '||x.db_name||'.RELEASES R ON R.REL_ID = BG_TARGET_REL OR BG_DETECTED_IN_REL = R.REL_ID
LEFT JOIN '||x.db_name||'.RELEASE_CYCLES RC ON RC.RCYC_ID = BG_DETECTED_IN_RCYC OR BG_TARGET_RCYC = RC.RCYC_ID 
LEFT JOIN (
SELECT b.BG_BUG_ID as id_BG ,
COUNT (AP_NEW_VALUE) as Cant_rea
FROM  '||x.db_name||'.BUG b
JOIN  '||x.db_name||'.AUDIT_LOG  ON AU_ENTITY_ID = BG_BUG_ID
JOIN '||x.db_name||'.AUDIT_PROPERTIES  ON AP_ACTION_ID = AU_ACTION_ID
WHERE AU_ENTITY_TYPE = ''BUG''
AND AP_PROPERTY_NAME like ''%06- Estado%''
AND AP_NEW_VALUE  = ''Listo para Probar''
group by BG_BUG_ID
) Re  on re.ID_BG=BG_BUG_ID 

';
end loop;


for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME  from alm_siteadmin_db_12.projects where DB_NAME = 'qa_qa_db0') loop
execute immediate  'insert into ALM_REPORT.DEFEC_LINKIADOS 
SELECT 
BG_BUG_ID Id_bug, 
BG_RESPONSIBLE Responsable,  
BG_USER_05 Sistema,  
TEST.TS_NAME Nombre_Caso,  
BUG.BG_USER_01  Estado, 
TEST.TS_EXEC_STATUS Estado_Caso ,
R.REL_NAME Release,
RC.RCYC_NAME nombre_ciclo,
'''||x.PROJECT_NAME||''' as Proyecto,
'''||x.DOMAIN_NAME||'''as dominio,
LN_ENTITY_TYPE as entidad,

BG_DETECTION_DATE as Fecha_detect,
BG_SUMMARY AS Comentario,
BG_USER_06 as tipo_error ,
BG_STATUS AS estado_defec,
R.REL_ID AS REL_ID ,
nvl (re.Cant_rea,0),
''SERVIDOR TSOFT'' as SERVIDOR

--RUN
FROM '||x.db_name||'.BUG
inner JOIN '||x.db_name||'.LINK ON LN_BUG_ID = BG_BUG_ID AND LN_ENTITY_TYPE = ''RUN''
LEFT JOIN '||x.db_name||'.RUN ON LN_ENTITY_ID = RN_RUN_ID
LEFT JOIN '||x.db_name||'.TEST  ON RN_TEST_ID = TS_TEST_ID
left JOIN '||x.db_name||'.RELEASES R ON R.REL_ID = BG_TARGET_REL OR BG_DETECTED_IN_REL = R.REL_ID
LEFT JOIN '||x.db_name||'.RELEASE_CYCLES RC ON RC.RCYC_ID = BG_DETECTED_IN_RCYC OR BG_TARGET_RCYC = RC.RCYC_ID 
LEFT JOIN (
SELECT b.BG_BUG_ID as id_BG ,
COUNT (AP_NEW_VALUE) as Cant_rea
FROM  '||x.db_name||'.BUG b
JOIN  '||x.db_name||'.AUDIT_LOG  ON AU_ENTITY_ID = BG_BUG_ID
JOIN '||x.db_name||'.AUDIT_PROPERTIES  ON AP_ACTION_ID = AU_ACTION_ID
WHERE AU_ENTITY_TYPE = ''BUG''
AND AP_PROPERTY_NAME like ''%06- Estado%''
AND AP_NEW_VALUE  = ''Listo para Probar''
group by BG_BUG_ID
) Re  on re.ID_BG=BG_BUG_ID

--------------------------------------------------------------------------------------------------------------------------------
union all
SELECT 
BG_BUG_ID Id_bug, 
BG_RESPONSIBLE Responsable,  
BG_USER_05 Sistema,  
TEST.TS_NAME Nombre_Caso,  
BUG.BG_USER_01  Estado, 
TEST.TS_EXEC_STATUS Estado_Caso ,
R.REL_NAME Release,
RC.RCYC_NAME nombre_ciclo,
'''||x.PROJECT_NAME||''' as Proyecto,
'''||x.DOMAIN_NAME||'''as dominio,
LN_ENTITY_TYPE as entidad,

BG_DETECTION_DATE as Fecha_detect,
BG_SUMMARY AS Comentario,
BG_USER_06 as tipo_error ,
BG_STATUS AS estado_defec,
R.REL_ID AS REL_ID ,
nvl (re.Cant_rea,0),
''SERVIDOR TSOFT'' as SERVIDOR

--STEP
FROM '||x.db_name||'.BUG
inner JOIN '||x.db_name||'.LINK ON LN_BUG_ID = BG_BUG_ID AND LN_ENTITY_TYPE = ''STEP''
LEFT JOIN '||x.db_name||'.RELEASES R ON R.REL_ID = BG_TARGET_REL OR BG_DETECTED_IN_REL = R.REL_ID
LEFT JOIN '||x.db_name||'.RELEASE_CYCLES RC ON RC.RCYC_ID = BG_DETECTED_IN_RCYC OR BG_TARGET_RCYC = RC.RCYC_ID 
LEFT JOIN '||x.db_name||'.STEP ON st_id = LN_ENTITY_ID
LEFT JOIN '||x.db_name||'.RUN ON RN_RUN_ID=ST_RUN_ID
LEFT JOIN '||x.db_name||'.TEST ON RN_test_ID=TS_TEST_ID
LEFT JOIN (
SELECT b.BG_BUG_ID as id_BG ,
COUNT (AP_NEW_VALUE) as Cant_rea
FROM  '||x.db_name||'.BUG b
JOIN  '||x.db_name||'.AUDIT_LOG  ON AU_ENTITY_ID = BG_BUG_ID
JOIN '||x.db_name||'.AUDIT_PROPERTIES  ON AP_ACTION_ID = AU_ACTION_ID
WHERE AU_ENTITY_TYPE = ''BUG''
AND AP_PROPERTY_NAME like ''%06- Estado%''
AND AP_NEW_VALUE  = ''Listo para Probar''
group by BG_BUG_ID
) Re  on re.ID_BG=BG_BUG_ID
--------------------------------------------------------------------------------------------------------------------------------
union all 
SELECT 
BG_BUG_ID Id_bug, 
BG_RESPONSIBLE Responsable,  
BG_USER_05 Sistema,  
TEST.TS_NAME Nombre_Caso,  
BUG.BG_USER_01  Estado, 
TEST.TS_EXEC_STATUS Estado_Caso ,
R.REL_NAME Release,
RC.RCYC_NAME  nombre_ciclo,
'''||x.PROJECT_NAME||''' as Proyecto,
'''||x.DOMAIN_NAME||'''as dominio,
LN_ENTITY_TYPE as entidad,

BG_DETECTION_DATE as Fecha_detect,
BG_SUMMARY AS Comentario,
BG_USER_06 as tipo_error ,
BG_STATUS AS estado_defec,
R.REL_ID AS REL_ID ,
nvl (re.Cant_rea,0),
''SERVIDOR TSOFT'' as SERVIDOR

--INSTANCIA
FROM '||x.db_name||'.BUG
inner JOIN '||x.db_name||'.LINK ON LN_BUG_ID = BG_BUG_ID  AND LN_ENTITY_TYPE = ''TESTCYCL''
LEFT JOIN '||x.db_name||'.TESTCYCL ON TC_TESTCYCL_ID = LN_ENTITY_ID
LEFT JOIN '||x.db_name||'.TEST ON TC_TEST_ID = TS_TEST_ID
left JOIN '||x.db_name||'.RELEASES R ON R.REL_ID = BG_TARGET_REL OR BG_DETECTED_IN_REL = R.REL_ID
LEFT JOIN '||x.db_name||'.RELEASE_CYCLES RC ON RC.RCYC_ID = BG_DETECTED_IN_RCYC OR BG_TARGET_RCYC = RC.RCYC_ID 
LEFT JOIN (
SELECT b.BG_BUG_ID as id_BG ,
COUNT (AP_NEW_VALUE) as Cant_rea
FROM  '||x.db_name||'.BUG b
JOIN  '||x.db_name||'.AUDIT_LOG  ON AU_ENTITY_ID = BG_BUG_ID
JOIN '||x.db_name||'.AUDIT_PROPERTIES  ON AP_ACTION_ID = AU_ACTION_ID
WHERE AU_ENTITY_TYPE = ''BUG''
AND AP_PROPERTY_NAME like ''%06- Estado%''
AND AP_NEW_VALUE  = ''Listo para Probar''
group by BG_BUG_ID
) Re  on re.ID_BG=BG_BUG_ID
--------------------------------------------------------------------------------------------------------------------------------
union all 
--TEST
SELECT 
BG_BUG_ID Id_bug, 
BG_RESPONSIBLE Responsable,  
BG_USER_05 Sistema,  
TEST.TS_NAME Nombre_Caso,  
BUG.BG_USER_01  Estado, 
TEST.TS_EXEC_STATUS Estado_Caso ,
R.REL_NAME Release,
RC.RCYC_NAME nombre_ciclo,
'''||x.PROJECT_NAME||''' as Proyecto,
'''||x.DOMAIN_NAME||'''as dominio,
LN_ENTITY_TYPE as entidad,

BG_DETECTION_DATE as Fecha_detect,
BG_SUMMARY AS Comentario,
BG_USER_06 as tipo_error ,
BG_STATUS AS estado_defec,
R.REL_ID AS REL_ID ,
nvl (re.Cant_rea,0),
''SERVIDOR TSOFT'' as SERVIDOR

FROM '||x.db_name||'.BUG
inner JOIN '||x.db_name||'.LINK ON LN_BUG_ID = BG_BUG_ID  AND LN_ENTITY_TYPE = ''TEST''
LEFT JOIN '||x.db_name||'.TESTCYCL ON TC_TESTCYCL_ID = LN_ENTITY_ID
LEFT JOIN '||x.db_name||'.TEST ON TS_TEST_ID  = LN_ENTITY_ID
left JOIN '||x.db_name||'.RELEASES R ON R.REL_ID = BG_TARGET_REL OR BG_DETECTED_IN_REL = R.REL_ID
LEFT JOIN '||x.db_name||'.RELEASE_CYCLES RC ON RC.RCYC_ID = BG_DETECTED_IN_RCYC OR BG_TARGET_RCYC = RC.RCYC_ID 
LEFT JOIN (
SELECT b.BG_BUG_ID as id_BG ,
COUNT (AP_NEW_VALUE) as Cant_rea
FROM  '||x.db_name||'.BUG b
JOIN  '||x.db_name||'.AUDIT_LOG  ON AU_ENTITY_ID = BG_BUG_ID
JOIN '||x.db_name||'.AUDIT_PROPERTIES  ON AP_ACTION_ID = AU_ACTION_ID
WHERE AU_ENTITY_TYPE = ''BUG''
AND AP_PROPERTY_NAME like ''%06- Estado%''
AND AP_NEW_VALUE  = ''Listo para Probar''
group by BG_BUG_ID
) Re  on re.ID_BG=BG_BUG_ID 
';

end loop;



execute immediate  'insert into ALM_REPORT.DEFEC_LINKIADOS 
select * from DEFEC_LINKIADOS@SERVER_BCH
';

end;

/
