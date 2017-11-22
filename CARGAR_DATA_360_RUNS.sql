--------------------------------------------------------
--  DDL for Procedure CARGAR_DATA_360_RUNS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ALM_REPORT"."CARGAR_DATA_360_RUNS" AS 
BEGIN
execute immediate 'TRUNCATE TABLE ALM_REPORT.DATA_360_RUNS';

for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME from alm_siteadmin_db_12.projects where DB_NAME = 'bch_qa_certificación_bch_qa_d') loop
execute immediate  'insert into ALM_REPORT.DATA_360_RUNS 

SELECT 
'''||x.PROJECT_NAME||''' as Proyecto,
'''||x.DOMAIN_NAME||''' as dominio,
REL.REL_ID AS ID_RELEASE, 
REL.REL_NAME AS NOMBRE_RELEASE, 
REL.REL_USER_TEMPLATE_01 AS JPQA, 
REL.REL_USER_TEMPLATE_02 AS JEFE_AREA_DESARROLLO, 
''-'' AS ESTADO_REQUERIMIENTO,
--RQ.RQ_USER_04 AS ESTADO_REQUERIMIENTO,
RC.RCYC_ID AS ID_CICLO,
RC.RCYC_NAME AS NOMBRE_CICLO, 
TS.TS_TYPE AS TIPO_CASO, 
RN_EXECUTION_DATE AS FECHA_RUN, 
COUNT (DISTINCT RN.RN_RUN_ID) AS TOT_RUN,
RN_STATUS AS ESTADO_RUN,
RN_TESTER_NAME AS TESTER_RUN,
''SERVIDOR TSOFT'' as SERVIDOR

FROM '||x.db_name||'.RUN RN
LEFT JOIN '||x.db_name||'.TESTCYCL TC ON TC.TC_TESTCYCL_ID = RN.RN_TESTCYCL_ID 
LEFT JOIN '||x.db_name||'.TEST TS ON TC.TC_TEST_ID = TS.TS_TEST_ID
--LEFT JOIN '||x.db_name||'.RELEASE_CYCLES RC ON RC.RCYC_ID = TC.TC_ASSIGN_RCYC 
LEFT JOIN '||x.db_name||'.RELEASE_CYCLES RC ON RC.RCYC_ID = RN.RN_ASSIGN_RCYC
LEFT JOIN '||x.db_name||'.RELEASES REL ON REL.REL_ID = RC.RCYC_PARENT_ID
--INNER JOIN '||x.db_name||'.REQ_RELEASES RQR ON RQR.RQRL_RELEASE_ID=REL.REL_ID
--INNER JOIN '||x.db_name||'.REQ RQ ON RQ.RQ_REQ_ID=RQR.RQRL_REQ_ID
LEFT JOIN '||x.db_name||'.RELEASE_FOLDERS RF ON  RF.RF_ID = REL.REL_PARENT_ID
       
WHERE 1=1
--AND(RF.RF_PATH not like ''AAAAAB%''  AND RF.RF_PATH not like ''AAAAAF%'' AND RF.RF_PATH not like ''AAAAAC%'' AND RF.RF_PATH not like ''AAAAAD%'' AND RF.RF_PATH not like ''AAAAAE%'')     
--AND RC.RCYC_NAME not LIKE (''%IDC%'')
--AND(RF.RF_PATH not like ''AAAAAB%''  AND RF.RF_PATH not like ''AAAAAF%'' AND RF.RF_PATH not like ''AAAAAC%'' AND RF.RF_PATH not like ''AAAAAD%'' AND RF.RF_PATH not like ''AAAAAE%'' AND RQ.RQ_REQ_PATH not like ''AAAAAA%'')
--AND RQ_USER_04 in (''Creado'', ''Estática QA'', ''Pendiente Dinámica'', ''Pruebas QA'', ''Suspendido'',''Ingresado'',''Fase Estática'',''Ambientación'',''Fase Dinámica'',''Pruebas UAT'', ''Cerrado QA'')
--AND RQ_TYPE_ID IN (119,117,107,116)
--AND RN_RUN_NAME NOT LIKE (''%Fast%'')

AND REL.REL_NAME NOT LIKE ''%IDC%''
AND RN_RUN_NAME NOT LIKE (''%Fast%'')
AND RN_STATUS IN (''Passed'',''Failed'')
--AND rf.rf_path NOT LIKE ''AAAAAC%''
AND RN.RN_ASSIGN_RCYC IS NOT NULL
--AND(RF.RF_PATH not like ''AAAAAB%'' AND RF.RF_PATH not like ''AAAAAF%'')
AND(RF.RF_PATH not like ''AAAAAD%'' AND RF.RF_PATH not like ''AAAAADAAC%'' AND RF.RF_PATH not like ''AAAAAG%'' AND rf.rf_path NOT LIKE ''AAAAAI%'')

GROUP BY REL.REL_ID, 
REL.REL_NAME, 
REL.REL_USER_TEMPLATE_01, 
REL.REL_USER_TEMPLATE_02, 
''-'',
--RQ.RQ_USER_04,
RC.RCYC_ID,
RC.RCYC_NAME, 
TS.TS_TYPE, 
RN_EXECUTION_DATE,
RN_STATUS,
RN_TESTER_NAME

';
end loop;


for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME  from alm_siteadmin_db_12.projects where DB_NAME = 'qa_qa_db0') loop
execute immediate  'insert into ALM_REPORT.DATA_360_RUNS

SELECT 
'''||x.PROJECT_NAME||''' as Proyecto,
'''||x.DOMAIN_NAME||''' as dominio,
REL.REL_ID AS ID_RELEASE, 
REL.REL_NAME AS NOMBRE_RELEASE, 
REL.REL_USER_05 AS JPQA, 
REL.REL_USER_02 AS JEFE_AREA_DESARROLLO,
''-'' AS ESTADO_REQUERIMIENTO,
--RQ.RQ_USER_02 AS ESTADO_REQUERIMIENTO,
RC.RCYC_ID AS ID_CICLO,
RC.RCYC_NAME AS NOMBRE_CICLO, 
TS.TS_TYPE AS TIPO_CASO, 
RN_EXECUTION_DATE AS FECHA_RUN, 
COUNT (DISTINCT RN.RN_RUN_ID) AS TOT_RUN,

RN.RN_STATUS AS ESTADO_RUN,
RN.RN_TESTER_NAME AS TESTER_RUN,
''SERVIDOR TSOFT'' as SERVIDOR

FROM '||x.db_name||'.RUN RN
LEFT JOIN '||x.db_name||'.TESTCYCL TC ON TC.TC_TESTCYCL_ID = RN.RN_TESTCYCL_ID 
LEFT JOIN '||x.db_name||'.TEST TS ON TC.TC_TEST_ID = TS.TS_TEST_ID
--LEFT JOIN '||x.db_name||'.RELEASE_CYCLES RC ON RC.RCYC_ID = TC.TC_ASSIGN_RCYC 
LEFT JOIN '||x.db_name||'.RELEASE_CYCLES RC ON RC.RCYC_ID = RN.RN_ASSIGN_RCYC
LEFT JOIN '||x.db_name||'.RELEASES REL ON REL.REL_ID = RC.RCYC_PARENT_ID
--INNER JOIN '||x.db_name||'.REQ_RELEASES RQR ON RQR.RQRL_RELEASE_ID=REL.REL_ID
--INNER JOIN '||x.db_name||'.REQ RQ ON RQ.RQ_REQ_ID=RQR.RQRL_REQ_ID
LEFT JOIN '||x.db_name||'.RELEASE_FOLDERS RF ON  RF.RF_ID = REL.REL_PARENT_ID

       
WHERE 1=1
--AND RC.RCYC_NAME not LIKE (''%IDC%'')
--AND(RF.RF_PATH not like ''AAAAAB%'' AND RF.RF_PATH not like ''AAAAAC%'' AND RF.RF_PATH not like ''AAAAAAAAO%'' AND RQ.RQ_REQ_PATH not like ''AAAAAB%'')
--AND RQ.RQ_TYPE_ID NOT IN (105, 106)
--AND RQ.RQ_USER_02 not in (''Cerrado QA'', ''Cancelado'' ,''Cerrado'', ''Cerrado sin IDC'', ''Cerrado con Observaciones'', ''Con Cobertura'', ''Con Defecto'', ''En Análisis'', ''En Diseño'', ''No Revisado'', ''Rechazado'')
--AND RN_RUN_NAME NOT LIKE (''%Fast%'')

AND REL.REL_NAME NOT LIKE ''%IDC%''
AND RN_RUN_NAME NOT LIKE (''%Fast%'')
AND RN_STATUS IN (''Passed'',''Failed'')
AND RN.RN_ASSIGN_RCYC IS NOT NULL
AND(RF.RF_PATH not like ''AAAAAC%'')

GROUP BY REL.REL_ID, 
REL.REL_NAME, 
REL.REL_USER_05, 
REL.REL_USER_02, 
''-'',
--RQ.RQ_USER_02,
RC.RCYC_ID,
RC.RCYC_NAME, 
TS.TS_TYPE, 
RN_EXECUTION_DATE,
RN.RN_STATUS,
RN.RN_TESTER_NAME

'; end loop;


/*for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME from alm_siteadmin_db_12.projects 
          where domain_name in ('PROYECTOS') and PR_IS_ACTIVE = 'Y' ) loop
execute immediate  'insert into ALM_REPORT.DATA_360_RUNS 

SELECT 
'''||x.PROJECT_NAME||''' as Proyecto,
'''||x.DOMAIN_NAME||''' as dominio,
REL.REL_ID AS ID_RELEASE, 
REL.REL_NAME AS NOMBRE_RELEASE, 
REL.REL_USER_04 AS JPQA, 
REL.REL_USER_TEMPLATE_01 AS JEFE_AREA_DESARROLLO, 
''-'' AS ESTADO_REQUERIMIENTO,
--RQ.RQ_USER_02 AS ESTADO_REQUERIMIENTO,
RC.RCYC_ID AS ID_CICLO,
RC.RCYC_NAME AS NOMBRE_CICLO, 
TS.TS_TYPE AS TIPO_CASO, 
RN_EXECUTION_DATE AS FECHA_RUN, 
COUNT (DISTINCT RN.RN_RUN_ID) AS TOT_RUN,

RN.RN_STATUS AS ESTADO_RUN,
RN.RN_TESTER_NAME AS TESTER_RUN,
''SERVIDOR BCH'' as SERVIDOR

FROM '||x.db_name||'.RUN RN
LEFT JOIN '||x.db_name||'.TESTCYCL TC ON TC.TC_TESTCYCL_ID = RN.RN_TESTCYCL_ID 
LEFT JOIN '||x.db_name||'.TEST TS ON TC.TC_TEST_ID = TS.TS_TEST_ID
--LEFT JOIN '||x.db_name||'.RELEASE_CYCLES RC ON RC.RCYC_ID = TC.TC_ASSIGN_RCYC 
LEFT JOIN '||x.db_name||'.RELEASE_CYCLES RC ON RC.RCYC_ID = RN.RN_ASSIGN_RCYC
LEFT JOIN '||x.db_name||'.RELEASES REL ON REL.REL_ID = RC.RCYC_PARENT_ID
--INNER JOIN '||x.db_name||'.REQ_RELEASES RQR ON RQR.RQRL_RELEASE_ID=REL.REL_ID
--INNER JOIN '||x.db_name||'.REQ RQ ON RQ.RQ_REQ_ID=RQR.RQRL_REQ_ID
LEFT JOIN '||x.db_name||'.RELEASE_FOLDERS RF ON  RF.RF_ID = REL.REL_PARENT_ID
       
       
WHERE 1=1
--AND RC.RCYC_NAME not LIKE (''%IDC%'')
--AND(RF.RF_PATH not like ''AAAAAB%''  AND RF.RF_PATH not like ''AAAAAF%'' AND RF.RF_PATH not like ''AAAAAC%'' AND RF.RF_PATH not like ''AAAAAD%'')
--AND RQ_USER_02 in (''Creado'', ''Estática QA'', ''Pendiente Dinámica'', ''Pruebas QA'', ''Suspendido'')
--AND RQ_TYPE_ID IN (101,108)
--AND RN_RUN_NAME NOT LIKE (''%Fast%'')

AND REL.REL_NAME NOT LIKE ''%IDC%''
AND RN_RUN_NAME NOT LIKE (''%Fast%'')
AND RN_STATUS IN (''Passed'',''Failed'')
--AND rf.rf_path NOT LIKE ''AAAAAC%''
AND RN.RN_ASSIGN_RCYC IS NOT NULL

GROUP BY REL.REL_ID, 
REL.REL_NAME, 
REL.REL_USER_04, 
REL.REL_USER_TEMPLATE_01, 
--RQ.RQ_USER_02,
''-'',
RC.RCYC_ID,
RC.RCYC_NAME, 
TS.TS_TYPE, 
RN_EXECUTION_DATE,
RN.RN_STATUS,
RN.RN_TESTER_NAME

'; end loop;*/

execute immediate  'insert into ALM_REPORT.DATA_360_RUNS 
select "PROYECTO",	"DOMINIO",	"ID_RELEASE",	"NOMBRE_RELEASE",	"JPQA",	"JEFE_AREA_DESARROLLO",	"ESTADO_REQUERIMIENTO",	"ID_CICLO",	"NOMBRE_CICLO",	"TIPO_CASO",	"FECHA_EJECUCION_RUN",	"TOT_RUN",	"ESTADO_RUN",	"TESTER_RUN",	"SERVIDOR" from DATA_360_RUNS@SERVER_BCH
';

end;

/
