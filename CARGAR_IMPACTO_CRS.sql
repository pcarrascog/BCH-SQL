--------------------------------------------------------
--  DDL for Procedure CARGAR_IMPACTO_CRS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ALM_REPORT"."CARGAR_IMPACTO_CRS" AS 
BEGIN
 execute immediate 'TRUNCATE TABLE ALM_REPORT.BCH_CONSOLIDADO_CRS';
 
for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME from alm_siteadmin_db_12.projects where DB_NAME = 'bch_qa_certificación_bch_qa_d') loop
execute immediate  'insert into ALM_REPORT.BCH_CONSOLIDADO_CRS 

SELECT
REL.REL_ID                  "Id Release",
REL.REL_USER_TEMPLATE_01    "JPQA",
REL.REL_NAME                "Nombre Release",      
RCYC.RCYC_ID                "Id Ciclo", 
RCYC.RCYC_NAME              "Nombre Ciclo",
TC.TC_STATUS                "Estado Ejecución",
nvl (COUNT (DISTINCT TC.TC_TESTCYCL_ID),0)           "cant_Instancia",
RQ.rq_user_04 "Estado Requerimiento",
TC.TC_EXEC_DATE Fecha_Ejecución,
REL.REL_USER_TEMPLATE_02,
TC.TC_TESTCYCL_ID Id_Instancia,
defec2.id_bug,
defec2.estado_defecto,
defec2.severidad,
defec2.Detectado_Por,
defec2.Desarrollador_Asignado,
defec2.Responsable,
defec2.Resumen,
defec2.Detectado_en_Fecha,
defec2.Prioridad,
defec2.Jefe_QA,
defec2.Coordinador,
defec2.Fecha_de_Cierre,
defec2.Producto,
defec2.Sistema,
tabla.totalCP,
tabla2.plan3,
TO_NUMBER(RCYC_USER_TEMPLATE_01, ''9G999D99'') as plan2,
CY_CYCLE          "Nombre escenario de prueba",
''SERVIDOR TSOFT'' as SERVIDOR

FROM  '||x.db_name||'.TESTCYCL TC
LEFT JOIN '||x.db_name||'.CYCLE CY ON CY.CY_CYCLE_ID = TC.TC_CYCLE_ID
RIGHT JOIN '||x.db_name||'.RELEASE_CYCLES RCYC ON RCYC.RCYC_ID = CY.CY_ASSIGN_RCYC
LEFT JOIN '||x.db_name||'.RELEASES REL ON REL.REL_ID = RCYC.RCYC_PARENT_ID
LEFT JOIN '||x.db_name||'.RELEASE_FOLDERS RF ON  RF.RF_ID = REL.REL_PARENT_ID 
INNER JOIN '||x.db_name||'.REQ_RELEASES RQR ON RQR.RQRL_RELEASE_ID=REL.REL_ID
INNER JOIN '||x.db_name||'.REQ RQ ON RQ.RQ_REQ_ID=RQR.RQRL_REQ_ID
  
      --Trae la cantidad de defectos 
      LEFT  JOIN(
      SELECT 
      REL_ID,
      RCYC_ID, 
      BG_BUG_ID id_bug,
      BG_SEVERITY severidad, 
      bg_user_01 estado_defecto,
      BG_DETECTED_BY Detectado_Por,
      BG_USER_12 Desarrollador_Asignado,
      BG_RESPONSIBLE Responsable,
      BG_SUMMARY Resumen,
      BG_DETECTION_DATE Detectado_en_Fecha,
      BG_PRIORITY Prioridad,
      BG_USER_07 Jefe_QA,
      BG_USER_06 Coordinador,
      BG_CLOSING_DATE Fecha_de_Cierre,
      BG_USER_03 Producto,
      BG_USER_02 Sistema

      FROM  '||x.db_name||'.BUG b
      LEFT JOIN '||x.db_name||'.RELEASES R ON R.REL_ID = b.BG_TARGET_REL OR b.BG_DETECTED_IN_REL = R.REL_ID
      LEFT JOIN '||x.db_name||'.RELEASE_CYCLES RC ON RC.RCYC_ID = b.BG_DETECTED_IN_RCYC OR b.BG_TARGET_RCYC = RC.RCYC_ID
      WHERE 1=1
      ) defec2 on defec2.RCYC_ID = RCYC.RCYC_ID


      LEFT JOIN(
      SELECT
      RCYC_ID id_ciclo2,
      count(TC1.TC_TESTCYCL_ID) totalCP
      FROM  '||x.db_name||'.TESTCYCL TC1
      LEFT JOIN '||x.db_name||'.CYCLE CY1 ON TC1.TC_CYCLE_ID = CY1.CY_CYCLE_ID
      LEFT JOIN '||x.db_name||'.RELEASE_CYCLES RCYC1 ON CY1.CY_ASSIGN_RCYC = RCYC1.RCYC_ID
      LEFT JOIN '||x.db_name||'.RELEASES REL1 ON RCYC1.RCYC_PARENT_ID = REL1.REL_ID
      LEFT JOIN '||x.db_name||'.TEST TS1 ON TC1.TC_TEST_ID = TS1.TS_TEST_ID
      WHERE REL1.REL_ID IN (''1765'')
      GROUP BY RCYC1.RCYC_ID
      )tabla on tabla.id_ciclo2 = RCYC.RCYC_ID  

      LEFT JOIN(
      SELECT
      RCYC_ID id_ciclo,
      RCYC_USER_TEMPLATE_01 plan3
      FROM  '||x.db_name||'.RELEASE_CYCLES 
      LEFT JOIN '||x.db_name||'.RELEASES ON RCYC_PARENT_ID = REL_ID
      WHERE REL_ID IN (''1765'')
      )tabla2 on tabla2.id_ciclo = RCYC.RCYC_ID

    
WHERE 1=1
AND REL.REL_ID IN (''1765'')

group by 
REL.REL_ID ,
RCYC.RCYC_NAME ,
REL.REL_USER_TEMPLATE_01,
REL.REL_NAME,  
RCYC.RCYC_ID, 
RCYC.RCYC_NAME,
TC.TC_STATUS ,
RQ.rq_user_04,
TC.TC_EXEC_DATE,
REL.REL_USER_TEMPLATE_02,
TC.TC_TESTCYCL_ID,
defec2.id_bug,
defec2.estado_defecto,
defec2.severidad,
tabla.totalCP,
tabla2.plan3,
RCYC_USER_TEMPLATE_01,
CY_CYCLE,
defec2.Detectado_Por,
defec2.Desarrollador_Asignado,
defec2.Responsable,
defec2.Resumen,
defec2.Detectado_en_Fecha,
defec2.Prioridad,
defec2.Jefe_QA,
defec2.Coordinador,
defec2.Fecha_de_Cierre,
defec2.Producto,
defec2.Sistema

'; end loop;



execute immediate  'insert into ALM_REPORT.BCH_CONSOLIDADO_CRS 
select * from BCH_CONSOLIDADO_CRS@SERVER_BCH
';

END;

/
