--------------------------------------------------------
--  DDL for Procedure CARGAR_DATA_EJE_INNOVACION
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ALM_REPORT"."CARGAR_DATA_EJE_INNOVACION" AS 
BEGIN
execute immediate 'TRUNCATE TABLE ALM_REPORT.DATA_EJE_INNOVACION';

for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME from alm_siteadmin_db_12.projects where DB_NAME = 'qa_qa_db0') loop
execute immediate  'insert into ALM_REPORT.DATA_EJE_INNOVACION 

SELECT DISTINCT
REL.REL_ID        AS ID_RELEASES,
REL.REL_USER_05   AS JPQA,
REL.REL_NAME      AS NOMBRE_RELEASES,
CASE WHEN TS.TS_TYPE IN (''QUICKTEST_TEST'', ''SERVICE-TEST'') THEN ''AUTOMATICO'' ELSE  ''MANUAL'' END  AS TIPO_CASO,
TC.TC_STATUS      AS ESTADO_EJECUCIÓN,
TC.TC_TESTER_NAME AS NOMBRE_TESTER,
TC.TC_TESTCYCL_ID AS ID_INSTANCIAS,
RN.RN_RUN_ID      AS ID_RUN,
RN.RN_EXECUTION_DATE   AS FECHA_RUN,
RN.RN_RUN_NAME AS NOMBRE_RUN,
/*CASE WHEN CANT_ESTADO > 1 
THEN nvl (COUNT (DISTINCT TC.TC_TESTCYCL_ID),0)/CANT_ESTADO 
ELSE nvl (COUNT (DISTINCT TC.TC_TESTCYCL_ID),0) END "cant_Instancia",*/
--RQ.RQ_USER_02 "Estado Requerimiento",
TC.TC_EXEC_DATE   AS FECHA_EJECUCIÓN,
REL.REL_USER_02   AS JEFE_AREA_DESARROLLO,
''SERVIDOR TSOFT''    AS SERVIDOR
FROM  '||x.db_name||'.TESTCYCL TC
LEFT JOIN '||x.db_name||'.RUN RN ON RN.RN_TESTCYCL_ID  = TC.TC_TESTCYCL_ID
LEFT JOIN '||x.db_name||'.TEST TS ON TC.TC_TEST_ID = TS.TS_TEST_ID
LEFT JOIN '||x.db_name||'.CYCLE CY ON CY.CY_CYCLE_ID = TC.TC_CYCLE_ID
RIGHT JOIN '||x.db_name||'.RELEASE_CYCLES RCYC ON RCYC.RCYC_ID = CY.CY_ASSIGN_RCYC
LEFT JOIN '||x.db_name||'.RELEASES REL ON REL.REL_ID = RCYC.RCYC_PARENT_ID
LEFT JOIN '||x.db_name||'.RELEASE_FOLDERS RF ON  RF.RF_ID = REL.REL_PARENT_ID 
INNER JOIN '||x.db_name||'.REQ_RELEASES RQR ON RQR.RQRL_RELEASE_ID=REL.REL_ID
INNER JOIN '||x.db_name||'.REQ RQ ON RQ.RQ_REQ_ID=RQR.RQRL_REQ_ID

/*-------- CANTIDAD ESTADO REQUERIMIENTO PARA VALIDACION DE CANTIDAD DE INSTANCIAS 

LEFT JOIN (
            SELECT RE1.REL_ID, REL_NAME, COUNT(DISTINCT(RQ_USER_02)) CANT_ESTADO
            FROM '||x.db_name||'.RELEASES RE1
            INNER JOIN '||x.db_name||'.REQ_RELEASES RQR ON RQR.RQRL_RELEASE_ID=RE1.REL_ID
            INNER JOIN '||x.db_name||'.REQ RQ ON RQ.RQ_REQ_ID=RQR.RQRL_REQ_ID
            WHERE 1=1
            --AND RE1.REL_ID = ''''1432''''
            AND RQ_TYPE_ID NOT IN (105, 106)
            GROUP BY RE1.REL_ID, REL_NAME
          ) CANT_EST ON CANT_EST.REL_ID = REL.REL_ID

-----------------------------------------------------------    */  

WHERE 1=1
AND RCYC.RCYC_NAME NOT LIKE ''%IDC%''
--AND(RF_PATH like ''AAAAAAAAA%'' Or RF_PATH like ''AAAAAAAAF%'' Or RF_PATH like ''AAAAAAAAR%'')
AND(RF_PATH like ''AAAAADAAB%'' Or RF_PATH like ''AAAAADAAD%'' Or RF_PATH like ''AAAAAAAAR%'')
AND RN.RN_STATUS IN (''Failed'', ''Passed'')
AND RN.RN_RUN_NAME NOT LIKE (''%Fast%'')
--AND RQ_USER_04 in (''Creado'', ''Estática QA'', ''Pendiente Dinámica'', ''Pruebas QA'', ''Suspendido'',''Ingresado'',''Fase Estática'',''Ambientación'',''Fase Dinámica'',''Pruebas UAT'', ''Cerrado QA'')
AND RQ.RQ_USER_02 not in (''Cerrado QA'', ''Cancelado'', ''Cerrado'', ''Cerrado sin IDC'', ''Cerrado con Observaciones'', ''Con Cobertura'', ''Con Defecto'', ''En Análisis'', ''En Diseño'', ''No Revisado'', ''Rechazado'')
AND RQ.RQ_TYPE_ID NOT IN (105, 106)
AND TS.TS_TYPE IN (''QUICKTEST_TEST'', ''SERVICE-TEST'', ''MANUAL'')
--AND REL.REL_ID = ''1584''
group by 
REL.REL_ID,                
REL.REL_USER_05,           
REL.REL_NAME,
TS.TS_TYPE,
TC.TC_STATUS, 
TC.TC_TESTER_NAME,
TC.TC_TESTCYCL_ID,
--RQ.RQ_USER_02,
TC.TC_EXEC_DATE,
REL.REL_USER_02,
RN.RN_RUN_ID,
RN.RN_RUN_NAME,
RN.RN_EXECUTION_DATE
--RN.RN_RUN_NAME
--CANT_ESTADO

';
end loop;

execute immediate  'insert into ALM_REPORT.DATA_EJE_INNOVACION 
select * from DATA_EJE_INNOVACION@SERVER_BCH
';


end;

/
