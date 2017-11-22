--------------------------------------------------------
--  DDL for Procedure CARGAR_CASOS_POR_ESCENARIO
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ALM_REPORT"."CARGAR_CASOS_POR_ESCENARIO" AS 
BEGIN
execute immediate 'TRUNCATE TABLE ALM_REPORT.CASOS_POR_ESCENARIO';

for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME from alm_siteadmin_db_12.projects where DB_NAME = 'bch_qa_certificación_bch_qa_d') loop
execute immediate  '
insert into ALM_REPORT.CASOS_POR_ESCENARIO 
select * from (
SELECT
'''||x.PROJECT_NAME||''' as Proyecto,
'''||x.DOMAIN_NAME||''' as dominio,
rt.ruta,
RCYC.RCYC_NAME as nombre_ciclo,
TC.TC_STATUS as estado,
REL.REL_NAME as nombre_release,
CY.CY_CYCLE as nombre_lab,
TC.TC_TESTCYCL_ID as instancia,
TS.TS_NAME as TS_NAME ,
TC_TESTER_NAME as Responsable_Pruebas,
TC_EXEC_DATE as Fecha_Ejecucion,
TC_EXEC_TIME as Hora_Ejecucion,
ts.ts_type as ts_type,
ts.TS_TEST_ID as TS_TEST_ID,
count (DISTINCT RN.RN_RUN_ID) as Repeticiones,
REL_USER_TEMPLATE_01 AS JPQA,
''SERVIDOR TSOFT'' as SERVIDOR
 
FROM '||x.db_name||'.TESTCYCL TC
LEFT JOIN '||x.db_name||'.RELEASE_CYCLES RCYC ON RCYC.RCYC_ID = TC.TC_ASSIGN_RCYC
LEFT JOIN '||x.db_name||'.CYCLE CY  ON CY.CY_CYCLE_ID = TC.TC_CYCLE_ID
LEFT JOIN '||x.db_name||'.RELEASES REL ON REL.REL_ID=RCYC.RCYC_PARENT_ID
LEFT JOIN '||x.db_name||'.TEST TS ON TS.TS_TEST_ID=TC.TC_TEST_ID
left JOIN '||x.db_name||'.RUN RN ON TC.TC_TESTCYCL_ID = RN.RN_TESTCYCL_ID
LEFT JOIN '||x.db_name||'.RELEASE_FOLDERS RF ON  RF.RF_ID = REL.REL_PARENT_ID 
INNER JOIN '||x.db_name||'.REQ_RELEASES RQR ON RQR.RQRL_RELEASE_ID=REL.REL_ID
INNER JOIN '||x.db_name||'.REQ RQ ON RQ.RQ_REQ_ID=RQR.RQRL_REQ_ID

left join (
select CY_FOLDER_ID,CF7.CF_ITEM_NAME || ''/'' || CF6.CF_ITEM_NAME || ''/'' || CF5.CF_ITEM_NAME || ''/'' || CF4.CF_ITEM_NAME || ''/'' || CF3.CF_ITEM_NAME || ''/'' || CF2.CF_ITEM_NAME || ''/'' ||  CF1.CF_ITEM_NAME || ''/'' || CF.CF_ITEM_NAME as ruta
from '||x.db_name||'.CYCLE CY
LEFT JOIN '||x.db_name||'.CYCL_FOLD CF  ON CF.CF_ITEM_ID = CY_FOLDER_ID
LEFT JOIN '||x.db_name||'.CYCL_FOLD CF1 ON CF1.CF_ITEM_ID = CF.CF_FATHER_ID
LEFT JOIN '||x.db_name||'.CYCL_FOLD CF2 ON CF2.CF_ITEM_ID = CF1.CF_FATHER_ID
LEFT JOIN '||x.db_name||'.CYCL_FOLD CF3 ON CF3.CF_ITEM_ID = CF2.CF_FATHER_ID
LEFT JOIN '||x.db_name||'.CYCL_FOLD CF4 ON CF4.CF_ITEM_ID = CF3.CF_FATHER_ID
LEFT JOIN '||x.db_name||'.CYCL_FOLD CF5 ON CF5.CF_ITEM_ID = CF4.CF_FATHER_ID
LEFT JOIN '||x.db_name||'.CYCL_FOLD CF6 ON CF6.CF_ITEM_ID = CF5.CF_FATHER_ID
LEFT JOIN '||x.db_name||'.CYCL_FOLD CF6 ON CF6.CF_ITEM_ID = CF5.CF_FATHER_ID
LEFT JOIN '||x.db_name||'.CYCL_FOLD CF7 ON CF7.CF_ITEM_ID = CF6.CF_FATHER_ID
LEFT JOIN '||x.db_name||'.RELEASE_CYCLES RCYC ON RCYC.RCYC_ID = CY.CY_ASSIGN_RCYC
LEFT JOIN '||x.db_name||'.RELEASES REL ON REL.REL_ID=RCYC.RCYC_PARENT_ID
LEFT JOIN '||x.db_name||'.RELEASE_FOLDERS RF ON  RF.RF_ID = REL.REL_PARENT_ID 
INNER JOIN '||x.db_name||'.REQ_RELEASES RQR ON RQR.RQRL_RELEASE_ID=REL.REL_ID
INNER JOIN '||x.db_name||'.REQ RQ ON RQ.RQ_REQ_ID=RQR.RQRL_REQ_ID
WHERE 1=1
AND(RF.RF_PATH not like ''AAAAAB%''  AND RF.RF_PATH not like ''AAAAAF%'' AND RF.RF_PATH not like ''AAAAAC%'' AND RF.RF_PATH not like ''AAAAAD%'' AND RF.RF_PATH not like ''AAAAAE%'' AND RQ.RQ_REQ_PATH not like ''AAAAAA%'')
AND RQ_USER_04 in (''Creado'', ''Estática QA'', ''Pendiente Dinámica'', ''Pruebas QA'', ''Suspendido'', ''Ingresado'', ''Fase Estática'', ''Ambientación'', ''Fase Dinámica'', ''Pruebas UAT'', ''Cerrado QA'')
AND RQ_TYPE_ID IN (119,117,107,116)
--AND REL.REL_ID = ''1548''
)  rt on rt.CY_FOLDER_ID=CY.CY_FOLDER_ID

WHERE 1=1

AND(RF.RF_PATH not like ''AAAAAB%''  AND RF.RF_PATH not like ''AAAAAF%'' AND RF.RF_PATH not like ''AAAAAC%'' AND RF.RF_PATH not like ''AAAAAD%'' AND RF.RF_PATH not like ''AAAAAE%'' AND RQ.RQ_REQ_PATH not like ''AAAAAA%'')
AND RQ_USER_04 in (''Creado'', ''Estática QA'', ''Pendiente Dinámica'', ''Pruebas QA'', ''Suspendido'', ''Ingresado'', ''Fase Estática'', ''Ambientación'', ''Fase Dinámica'', ''Pruebas UAT'', ''Cerrado QA'')
AND RQ_TYPE_ID IN (119,117,107,116)
--AND REL.REL_ID = ''1548''


group by 
rt.ruta,
RCYC.RCYC_NAME  ,
TC.TC_STATUS  ,
REL.REL_NAME  ,
CY.CY_CYCLE  ,
TC.TC_TESTCYCL_ID  ,
TS.TS_NAME,
TC_TESTER_NAME  ,
TC_EXEC_DATE  ,
TC_EXEC_TIME ,
ts.ts_type, 
TS_TEST_ID,
REL_USER_TEMPLATE_01
) 
';
end loop;



/*for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME from alm_siteadmin_db_12.projects 
          where domain_name in ('PROYECTOS') and PR_IS_ACTIVE = 'Y' ) loop
execute immediate  'insert into ALM_REPORT.CASOS_POR_ESCENARIO 
select * from (
SELECT
'''||x.PROJECT_NAME||''' as Proyecto,
'''||x.DOMAIN_NAME||''' as dominio,
rt.ruta,
RCYC.RCYC_NAME as nombre_ciclo,
TC.TC_STATUS as estado,
REL.REL_NAME as nombre_release,
CY.CY_CYCLE as nombre_lab,
TC.TC_TESTCYCL_ID as instancia,
TS.TS_NAME as TS_NAME ,
TC_TESTER_NAME as Responsable_Pruebas,
TC_EXEC_DATE as Fecha_Ejecucion,
TC_EXEC_TIME as Hora_Ejecucion,
ts.ts_type as ts_type,
ts.TS_TEST_ID as TS_TEST_ID,
count (DISTINCT RN.RN_RUN_ID) as Repeticiones
 
FROM '||x.db_name||'.TESTCYCL TC
LEFT JOIN '||x.db_name||'.RELEASE_CYCLES RCYC ON RCYC.RCYC_ID = TC.TC_ASSIGN_RCYC
LEFT JOIN '||x.db_name||'.CYCLE CY  ON CY.CY_CYCLE_ID = TC.TC_CYCLE_ID
LEFT JOIN '||x.db_name||'.RELEASES REL ON REL.REL_ID=RCYC.RCYC_PARENT_ID
LEFT JOIN '||x.db_name||'.TEST TS ON TS.TS_TEST_ID=TC.TC_TEST_ID
left JOIN '||x.db_name||'.RUN RN ON TC.TC_TESTCYCL_ID = RN.RN_TESTCYCL_ID
LEFT JOIN '||x.db_name||'.RELEASE_FOLDERS RF ON  RF.RF_ID = REL.REL_PARENT_ID 
INNER JOIN '||x.db_name||'.REQ_RELEASES RQR ON RQR.RQRL_RELEASE_ID=REL.REL_ID
INNER JOIN '||x.db_name||'.REQ RQ ON RQ.RQ_REQ_ID=RQR.RQRL_REQ_ID

left join (
select CY_FOLDER_ID,CF7.CF_ITEM_NAME || ''/'' || CF6.CF_ITEM_NAME || ''/'' || CF5.CF_ITEM_NAME || ''/'' || CF4.CF_ITEM_NAME || ''/'' || CF3.CF_ITEM_NAME || ''/'' || CF2.CF_ITEM_NAME || ''/'' ||  CF1.CF_ITEM_NAME || ''/'' || CF.CF_ITEM_NAME as ruta
from '||x.db_name||'.CYCLE CY
LEFT JOIN '||x.db_name||'.CYCL_FOLD CF  ON CF.CF_ITEM_ID = CY_FOLDER_ID
LEFT JOIN '||x.db_name||'.CYCL_FOLD CF1 ON CF1.CF_ITEM_ID = CF.CF_FATHER_ID
LEFT JOIN '||x.db_name||'.CYCL_FOLD CF2 ON CF2.CF_ITEM_ID = CF1.CF_FATHER_ID
LEFT JOIN '||x.db_name||'.CYCL_FOLD CF3 ON CF3.CF_ITEM_ID = CF2.CF_FATHER_ID
LEFT JOIN '||x.db_name||'.CYCL_FOLD CF4 ON CF4.CF_ITEM_ID = CF3.CF_FATHER_ID
LEFT JOIN '||x.db_name||'.CYCL_FOLD CF5 ON CF5.CF_ITEM_ID = CF4.CF_FATHER_ID
LEFT JOIN '||x.db_name||'.CYCL_FOLD CF6 ON CF6.CF_ITEM_ID = CF5.CF_FATHER_ID
LEFT JOIN '||x.db_name||'.CYCL_FOLD CF6 ON CF6.CF_ITEM_ID = CF5.CF_FATHER_ID
LEFT JOIN '||x.db_name||'.CYCL_FOLD CF7 ON CF7.CF_ITEM_ID = CF6.CF_FATHER_ID
)  rt on rt.CY_FOLDER_ID=CY.CY_FOLDER_ID


group by 
rt.ruta,
RCYC.RCYC_NAME  ,
TC.TC_STATUS  ,
REL.REL_NAME  ,
CY.CY_CYCLE  ,
TC.TC_TESTCYCL_ID  ,
TS.TS_NAME,
TC_TESTER_NAME  ,
TC_EXEC_DATE  ,
TC_EXEC_TIME ,
ts.ts_type, 
TS_TEST_ID)
';
 
 
end loop;

for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME from alm_siteadmin_db_12.projects WHERE DB_NAME = 'proveedores_testing_sqa_db') loop
execute immediate  'insert into ALM_REPORT.CASOS_POR_ESCENARIO 
select * from (
SELECT
'''||x.PROJECT_NAME||''' as Proyecto,
'''||x.DOMAIN_NAME||''' as dominio,
rt.ruta,
RCYC.RCYC_NAME as nombre_ciclo,
TC.TC_STATUS as estado,
REL.REL_NAME as nombre_release,
CY.CY_CYCLE as nombre_lab,
TC.TC_TESTCYCL_ID as instancia,
TS.TS_NAME as TS_NAME ,
TC_TESTER_NAME as Responsable_Pruebas,
TC_EXEC_DATE as Fecha_Ejecucion,
TC_EXEC_TIME as Hora_Ejecucion,
ts.ts_type as ts_type,
ts.TS_TEST_ID as TS_TEST_ID,
count (DISTINCT RN.RN_RUN_ID) as Repeticiones
 
FROM '||x.db_name||'.TESTCYCL TC
LEFT JOIN '||x.db_name||'.RELEASE_CYCLES RCYC ON RCYC.RCYC_ID = TC.TC_ASSIGN_RCYC
LEFT JOIN '||x.db_name||'.CYCLE CY  ON CY.CY_CYCLE_ID = TC.TC_CYCLE_ID
LEFT JOIN '||x.db_name||'.RELEASES REL ON REL.REL_ID=RCYC.RCYC_PARENT_ID
LEFT JOIN '||x.db_name||'.TEST TS ON TS.TS_TEST_ID=TC.TC_TEST_ID
left JOIN '||x.db_name||'.RUN RN ON TC.TC_TESTCYCL_ID = RN.RN_TESTCYCL_ID

left join (
select CY_FOLDER_ID,CF7.CF_ITEM_NAME || ''/'' || CF6.CF_ITEM_NAME || ''/'' || CF5.CF_ITEM_NAME || ''/'' || CF4.CF_ITEM_NAME || ''/'' || CF3.CF_ITEM_NAME || ''/'' || CF2.CF_ITEM_NAME || ''/'' ||  CF1.CF_ITEM_NAME || ''/'' || CF.CF_ITEM_NAME as ruta
from '||x.db_name||'.CYCLE CY
LEFT JOIN '||x.db_name||'.CYCL_FOLD CF  ON CF.CF_ITEM_ID = CY_FOLDER_ID
LEFT JOIN '||x.db_name||'.CYCL_FOLD CF1 ON CF1.CF_ITEM_ID = CF.CF_FATHER_ID
LEFT JOIN '||x.db_name||'.CYCL_FOLD CF2 ON CF2.CF_ITEM_ID = CF1.CF_FATHER_ID
LEFT JOIN '||x.db_name||'.CYCL_FOLD CF3 ON CF3.CF_ITEM_ID = CF2.CF_FATHER_ID
LEFT JOIN '||x.db_name||'.CYCL_FOLD CF4 ON CF4.CF_ITEM_ID = CF3.CF_FATHER_ID
LEFT JOIN '||x.db_name||'.CYCL_FOLD CF5 ON CF5.CF_ITEM_ID = CF4.CF_FATHER_ID
LEFT JOIN '||x.db_name||'.CYCL_FOLD CF6 ON CF6.CF_ITEM_ID = CF5.CF_FATHER_ID
LEFT JOIN '||x.db_name||'.CYCL_FOLD CF6 ON CF6.CF_ITEM_ID = CF5.CF_FATHER_ID
LEFT JOIN '||x.db_name||'.CYCL_FOLD CF7 ON CF7.CF_ITEM_ID = CF6.CF_FATHER_ID
)  rt on rt.CY_FOLDER_ID=CY.CY_FOLDER_ID


group by 
rt.ruta,
RCYC.RCYC_NAME  ,
TC.TC_STATUS  ,
REL.REL_NAME  ,
CY.CY_CYCLE  ,
TC.TC_TESTCYCL_ID  ,
TS.TS_NAME,
TC_TESTER_NAME  ,
TC_EXEC_DATE  ,
TC_EXEC_TIME ,
ts.ts_type, 
TS_TEST_ID)
';
 
end loop;*/



for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME  from alm_siteadmin_db_12.projects where DB_NAME = 'qa_qa_db0') loop
execute immediate  'insert into ALM_REPORT.CASOS_POR_ESCENARIO 
select * from (
SELECT
'''||x.PROJECT_NAME||''' as Proyecto,
'''||x.DOMAIN_NAME||''' as dominio,
rt.ruta,
RCYC.RCYC_NAME as nombre_ciclo,
TC.TC_STATUS as estado,
REL.REL_NAME as nombre_release,
CY.CY_CYCLE as nombre_lab,
TC.TC_TESTCYCL_ID as instancia,
TS.TS_NAME as TS_NAME ,
TC_TESTER_NAME as Responsable_Pruebas,
TC_EXEC_DATE as Fecha_Ejecucion,
TC_EXEC_TIME as Hora_Ejecucion,
ts.ts_type as ts_type,
ts.TS_TEST_ID as TS_TEST_ID,
count (DISTINCT RN.RN_RUN_ID) as Repeticiones,
REL_USER_05 AS JPQA,
''SERVIDOR TSOFT'' as SERVIDOR
 
FROM '||x.db_name||'.TESTCYCL TC
LEFT JOIN '||x.db_name||'.RELEASE_CYCLES RCYC ON RCYC.RCYC_ID = TC.TC_ASSIGN_RCYC
LEFT JOIN '||x.db_name||'.CYCLE CY  ON CY.CY_CYCLE_ID = TC.TC_CYCLE_ID
LEFT JOIN '||x.db_name||'.RELEASES REL ON REL.REL_ID=RCYC.RCYC_PARENT_ID
LEFT JOIN '||x.db_name||'.TEST TS ON TS.TS_TEST_ID=TC.TC_TEST_ID
left JOIN '||x.db_name||'.RUN RN ON TC.TC_TESTCYCL_ID = RN.RN_TESTCYCL_ID
LEFT JOIN '||x.db_name||'.RELEASE_FOLDERS RF ON  RF.RF_ID = REL.REL_PARENT_ID 
INNER JOIN '||x.db_name||'.REQ_RELEASES RQR ON RQR.RQRL_RELEASE_ID=REL.REL_ID
INNER JOIN '||x.db_name||'.REQ RQ ON RQ.RQ_REQ_ID=RQR.RQRL_REQ_ID

left join (
select CY_FOLDER_ID,CF7.CF_ITEM_NAME || ''/'' || CF6.CF_ITEM_NAME || ''/'' || CF5.CF_ITEM_NAME || ''/'' || CF4.CF_ITEM_NAME || ''/'' || CF3.CF_ITEM_NAME || ''/'' || CF2.CF_ITEM_NAME || ''/'' ||  CF1.CF_ITEM_NAME || ''/'' || CF.CF_ITEM_NAME as ruta
from '||x.db_name||'.CYCLE CY
LEFT JOIN '||x.db_name||'.CYCL_FOLD CF  ON CF.CF_ITEM_ID = CY_FOLDER_ID
LEFT JOIN '||x.db_name||'.CYCL_FOLD CF1 ON CF1.CF_ITEM_ID = CF.CF_FATHER_ID
LEFT JOIN '||x.db_name||'.CYCL_FOLD CF2 ON CF2.CF_ITEM_ID = CF1.CF_FATHER_ID
LEFT JOIN '||x.db_name||'.CYCL_FOLD CF3 ON CF3.CF_ITEM_ID = CF2.CF_FATHER_ID
LEFT JOIN '||x.db_name||'.CYCL_FOLD CF4 ON CF4.CF_ITEM_ID = CF3.CF_FATHER_ID
LEFT JOIN '||x.db_name||'.CYCL_FOLD CF5 ON CF5.CF_ITEM_ID = CF4.CF_FATHER_ID
LEFT JOIN '||x.db_name||'.CYCL_FOLD CF6 ON CF6.CF_ITEM_ID = CF5.CF_FATHER_ID
LEFT JOIN '||x.db_name||'.CYCL_FOLD CF6 ON CF6.CF_ITEM_ID = CF5.CF_FATHER_ID
LEFT JOIN '||x.db_name||'.CYCL_FOLD CF7 ON CF7.CF_ITEM_ID = CF6.CF_FATHER_ID
LEFT JOIN '||x.db_name||'.RELEASE_CYCLES RCYC ON RCYC.RCYC_ID = CY.CY_ASSIGN_RCYC
LEFT JOIN '||x.db_name||'.RELEASES REL ON REL.REL_ID=RCYC.RCYC_PARENT_ID
LEFT JOIN '||x.db_name||'.RELEASE_FOLDERS RF ON  RF.RF_ID = REL.REL_PARENT_ID 
INNER JOIN '||x.db_name||'.REQ_RELEASES RQR ON RQR.RQRL_RELEASE_ID=REL.REL_ID
INNER JOIN '||x.db_name||'.REQ RQ ON RQ.RQ_REQ_ID=RQR.RQRL_REQ_ID
WHERE 1=1

AND(RF.RF_PATH not like ''AAAAAB%'' AND RF.RF_PATH not like ''AAAAAC%'' AND RF.RF_PATH not like ''AAAAAAAAO%'' AND RQ.RQ_REQ_PATH not like ''AAAAAB%'')
AND RQ.RQ_TYPE_ID NOT IN (105, 106)
AND RQ.RQ_USER_02 not in (''Cerrado QA'', ''Cancelado'' ,''Cerrado'', ''Cerrado sin IDC'', ''Cerrado con Observaciones'', ''Con Cobertura'', ''Con Defecto'', ''En Análisis'', ''En Diseño'', ''No Revisado'', ''Rechazado'')
--AND REL.REL_ID = ''1548''
)  rt on rt.CY_FOLDER_ID=CY.CY_FOLDER_ID

WHERE 1=1

AND(RF.RF_PATH not like ''AAAAAB%'' AND RF.RF_PATH not like ''AAAAAC%'' AND RF.RF_PATH not like ''AAAAAAAAO%'' AND RQ.RQ_REQ_PATH not like ''AAAAAB%'')
AND RQ.RQ_TYPE_ID NOT IN (105, 106)
AND RQ.RQ_USER_02 not in (''Cerrado QA'', ''Cancelado'' ,''Cerrado'', ''Cerrado sin IDC'', ''Cerrado con Observaciones'', ''Con Cobertura'', ''Con Defecto'', ''En Análisis'', ''En Diseño'', ''No Revisado'', ''Rechazado'')
--AND REL.REL_ID = ''1548''

group by 
rt.ruta,
RCYC.RCYC_NAME  ,
TC.TC_STATUS  ,
REL.REL_NAME  ,
CY.CY_CYCLE  ,
TC.TC_TESTCYCL_ID  ,
TS.TS_NAME,
TC_TESTER_NAME  ,
TC_EXEC_DATE  ,
TC_EXEC_TIME ,
ts.ts_type, 
TS_TEST_ID,
REL_USER_05

)
';

end loop;

execute immediate  'insert into ALM_REPORT.CASOS_POR_ESCENARIO 
select * from CASOS_POR_ESCENARIO@SERVER_BCH
';

end;

/
