--------------------------------------------------------
--  DDL for Procedure CARGAR_DATA_360
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ALM_REPORT"."CARGAR_DATA_360" AS 
BEGIN
execute immediate 'TRUNCATE TABLE ALM_REPORT.DATA_360';


for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME from alm_siteadmin_db_12.projects where DB_NAME = 'bch_qa_certificación_bch_qa_d') loop
execute immediate  'insert into ALM_REPORT.DATA_360 
select 
'''||x.PROJECT_NAME||''' as Proyecto,
'''||x.DOMAIN_NAME||''' as dominio,
tab_a.* , 
tab_b.* ,
tab_c.* 
from  (

SELECT
REL.REL_ID || '' ''|| REL.REL_NAME  FK_concatenacion,
REL.REL_ID ||'' ''|| REL.REL_NAME ||'' ''|| RCYC.RCYC_NAME FK_concatenacion2,
REL.REL_ID ||'' ''|| REL.REL_NAME ||'' ''|| RCYC.RCYC_NAME FK_concatenacion3,
REL.REL_ID                  "Id Release",
REL.REL_USER_TEMPLATE_01    "JPQA",
REL.REL_NAME                "Nombre Release",
TO_DATE(REL.REL_USER_03, ''YYYY/MM/DD'') "Fecha Inicio Plan Release",
TO_DATE(REL.REL_USER_02 , ''YYYY/MM/DD'') "Fecha Fin Plan Release",
--DIAS_LABORABLES( TO_DATE(REL.REL_USER_03, ''YYYY/MM/DD''),SYSDATE) "Avance en días", 
DIAS_LABORABLES(REL.REL_START_DATE,SYSDATE) "Avance en días", 
SYSDATE "actual",  
DIAS_LABORABLES (REL.REL_START_DATE,REL.REL_END_DATE) "Total RPlan Rel",       
REL.REL_START_DATE          "Fecha Inicio Re-Plan Release",
REL.REL_END_DATE            "Fecha Fin Re-Plan Release",
DIAS_LABORABLES( TO_DATE(REL.REL_USER_03, ''YYYY/MM/DD''),TO_DATE(REL.REL_USER_02, ''YYYY/MM/DD'')) "Dias rel plan", 
DIAS_LABORABLES( REL.REL_START_DATE,TO_DATE(REL.REL_USER_03, ''YYYY/MM/DD'')) "Defase Inicio Rel", 
RCYC.RCYC_ID                "Id Ciclo", 
RCYC.RCYC_NAME              "Nombre Ciclo",
TO_DATE(RCYC.RCYC_USER_02, ''YYYY/MM/DD'') "Fecha Inicio Plan Ciclo",
TO_DATE(RCYC.RCYC_USER_03, ''YYYY/MM/DD'') "Fecha Fin Plan Ciclo",
RCYC.RCYC_START_DATE        "Fecha Inicio Re-Plan Ciclo",
RCYC.RCYC_END_DATE          "Fecha Fin Re-Plan Ciclo",
TC.TC_STATUS                "Estado Ejecución",
nvl (COUNT (DISTINCT TC.TC_TESTCYCL_ID),0)           "cant_Instancia",
--TC.TC_TEST_ID               "Id Test",
nvl (defec.Cant_iteraciones,0),
nvl (defec.Cant_def,0),
nvl (defec.prom_iteraciones,0),
nvl (defec2.total_defectos,0),
nvl (defec13.prom_añejamiento,0),
--desfase_inicio,
--desfase_rel+desfase_inicio,
desfase_inicio,
RQ.rq_user_04 "Estado Requerimiento",
TC.TC_EXEC_DATE Fecha_Ejecución,
REL.REL_USER_TEMPLATE_02,
nvl (total_defectos2, 0),
nvl (total_def_low, 0),
nvl (total_def_Medium, 0),
nvl (total_def_High, 0),
nvl (total_def_Very_High, 0),
nvl (total_def_Urgent, 0),
nvl (total_def_ambiente,0) AS TOT_AMBIENTE,
0 AS TOT_EJE_AUTO,
nvl (total_def_Eliminar,0) AS TOT_ELIMINAR,
nvl (total_def_Diseño,0) AS TOT_DISEÑO,
nvl (total_def_software,0) AS TOT_SOFTWARE,
''SERVIDOR TSOFT'' as SERVIDOR


FROM  '||x.db_name||'.TESTCYCL TC
LEFT JOIN '||x.db_name||'.CYCLE CY ON CY.CY_CYCLE_ID = TC.TC_CYCLE_ID
RIGHT JOIN '||x.db_name||'.RELEASE_CYCLES RCYC ON RCYC.RCYC_ID = CY.CY_ASSIGN_RCYC
LEFT JOIN '||x.db_name||'.RELEASES REL ON REL.REL_ID = RCYC.RCYC_PARENT_ID
LEFT JOIN '||x.db_name||'.RELEASE_FOLDERS RF ON  RF.RF_ID = REL.REL_PARENT_ID 
INNER JOIN '||x.db_name||'.REQ_RELEASES RQR ON RQR.RQRL_RELEASE_ID=REL.REL_ID
INNER JOIN '||x.db_name||'.REQ RQ ON RQ.RQ_REQ_ID=RQR.RQRL_REQ_ID


--Trae la cantidad de iteraciones por releases
-----------------------------------------
      LEFT  JOIN(
      SELECT 
      re.rel_id, COUNT (b.BG_BUG_ID) as Cant_def, Cant_iteraciones, (Cant_iteraciones/COUNT (b.BG_BUG_ID)) prom_iteraciones
      FROM  '||x.db_name||'.BUG b
      JOIN '||x.db_name||'.RELEASES re ON b.BG_TARGET_REL = re.REL_ID      
      JOIN '||x.db_name||'.RELEASE_CYCLES ON BG_TARGET_RCYC = RCYC_ID

          LEFT  JOIN (SELECT 
          rel_id, COUNT (AP_NEW_VALUE) as Cant_iteraciones
          FROM  '||x.db_name||'.BUG b
          LEFT JOIN '||x.db_name||'.RELEASES  ON b.BG_TARGET_REL = REL_ID
          LEFT JOIN  '||x.db_name||'.AUDIT_LOG  ON AU_ENTITY_ID = BG_BUG_ID
          LEFT JOIN '||x.db_name||'.AUDIT_PROPERTIES  ON AP_ACTION_ID = AU_ACTION_ID
          LEFT JOIN '||x.db_name||'.RELEASE_CYCLES ON BG_TARGET_RCYC = RCYC_ID
          WHERE AU_ENTITY_TYPE = ''BUG''
          AND AP_PROPERTY_NAME like ''%06- Estado%''
          AND AP_NEW_VALUE  = ''Listo para Probar''
          AND RCYC_NAME NOT LIKE ''%IDC%''
          --AND REL_ID = ''1412''
          group by rel_id) cant_ite on cant_ite.rel_id = re.rel_id  
  
      WHERE 1=1
      AND RCYC_NAME NOT LIKE ''%IDC%''
      AND b.BG_USER_01 NOT IN (''Cancelado'',''No Aplica'')
      --AND re.REL_ID IN (''1412'')
      group by re.rel_id, Cant_iteraciones) defec on defec.rel_id = rel.rel_id
      
  
      --Trae la cantidad de defectos 
      LEFT  JOIN(
      SELECT 
      rel_id, COUNT(BG_BUG_ID) as total_defectos
      FROM  '||x.db_name||'.BUG b
      JOIN '||x.db_name||'.RELEASES ON b.BG_TARGET_REL = REL_ID      
      JOIN '||x.db_name||'.RELEASE_CYCLES ON BG_TARGET_RCYC = RCYC_ID
      WHERE 1=1
      AND b.BG_USER_01 NOT IN (''Cancelado'',''No Aplica'')
      AND RCYC_NAME NOT LIKE ''%IDC%'' group by rel_id) defec2 on defec2.rel_id = rel.rel_id
-----------------------------------------

--Trae la cantidad de defectos abiertos
      LEFT  JOIN(
            SELECT 
            rel_id, RCYC_ID, COUNT(BG_BUG_ID) as total_defectos2
            FROM '||x.db_name||'.BUG b
            JOIN '||x.db_name||'.RELEASES ON b.BG_TARGET_REL = REL_ID      
            JOIN '||x.db_name||'.RELEASE_CYCLES ON BG_TARGET_RCYC = RCYC_ID
            WHERE 1=1
            AND b.BG_USER_01 NOT IN (''Cancelado'',''Cerrado'',''No Aplica'')
            AND RCYC_NAME NOT LIKE ''%IDC%'' 
      group by rel_id, RCYC_ID) defec3 on defec3.rel_id = rel.rel_id and RCYC.RCYC_ID = defec3.RCYC_ID
-----------------------------------------

--Trae la cantidad de defectos severidad 1-Low 2-Medium 3-High "4-Very High" 5-Urgent
      LEFT  JOIN(
            SELECT 
            rel_id, RCYC_ID, COUNT(BG_BUG_ID) as total_def_low
            FROM '||x.db_name||'.BUG b
            JOIN '||x.db_name||'.RELEASES ON b.BG_TARGET_REL = REL_ID      
            JOIN '||x.db_name||'.RELEASE_CYCLES ON BG_TARGET_RCYC = RCYC_ID
            WHERE 1=1
            AND b.BG_SEVERITY IN (''1-Low'')
            AND RCYC_NAME NOT LIKE ''%IDC%'' 
            --AND b.BG_USER_01 NOT IN (''Cancelado'',''No Aplica'')
            AND b.BG_USER_01 NOT IN (''Cancelado'',''Cerrado'',''No Aplica'')
      group by rel_id, RCYC_ID) defec4 on defec4.rel_id = rel.rel_id and RCYC.RCYC_ID = defec4.RCYC_ID
-----------------------------------------

--Trae la cantidad de defectos severidad 1-Low 2-Medium 3-High "4-Very High" 5-Urgent
      LEFT  JOIN(
            SELECT 
            rel_id, RCYC_ID, COUNT(BG_BUG_ID) as total_def_Medium
            FROM '||x.db_name||'.BUG b
            JOIN '||x.db_name||'.RELEASES ON b.BG_TARGET_REL = REL_ID      
            JOIN '||x.db_name||'.RELEASE_CYCLES ON BG_TARGET_RCYC = RCYC_ID
            WHERE 1=1
            AND b.BG_SEVERITY IN (''2-Medium'')
            AND RCYC_NAME NOT LIKE ''%IDC%'' 
            --AND b.BG_USER_01 NOT IN (''Cancelado'',''No Aplica'')
            AND b.BG_USER_01 NOT IN (''Cancelado'',''Cerrado'',''No Aplica'')
      group by rel_id, RCYC_ID) defec5 on defec5.rel_id = rel.rel_id and RCYC.RCYC_ID = defec5.RCYC_ID
-----------------------------------------

--Trae la cantidad de defectos severidad 1-Low 2-Medium 3-High "4-Very High" 5-Urgent
      LEFT  JOIN(
            SELECT 
            rel_id, RCYC_ID, COUNT(BG_BUG_ID) as total_def_High
            FROM '||x.db_name||'.BUG b
            JOIN '||x.db_name||'.RELEASES ON b.BG_TARGET_REL = REL_ID      
            JOIN '||x.db_name||'.RELEASE_CYCLES ON BG_TARGET_RCYC = RCYC_ID
            WHERE 1=1
            AND b.BG_SEVERITY IN (''3-High'')
            AND RCYC_NAME NOT LIKE ''%IDC%'' 
            --AND b.BG_USER_01 NOT IN (''Cancelado'',''No Aplica'')
            AND b.BG_USER_01 NOT IN (''Cancelado'',''Cerrado'',''No Aplica'')
      group by rel_id, RCYC_ID) defec6 on defec6.rel_id = rel.rel_id and RCYC.RCYC_ID = defec6.RCYC_ID
-----------------------------------------

--Trae la cantidad de defectos severidad 1-Low 2-Medium 3-High "4-Very High" 5-Urgent
      LEFT  JOIN(
            SELECT 
            rel_id, RCYC_ID, COUNT(BG_BUG_ID) as total_def_Very_High
            FROM '||x.db_name||'.BUG b
            JOIN '||x.db_name||'.RELEASES ON b.BG_TARGET_REL = REL_ID      
            JOIN '||x.db_name||'.RELEASE_CYCLES ON BG_TARGET_RCYC = RCYC_ID
            WHERE 1=1
            AND b.BG_SEVERITY IN (''4-Very High'')
            AND RCYC_NAME NOT LIKE ''%IDC%'' 
            --AND b.BG_USER_01 NOT IN (''Cancelado'',''No Aplica'')
            AND b.BG_USER_01 NOT IN (''Cancelado'',''Cerrado'',''No Aplica'')
      group by rel_id, RCYC_ID) defec7 on defec7.rel_id = rel.rel_id and RCYC.RCYC_ID = defec7.RCYC_ID
-----------------------------------------

--Trae la cantidad de defectos severidad 1-Low 2-Medium 3-High "4-Very High" 5-Urgent
      LEFT  JOIN(
            SELECT 
            rel_id, RCYC_ID, COUNT(BG_BUG_ID) as total_def_Urgent
            FROM '||x.db_name||'.BUG b
            JOIN '||x.db_name||'.RELEASES ON b.BG_TARGET_REL = REL_ID      
            JOIN '||x.db_name||'.RELEASE_CYCLES ON BG_TARGET_RCYC = RCYC_ID
            WHERE 1=1
            AND b.BG_SEVERITY IN (''5-Urgent'')
            AND RCYC_NAME NOT LIKE ''%IDC%''
            --AND b.BG_USER_01 NOT IN (''Cancelado'',''No Aplica'')
            AND b.BG_USER_01 NOT IN (''Cancelado'',''Cerrado'',''No Aplica'')
      group by rel_id, RCYC_ID) defec8 on defec8.rel_id = rel.rel_id and RCYC.RCYC_ID = defec8.RCYC_ID
-----------------------------------------



--Trae la cantidad de defectos Ambiente
      LEFT  JOIN(
            SELECT 
            rel_id, RCYC_ID, COUNT(BG_BUG_ID) as total_def_ambiente
            FROM '||x.db_name||'.BUG b
            JOIN '||x.db_name||'.RELEASES ON b.BG_TARGET_REL = REL_ID      
            JOIN '||x.db_name||'.RELEASE_CYCLES ON BG_TARGET_RCYC = RCYC_ID
            WHERE 1=1
            AND b.BG_USER_08 IN (''Error de Ambiente Hardware'', ''Error de Ambiente Software'')
            AND RCYC_NAME NOT LIKE ''%IDC%'' 
            AND b.BG_USER_01 NOT IN (''Cancelado'',''No Aplica'')
      group by rel_id, RCYC_ID) defec9 on defec9.rel_id = rel.rel_id and RCYC.RCYC_ID = defec9.RCYC_ID
-----------------------------------------


--Trae la cantidad de defectos Software
      LEFT  JOIN(
            SELECT 
            rel_id, RCYC_ID, COUNT(BG_BUG_ID) as total_def_software
            FROM '||x.db_name||'.BUG b
            JOIN '||x.db_name||'.RELEASES ON b.BG_TARGET_REL = REL_ID      
            JOIN '||x.db_name||'.RELEASE_CYCLES ON BG_TARGET_RCYC = RCYC_ID
            WHERE 1=1
            AND b.BG_USER_08 IN (''Error de Codificación - Funcional'', ''Error de Codificación - IDC'')
            AND RCYC_NAME NOT LIKE ''%IDC%''
            AND b.BG_USER_01 NOT IN (''Cancelado'',''No Aplica'')
      group by rel_id, RCYC_ID) defec10 on defec10.rel_id = rel.rel_id and RCYC.RCYC_ID = defec10.RCYC_ID
-----------------------------------------



--Trae la cantidad de defectos Diseño
      LEFT  JOIN(
            SELECT 
            rel_id, RCYC_ID, COUNT(BG_BUG_ID) as total_def_Diseño
            FROM '||x.db_name||'.BUG b
            JOIN '||x.db_name||'.RELEASES ON b.BG_TARGET_REL = REL_ID      
            JOIN '||x.db_name||'.RELEASE_CYCLES ON BG_TARGET_RCYC = RCYC_ID
            WHERE 1=1
            AND b.BG_USER_08 IN (''Error de Análisis de Ambiguedad'',''Error de Diseño'')
            AND RCYC_NAME NOT LIKE ''%IDC%'' 
            AND b.BG_USER_01 NOT IN (''Cancelado'',''No Aplica'')
      group by rel_id, RCYC_ID) defec11 on defec11.rel_id = rel.rel_id and RCYC.RCYC_ID = defec11.RCYC_ID
-----------------------------------------


--Trae la cantidad de defectos Eliminar
      LEFT  JOIN(
            SELECT 
            rel_id, RCYC_ID, COUNT(BG_BUG_ID) as total_def_Eliminar
            FROM '||x.db_name||'.BUG b
            JOIN '||x.db_name||'.RELEASES ON b.BG_TARGET_REL = REL_ID      
            JOIN '||x.db_name||'.RELEASE_CYCLES ON BG_TARGET_RCYC = RCYC_ID
            WHERE 1=1
            AND b.BG_USER_08 IN (''Error de Parámetros'', ''Error de Procesamiento de Interfaces'', ''Error de Pruebas'', ''Error de Requerimiento'', ''Error por Omisión'', ''QTP'')
            AND RCYC_NAME NOT LIKE ''%IDC%'' 
            AND b.BG_USER_01 NOT IN (''Cancelado'',''No Aplica'')
      group by rel_id, RCYC_ID) defec12 on defec12.rel_id = rel.rel_id and RCYC.RCYC_ID = defec12.RCYC_ID
-----------------------------------------



--Trae el añejamiento
-----------------------------------------      
      
      LEFT JOIN (SELECT RPROM.REL_ID, SUM(prom_añejamiento1)/COUNT(CANT_OK) AS prom_añejamiento 
      FROM  '||x.db_name||'.RELEASES RPROM
      LEFT JOIN '||x.db_name||'.RELEASE_FOLDERS RF ON  RF.RF_ID = RPROM.REL_PARENT_ID 

         LEFT JOIN ( 
        SELECT RA.rel_id, B.bg_bug_id, b.bg_detection_date, sysdate, b.bg_status,
        CASE WHEN BG_STATUS = ''Cerrado'' THEN ''OK''
        WHEN BG_STATUS NOT IN (''Cerrado'', ''Cancelado'', ''No Aplica'') THEN ''OK'' ELSE ''1'' end AS CANT_OK,
         CASE WHEN BG_STATUS NOT IN (''Cerrado'', ''Cancelado'', ''No Aplica'') THEN
        --((nvl( sum (DIAS_LABORABLES (bg_detection_date,sysdate))/ count (distinct b.bg_bug_id)-1,0))) else prom_añejamiento2 END  as 
        nvl (sum (DIAS_LABORABLES (bg_detection_date,sysdate)),0) else prom_añejamiento2 END  as
        prom_añejamiento1        
                    FROM '||x.db_name||'.BUG b
                    JOIN '||x.db_name||'.RELEASE_CYCLES ON BG_TARGET_RCYC = RCYC_ID
                    JOIN '||x.db_name||'.RELEASES RA  ON b.BG_TARGET_REL = RA.REL_ID
                    
                    LEFT JOIN (SELECT rel_id , BG_BUG_ID as id_BG,                                    
                                  --(nvl( sum (DIAS_LABORABLES (bg_detection_date,AU_TIME))/ count (distinct bg_bug_id)-1,0)) as prom_añejamiento2 
                                  MAX( (DIAS_LABORABLES (bg_detection_date,AU_TIME))) as prom_añejamiento2               
                                  FROM '||x.db_name||'.BUG
                                  JOIN '||x.db_name||'.AUDIT_LOG  ON AU_ENTITY_ID = BG_BUG_ID
                                  JOIN '||x.db_name||'.AUDIT_PROPERTIES  ON AP_ACTION_ID = AU_ACTION_ID
                                  JOIN '||x.db_name||'.RELEASE_CYCLES ON BG_TARGET_RCYC = RCYC_ID
                                  JOIN '||x.db_name||'.RELEASES  ON BG_TARGET_REL = REL_ID 
                                  WHERE AU_ENTITY_TYPE = ''BUG''                
                                  AND AP_NEW_VALUE  IN (''Cerrado'')
                                  AND AP_PROPERTY_NAME like ''%06- Estado%''		
                                 -- and rel_id = ''1140''
                                  AND RCYC_NAME NOT LIKE ''%IDC%''
                                  group by rel_id, BG_BUG_ID) BH ON BH.id_BG =  B.BG_BUG_ID AND BH.rel_id = RA.REL_ID              
                  where 1=1
                 -- and RA.rel_id = ''1140''
                  and b.bg_status not in (''Cancelado'', ''No Aplica'')
                  AND RCYC_NAME NOT LIKE ''%IDC%''
                  group by RA.rel_id, b.bg_bug_id, b.bg_detection_date, b.bg_status, sysdate, prom_añejamiento2
                  
                  ) defproma ON defproma.rel_id = rprom.rel_id 
                  
                 --AND RPROM.REL_ID = ''1140''
             AND(RF.RF_PATH not like ''AAAAAB%''  AND RF.RF_PATH not like ''AAAAAF%'' AND RF.RF_PATH not like ''AAAAAC%'' AND RF.RF_PATH not like ''AAAAAD%'' AND RF.RF_PATH not like ''AAAAAE%'')     
             group by RPROM.REL_ID ) defec13 on defec13.rel_id = rel.rel_id
      
-----------------------------------------
      
--Trae el desfase de inicio      
-----------------------------------------
                LEFT  JOIN (SELECT REL1.REL_ID,     
(CASE WHEN
TO_DATE (REL1.REL_USER_03,''YYYY/MM/DD'') <= MIN(REL1.REL_START_DATE) THEN
(DIAS_LABORABLES(TO_DATE (REL1.REL_USER_03,''YYYY/MM/DD''), MIN(REL1.REL_START_DATE)))-1 ELSE -(DIAS_LABORABLES(MIN(REL1.REL_START_DATE), TO_DATE (REL1.REL_USER_03,''YYYY/MM/DD'')))  END) AS desfase_rel,               
                                
                SUM((desfase_run_cicl)) as desfase_inicio
                FROM '||x.db_name||'.RELEASES REL1
                JOIN '||x.db_name||'.RELEASE_CYCLES RC ON REL1.REL_ID = RC.RCYC_PARENT_ID
                                LEFT  JOIN 
                                (SELECT REL_ID, RCYC_ID,
                                (CASE WHEN
                                TO_DATE (RCYC_USER_02,''YYYY/MM/DD'') <= MIN(RN_EXECUTION_DATE) THEN
                                (DIAS_LABORABLES(TO_DATE (RCYC_USER_02,''YYYY/MM/DD''), MIN(RN_EXECUTION_DATE))) ELSE -(DIAS_LABORABLES(MIN(RN_EXECUTION_DATE), TO_DATE (RCYC_USER_02,''YYYY/MM/DD'')))  END) AS desfase_run_cicl
                                FROM '||x.db_name||'.RUN
                                JOIN '||x.db_name||'.TESTCYCL ON TC_TESTCYCL_ID = RN_TESTCYCL_ID
                                JOIN '||x.db_name||'.RELEASE_CYCLES ON TC_ASSIGN_RCYC = RCYC_ID
                                JOIN '||x.db_name||'.CYCLE ON TC_CYCLE_ID = CY_CYCLE_ID
                                JOIN '||x.db_name||'.RELEASES on rcyc_parent_id = rel_id
                                WHERE 1=1
                                --CAMBIE EL BUSCAR POR CICLO
                                --AND RCYC_NAME LIKE ''%uncional%''
                                --AND REL_ID = ''1412''
                                AND RCYC_NAME NOT LIKE ''%IDC%''
                                GROUP BY REL_ID, RCYC_ID, REL_USER_03, REL_START_DATE, RCYC_USER_02) Des_ini ON REL1.REL_ID = Des_ini.REL_ID and Des_ini.RCYC_ID = RC.RCYC_ID
                                WHERE 1=1                                
AND RC.RCYC_NAME NOT LIKE ''%IDC%''
--AND REL1.REL_ID = ''1412''
GROUP BY REL1.REL_ID, REL1.REL_USER_03, REL1.REL_START_DATE) des_ini1 on rel.rel_id = des_ini1.rel_id

-----------------------------------------  

WHERE 1=1

AND RCYC.RCYC_NAME NOT LIKE ''%IDC%''
AND(RF.RF_PATH not like ''AAAAAD%''  AND RF.RF_PATH not like ''AAAAADAAC%'' AND RF.RF_PATH not like ''AAAAADAAB%'' AND RF.RF_PATH not like ''AAAAAG%'' AND RQ.RQ_REQ_PATH not like ''AAAAAC%'')
AND RQ_USER_04 in (''Creado'', ''Estática QA'', ''Pendiente Dinámica'', ''Pruebas QA'', ''Suspendido'',''Ingresado'',''Fase Estática'',''Ambientación'',''Fase Dinámica'',''Pruebas UAT'', ''Cerrado QA'', ''En Producción'')
AND RQ_TYPE_ID IN (119,117,107,116)
--AND REL.REL_ID = ''1548''

group by 
REL.REL_ID ,
RCYC.RCYC_NAME ,
REL.REL_USER_TEMPLATE_01    ,
REL.REL_NAME               ,  
REL_USER_03,
REL_USER_02,
RCYC_USER_02,
RCYC_USER_03,
REL.REL_START_DATE         ,
REL.REL_END_DATE           ,
RCYC.RCYC_ID                , 
RCYC.RCYC_NAME              ,
RCYC.RCYC_START_DATE        ,
RCYC.RCYC_END_DATE          ,
TC.TC_STATUS  ,
defec.Cant_iteraciones,
defec.Cant_def,
defec.prom_iteraciones,
defec2.total_defectos,
defec13.prom_añejamiento,
desfase_inicio,
--desfase_rel,
RQ.rq_user_04,
TC.TC_EXEC_DATE,
REL.REL_USER_TEMPLATE_02,
total_defectos2,
total_def_low,
total_def_Medium,
total_def_High,
total_def_Very_High,
total_def_Urgent,
total_def_ambiente,
0,
total_def_Eliminar,
total_def_Diseño,
total_def_software

)  tab_a
-----------------------------------------
left join ( SELECT
REL.REL_ID ||'' '' || REL.REL_NAME  PK_concatenacion,
count(TC.TC_TESTCYCL_ID)           "Cantidad Exitoso"

FROM  '||x.db_name||'.TESTCYCL TC

LEFT JOIN '||x.db_name||'.CYCLE CY ON CY.CY_CYCLE_ID = TC.TC_CYCLE_ID
LEFT JOIN '||x.db_name||'.RELEASE_CYCLES RCYC ON RCYC.RCYC_ID = CY.CY_ASSIGN_RCYC
LEFT JOIN '||x.db_name||'.RELEASES REL ON REL.REL_ID = RCYC.RCYC_PARENT_ID

WHERE 1=1
--AND RCYC.RCYC_NAME LIKE ''%uncional%''
AND RCYC.RCYC_NAME NOT LIKE ''%IDC%''
AND TC.TC_STATUS = ''Passed''
group by REL.REL_ID ||'' '' || REL.REL_NAME) tab_b on tab_b.PK_concatenacion=tab_a.FK_concatenacion

left join (
SELECT
R.REL_ID ||'' '' || R.REL_NAME ||'' '' || RCYC_NAME PK_concatenacion3,

RCYC_START_DATE, RCYC_ID, rcyc_name, MAX(RN_EXECUTION_DATE), TABLA.fecha_ultima_eje
FROM '||x.db_name||'.RUN
JOIN '||x.db_name||'.TESTCYCL ON TC_TESTCYCL_ID = RN_TESTCYCL_ID
JOIN '||x.db_name||'.RELEASE_CYCLES ON TC_ASSIGN_RCYC = RCYC_ID
JOIN '||x.db_name||'.CYCLE ON TC_CYCLE_ID = CY_CYCLE_ID
JOIN '||x.db_name||'.RELEASES R on rcyc_parent_id = R.rel_id

       LEFT JOIN (SELECT REL_ID, REL_NAME, MAX(RN_EXECUTION_DATE) as fecha_ultima_eje
       FROM '||x.db_name||'.RUN
       JOIN '||x.db_name||'.TESTCYCL ON TC_TESTCYCL_ID = RN_TESTCYCL_ID
       JOIN '||x.db_name||'.RELEASE_CYCLES ON TC_ASSIGN_RCYC = RCYC_ID
       JOIN '||x.db_name||'.CYCLE ON TC_CYCLE_ID = CY_CYCLE_ID
       JOIN '||x.db_name||'.RELEASES on rcyc_parent_id = rel_id
       WHERE 1=1
       AND RCYC_NAME NOT LIKE ''%IDC%''
       GROUP BY REL_ID, REL_NAME
       ORDER BY REL_ID)  TABLA ON TABLA.REL_ID = R.REL_ID  

WHERE 1=1
AND RCYC_NAME NOT LIKE ''%IDC%''
GROUP BY R.REL_ID, R.REL_NAME, RCYC_ID, RCYC_START_DATE, RCYC_NAME, TABLA.fecha_ultima_eje
ORDER BY R.REL_ID

) tab_c on tab_a.FK_concatenacion3=tab_c.PK_concatenacion3



';
end loop;


for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME  from alm_siteadmin_db_12.projects where DB_NAME = 'qa_qa_db0') loop
execute immediate  'insert into ALM_REPORT.DATA_360 
select 
'''||x.PROJECT_NAME||''' as Proyecto,
'''||x.DOMAIN_NAME||''' as dominio,
tab_a.* , 
tab_b.* ,
tab_c.* 
from  (

SELECT
REL.REL_ID ||'' ''|| REL.REL_NAME  FK_concatenacion,
REL.REL_ID ||'' ''|| REL.REL_NAME ||'' ''|| RCYC.RCYC_NAME FK_concatenacion2,
REL.REL_ID ||'' ''|| REL.REL_NAME ||'' ''|| RCYC.RCYC_NAME FK_concatenacion3,
REL.REL_ID                  "Id Release",
REL.REL_USER_05    "JPQA",
REL.REL_NAME                "Nombre Release",
TO_DATE(REL.REL_USER_01, ''YYYY/MM/DD'') "Fecha Inicio Plan Release",
TO_DATE(REL.REL_USER_03 , ''YYYY/MM/DD'') "Fecha Fin Plan Release",
--DIAS_LABORABLES( TO_DATE(REL.REL_USER_01, ''YYYY/MM/DD''),SYSDATE) "Avance en días", 
DIAS_LABORABLES(REL.REL_START_DATE,SYSDATE) "Avance en días", 
SYSDATE "actual",  
DIAS_LABORABLES (REL.REL_START_DATE,REL.REL_END_DATE) "Total RPlan Rel",       
REL.REL_START_DATE          "Fecha Inicio Re-Plan Release",
REL.REL_END_DATE            "Fecha Fin Re-Plan Release",
DIAS_LABORABLES( TO_DATE(REL.REL_USER_01, ''YYYY/MM/DD''),TO_DATE(REL.REL_USER_03, ''YYYY/MM/DD'')) "Dias rel plan", 
DIAS_LABORABLES( REL.REL_START_DATE,TO_DATE(REL.REL_USER_01, ''YYYY/MM/DD'')) "Defase Inicio Rel", 
RCYC.RCYC_ID                "Id Ciclo", 
RCYC.RCYC_NAME              "Nombre Ciclo",
TO_DATE(RCYC.RCYC_USER_01, ''YYYY/MM/DD'') "Fecha Inicio Plan Ciclo",
TO_DATE(RCYC.RCYC_USER_02, ''YYYY/MM/DD'') "Fecha Fin Plan Ciclo",
RCYC.RCYC_START_DATE        "Fecha Inicio Re-Plan Ciclo",
RCYC.RCYC_END_DATE          "Fecha Fin Re-Plan Ciclo",
TC.TC_STATUS                "Estado Ejecución",
--nvl (COUNT (DISTINCT TC.TC_TESTCYCL_ID),0)           "cant_Instancia",

CASE WHEN CANT_ESTADO > 1 
THEN nvl (COUNT (DISTINCT TC.TC_TESTCYCL_ID),0)/CANT_ESTADO 
ELSE nvl (COUNT (DISTINCT TC.TC_TESTCYCL_ID),0) END "cant_Instancia",

--TC.TC_TEST_ID               "Id Test",
nvl (defec.Cant_iteraciones,0),
nvl (defec.Cant_def,0),
nvl (defec.prom_iteraciones,0),
nvl (defec2.total_defectos,0),
nvl (defec13.prom_añejamiento,0),
--desfase_rel+desfase_inicio,
desfase_inicio,
RQ.RQ_USER_02 "Estado Requerimiento",
TC.TC_EXEC_DATE Fecha_Ejecución,
REL.REL_USER_02,
nvl (total_defectos2,0),
nvl (total_def_low, 0),
nvl (total_def_Medium, 0),
nvl (total_def_High, 0),
nvl (total_def_Very_High, 0),
nvl (total_def_Urgent, 0),
nvl (total_def_Ambiente,0) AS TOT_AMBIENTE,
0 AS TOT_EJE_AUTO,
nvl (total_def_Eliminar,0) AS TOT_ELIMINAR,
nvl (total_def_Diseño, 0) AS TOT_DISEÑO,
nvl (total_def_Software, 0) AS TOT_SOFTWARE,
''SERVIDOR TSOFT'' as SERVIDOR

FROM  '||x.db_name||'.TESTCYCL TC
LEFT JOIN '||x.db_name||'.CYCLE CY ON CY.CY_CYCLE_ID = TC.TC_CYCLE_ID
RIGHT JOIN '||x.db_name||'.RELEASE_CYCLES RCYC ON RCYC.RCYC_ID = CY.CY_ASSIGN_RCYC
LEFT JOIN '||x.db_name||'.RELEASES REL ON REL.REL_ID = RCYC.RCYC_PARENT_ID
LEFT JOIN '||x.db_name||'.RELEASE_FOLDERS RF ON  RF.RF_ID = REL.REL_PARENT_ID
INNER JOIN '||x.db_name||'.REQ_RELEASES RQR ON RQR.RQRL_RELEASE_ID=REL.REL_ID
INNER JOIN '||x.db_name||'.REQ RQ ON RQ.RQ_REQ_ID=RQR.RQRL_REQ_ID

--Trae la cantidad de iteraciones por releases
-----------------------------------------
      LEFT  JOIN(SELECT 
      re.rel_id, COUNT (b.BG_BUG_ID) as Cant_def, Cant_iteraciones, (Cant_iteraciones/COUNT (b.BG_BUG_ID)) prom_iteraciones
      FROM  '||x.db_name||'.BUG b
      JOIN '||x.db_name||'.RELEASES re ON b.BG_TARGET_REL = re.REL_ID      
      JOIN '||x.db_name||'.RELEASE_CYCLES ON BG_TARGET_RCYC = RCYC_ID

              LEFT  JOIN (SELECT 
              rel_id, COUNT (AP_NEW_VALUE) as Cant_iteraciones
              FROM  '||x.db_name||'.BUG b
              LEFT JOIN '||x.db_name||'.RELEASES  ON b.BG_TARGET_REL = REL_ID
              LEFT JOIN  '||x.db_name||'.AUDIT_LOG  ON AU_ENTITY_ID = BG_BUG_ID
              LEFT JOIN '||x.db_name||'.AUDIT_PROPERTIES  ON AP_ACTION_ID = AU_ACTION_ID
              LEFT JOIN '||x.db_name||'.RELEASE_CYCLES ON BG_TARGET_RCYC = RCYC_ID
              WHERE AU_ENTITY_TYPE = ''BUG''
              AND AP_PROPERTY_NAME like ''%Estado%''
              AND AP_NEW_VALUE  = ''Ready to Test''
              AND RCYC_NAME NOT LIKE ''%IDC%''
              group by rel_id) cant_ite on cant_ite.rel_id = re.rel_id  
  
              WHERE 1=1 
              AND RCYC_NAME NOT LIKE ''%IDC%''
              AND b.BG_STATUS NOT IN (''Canceled'',''N/A'')
              group by re.rel_id, Cant_iteraciones) defec on defec.rel_id = rel.rel_id      
  
      --Trae la cantidad de defectos 
      LEFT  JOIN(
      SELECT 
      rel_id, COUNT(BG_BUG_ID) as total_defectos
      FROM  '||x.db_name||'.BUG b
      JOIN '||x.db_name||'.RELEASES ON b.BG_TARGET_REL = REL_ID      
      JOIN '||x.db_name||'.RELEASE_CYCLES ON BG_TARGET_RCYC = RCYC_ID
      WHERE 1=1
      AND RCYC_NAME NOT LIKE ''%IDC%''
      AND b.BG_STATUS NOT IN (''Canceled'',''N/A'')
      --AND RCYC_NAME NOT LIKE ''%IDC%'' 
      group by rel_id) defec2 on defec2.rel_id = rel.rel_id
-----------------------------------------

--Trae la cantidad de defectos abiertos
      LEFT  JOIN(
      SELECT 
      rel_id, RCYC_ID, COUNT(BG_BUG_ID) as total_defectos2
      FROM '||x.db_name||'.BUG b
      JOIN '||x.db_name||'.RELEASES ON b.BG_TARGET_REL = REL_ID      
      JOIN '||x.db_name||'.RELEASE_CYCLES ON BG_TARGET_RCYC = RCYC_ID
      WHERE 1=1
      AND b.BG_STATUS NOT IN (''Canceled'',''Closed'',''N/A'')
      AND RCYC_NAME NOT LIKE ''%IDC%'' group by rel_id, RCYC_ID) defec3 on defec3.rel_id = rel.rel_id and RCYC.RCYC_ID = defec3.RCYC_ID
-----------------------------------------

--Trae la cantidad de defectos severidad 1-Low 2-Medium 3-High "4-Very High" 5-Urgent
      LEFT  JOIN(
            SELECT 
            rel_id, RCYC_ID, COUNT(BG_BUG_ID) as total_def_low
            FROM '||x.db_name||'.BUG b
            JOIN '||x.db_name||'.RELEASES ON b.BG_TARGET_REL = REL_ID      
            JOIN '||x.db_name||'.RELEASE_CYCLES ON BG_TARGET_RCYC = RCYC_ID
            WHERE 1=1
            AND b.BG_SEVERITY IN (''1-Low'')
            AND RCYC_NAME NOT LIKE ''%IDC%''
            --AND b.BG_USER_01 NOT IN (''Canceled'',''N/A'')
            AND b.BG_STATUS NOT IN (''Canceled'',''Closed'',''N/A'')
      group by rel_id, RCYC_ID) defec4 on defec4.rel_id = rel.rel_id and RCYC.RCYC_ID = defec4.RCYC_ID
-----------------------------------------

--Trae la cantidad de defectos severidad 1-Low 2-Medium 3-High "4-Very High" 5-Urgent
      LEFT  JOIN(
            SELECT 
            rel_id, RCYC_ID, COUNT(BG_BUG_ID) as total_def_Medium
            FROM '||x.db_name||'.BUG b
            JOIN '||x.db_name||'.RELEASES ON b.BG_TARGET_REL = REL_ID      
            JOIN '||x.db_name||'.RELEASE_CYCLES ON BG_TARGET_RCYC = RCYC_ID
            WHERE 1=1
            AND b.BG_SEVERITY IN (''2-Medium'')
            AND RCYC_NAME NOT LIKE ''%IDC%'' 
            --AND b.BG_USER_01 NOT IN (''Canceled'',''N/A'')
            AND b.BG_STATUS NOT IN (''Canceled'',''Closed'',''N/A'')
      group by rel_id, RCYC_ID) defec5 on defec5.rel_id = rel.rel_id and RCYC.RCYC_ID = defec5.RCYC_ID
-----------------------------------------

--Trae la cantidad de defectos severidad 1-Low 2-Medium 3-High "4-Very High" 5-Urgent
      LEFT  JOIN(
            SELECT 
            rel_id, RCYC_ID, COUNT(BG_BUG_ID) as total_def_High
            FROM '||x.db_name||'.BUG b
            JOIN '||x.db_name||'.RELEASES ON b.BG_TARGET_REL = REL_ID      
            JOIN '||x.db_name||'.RELEASE_CYCLES ON BG_TARGET_RCYC = RCYC_ID
            WHERE 1=1
            AND b.BG_SEVERITY IN (''3-High'')
            AND RCYC_NAME NOT LIKE ''%IDC%'' 
            --AND b.BG_USER_01 NOT IN (''Canceled'',''N/A'')
            AND b.BG_STATUS NOT IN (''Canceled'',''Closed'',''N/A'')
      group by rel_id, RCYC_ID) defec6 on defec6.rel_id = rel.rel_id and RCYC.RCYC_ID = defec6.RCYC_ID
-----------------------------------------

--Trae la cantidad de defectos severidad 1-Low 2-Medium 3-High "4-Very High" 5-Urgent
      LEFT  JOIN(
            SELECT 
            rel_id, RCYC_ID, COUNT(BG_BUG_ID) as total_def_Very_High
            FROM '||x.db_name||'.BUG b
            JOIN '||x.db_name||'.RELEASES ON b.BG_TARGET_REL = REL_ID      
            JOIN '||x.db_name||'.RELEASE_CYCLES ON BG_TARGET_RCYC = RCYC_ID
            WHERE 1=1
            AND b.BG_SEVERITY IN (''4-Very High'')
            AND RCYC_NAME NOT LIKE ''%IDC%''
            --AND b.BG_USER_01 NOT IN (''Canceled'',''N/A'')
            AND b.BG_STATUS NOT IN (''Canceled'',''Closed'',''N/A'')
      group by rel_id, RCYC_ID) defec7 on defec7.rel_id = rel.rel_id and RCYC.RCYC_ID = defec7.RCYC_ID
-----------------------------------------

--Trae la cantidad de defectos severidad 1-Low 2-Medium 3-High "4-Very High" 5-Urgent
      LEFT  JOIN(
            SELECT 
            rel_id, RCYC_ID, COUNT(BG_BUG_ID) as total_def_Urgent
            FROM '||x.db_name||'.BUG b
            JOIN '||x.db_name||'.RELEASES ON b.BG_TARGET_REL = REL_ID      
            JOIN '||x.db_name||'.RELEASE_CYCLES ON BG_TARGET_RCYC = RCYC_ID
            WHERE 1=1
            AND b.BG_SEVERITY IN (''5-Urgent'')
            AND RCYC_NAME NOT LIKE ''%IDC%'' 
            --AND b.BG_USER_01 NOT IN (''Canceled'',''N/A'')
            AND b.BG_STATUS NOT IN (''Canceled'',''Closed'',''N/A'')
      group by rel_id, RCYC_ID) defec8 on defec8.rel_id = rel.rel_id and RCYC.RCYC_ID = defec8.RCYC_ID
-----------------------------------------


--Trae la cantidad de defectos Ambiente
            LEFT  JOIN(
            SELECT 
            rel_id, RCYC_ID, COUNT(BG_BUG_ID) as total_def_Ambiente
            FROM '||x.db_name||'.BUG b
            JOIN '||x.db_name||'.RELEASES ON b.BG_TARGET_REL = REL_ID      
            JOIN '||x.db_name||'.RELEASE_CYCLES ON BG_TARGET_RCYC = RCYC_ID
            WHERE 1=1
            AND b.BG_USER_06 IN (''Error de Ambientes Hardware'', ''Error de Ambientes Software'')
            AND RCYC_NAME NOT LIKE ''%IDC%'' 
            AND b.BG_STATUS NOT IN (''Canceled'',''N/A'')            
            group by rel_id, RCYC_ID) defec9 on defec9.rel_id = rel.rel_id and RCYC.RCYC_ID = defec9.RCYC_ID            
-----------------------------------------

--Trae la cantidad de defectos Software
            LEFT  JOIN(
            SELECT 
            rel_id, RCYC_ID, COUNT(BG_BUG_ID) as total_def_Software
            FROM '||x.db_name||'.BUG b
            JOIN '||x.db_name||'.RELEASES ON b.BG_TARGET_REL = REL_ID      
            JOIN '||x.db_name||'.RELEASE_CYCLES ON BG_TARGET_RCYC = RCYC_ID
            WHERE 1=1
            AND b.BG_USER_06 IN (''Error de Codificación - Funcional'', ''Error de Codificación - IDC'')
            AND RCYC_NAME NOT LIKE ''%IDC%''
            AND b.BG_STATUS NOT IN (''Canceled'',''N/A'')
            group by rel_id, RCYC_ID) defec10 on defec10.rel_id = rel.rel_id and RCYC.RCYC_ID = defec10.RCYC_ID            
-----------------------------------------


--Trae la cantidad de defectos Diseño
            LEFT  JOIN(
            SELECT 
            rel_id, RCYC_ID, COUNT(BG_BUG_ID) as total_def_Diseño
            FROM '||x.db_name||'.BUG b
            JOIN '||x.db_name||'.RELEASES ON b.BG_TARGET_REL = REL_ID      
            JOIN '||x.db_name||'.RELEASE_CYCLES ON BG_TARGET_RCYC = RCYC_ID
            WHERE 1=1
            AND b.BG_USER_06 IN (''Error de Análisis de Amiguedad'', ''Error de Diseño'')
            AND RCYC_NAME NOT LIKE ''%IDC%'' 
            AND b.BG_STATUS NOT IN (''Canceled'',''N/A'')
            group by rel_id, RCYC_ID) defec11 on defec11.rel_id = rel.rel_id and RCYC.RCYC_ID = defec11.RCYC_ID            
-----------------------------------------


--Trae la cantidad de defectos Eliminar
            LEFT  JOIN(
            SELECT 
            rel_id, RCYC_ID, COUNT(BG_BUG_ID) as total_def_Eliminar
            FROM '||x.db_name||'.BUG b
            JOIN '||x.db_name||'.RELEASES ON b.BG_TARGET_REL = REL_ID      
            JOIN '||x.db_name||'.RELEASE_CYCLES ON BG_TARGET_RCYC = RCYC_ID
            WHERE 1=1
            AND b.BG_USER_06 IN (''Error de Parámetros'', ''Error de Procesamiento de Interfaces'', ''Error de Pruebas'', ''Error de Requerimiento'')
            AND RCYC_NAME NOT LIKE ''%IDC%'' 
            AND b.BG_STATUS NOT IN (''Canceled'',''N/A'')
            group by rel_id, RCYC_ID) defec12 on defec12.rel_id = rel.rel_id and RCYC.RCYC_ID = defec12.RCYC_ID            
-----------------------------------------


--Trae el añejamiento
-----------------------------------------

  LEFT JOIN (SELECT RPROM.REL_ID, SUM(prom_añejamiento1)/COUNT(CANT_OK) AS prom_añejamiento 
      FROM  '||x.db_name||'.RELEASES RPROM
      LEFT JOIN '||x.db_name||'.RELEASE_FOLDERS RF ON  RF.RF_ID = RPROM.REL_PARENT_ID 

         LEFT JOIN ( 
        SELECT RA.rel_id, B.bg_bug_id, b.bg_detection_date, sysdate, b.bg_status,
        CASE WHEN BG_STATUS = ''Closed'' THEN ''OK''
        WHEN BG_STATUS NOT IN (''Closed'', ''Canceled'', ''N/A'') THEN ''OK'' ELSE ''1'' end AS CANT_OK,
         CASE WHEN BG_STATUS NOT IN (''Closed'', ''Canceled'', ''N/A'') THEN
        --((nvl( sum (DIAS_LABORABLES (bg_detection_date,sysdate))/ count (distinct b.bg_bug_id)-1,0))) else prom_añejamiento2 END  as 
        nvl (sum (DIAS_LABORABLES (bg_detection_date,sysdate)),0) else prom_añejamiento2 END  as
        prom_añejamiento1        
                    FROM '||x.db_name||'.BUG b
                    JOIN '||x.db_name||'.RELEASE_CYCLES ON BG_TARGET_RCYC = RCYC_ID
                    JOIN '||x.db_name||'.RELEASES RA  ON b.BG_TARGET_REL = RA.REL_ID
                    
                    LEFT JOIN (SELECT rel_id , BG_BUG_ID as id_BG,                                    
                                  --(nvl( sum (DIAS_LABORABLES (bg_detection_date,AU_TIME))/ count (distinct bg_bug_id)-1,0)) as prom_añejamiento2 
                                  MAX( (DIAS_LABORABLES (bg_detection_date,AU_TIME))) as prom_añejamiento2               
                                  FROM '||x.db_name||'.BUG
                                  JOIN '||x.db_name||'.AUDIT_LOG  ON AU_ENTITY_ID = BG_BUG_ID
                                  JOIN '||x.db_name||'.AUDIT_PROPERTIES  ON AP_ACTION_ID = AU_ACTION_ID
                                  JOIN '||x.db_name||'.RELEASE_CYCLES ON BG_TARGET_RCYC = RCYC_ID
                                  JOIN '||x.db_name||'.RELEASES  ON BG_TARGET_REL = REL_ID 
                                  WHERE AU_ENTITY_TYPE = ''BUG''                
                                  AND AP_NEW_VALUE  IN (''Closed'')
                                  AND AP_PROPERTY_NAME like ''%Estado%''		
                                  --and rel_id = ''1607''
                                  AND RCYC_NAME NOT LIKE ''%IDC%''
                                  group by rel_id, BG_BUG_ID) BH ON BH.id_BG =  B.BG_BUG_ID AND BH.rel_id = RA.REL_ID              
                  where 1=1
                  --and RA.rel_id = ''1607''
                  and b.bg_status not in (''Closed'', ''Canceled'')
                  AND RCYC_NAME NOT LIKE ''%IDC%''
                  group by RA.rel_id, b.bg_bug_id, b.bg_detection_date, b.bg_status, sysdate, prom_añejamiento2
                  
                  ) defproma ON defproma.rel_id = rprom.rel_id 
                  
                --AND RPROM.REL_ID = ''1607''
             AND(RF.RF_PATH not like ''AAAAAB%''  AND RF.RF_PATH not like ''AAAAAF%'' AND RF.RF_PATH not like ''AAAAAC%'' AND RF.RF_PATH not like ''AAAAAD%'' AND RF.RF_PATH not like ''AAAAAE%'')     
             group by RPROM.REL_ID ) defec13 on defec13.rel_id = rel.rel_id      
      
      
-----------------------------------------
      
--Trae el desfase de inicio      
-----------------------------------------
                LEFT  JOIN (SELECT REL1.REL_ID, 
                (CASE WHEN
                TO_DATE (REL1.REL_USER_01,''YYYY/MM/DD'') <= MIN(REL1.REL_START_DATE) THEN
                (DIAS_LABORABLES(TO_DATE (REL1.REL_USER_01,''YYYY/MM/DD''), MIN(REL1.REL_START_DATE)))-1 ELSE -(DIAS_LABORABLES(MIN(REL1.REL_START_DATE), TO_DATE (REL1.REL_USER_01,''YYYY/MM/DD'')))  END) AS desfase_rel,
                
                SUM((desfase_run_cicl)) as desfase_inicio
                FROM '||x.db_name||'.RELEASES REL1
                JOIN '||x.db_name||'.RELEASE_CYCLES RC ON REL1.REL_ID = RC.RCYC_PARENT_ID

                                LEFT  JOIN 
                                (SELECT REL_ID, RCYC_ID, 
                                --(DIAS_LABORABLES(TO_DATE (RCYC_USER_01,''YYYY/MM/DD''),MIN(RN_EXECUTION_DATE))) AS desfase_run_cicl
                                (CASE WHEN
                                TO_DATE (RCYC_USER_01,''YYYY/MM/DD'') <= MIN(RN_EXECUTION_DATE) THEN
                                (DIAS_LABORABLES(TO_DATE (RCYC_USER_01,''YYYY/MM/DD''), MIN(RN_EXECUTION_DATE))) ELSE -(DIAS_LABORABLES(MIN(RN_EXECUTION_DATE), TO_DATE (RCYC_USER_01,''YYYY/MM/DD'')))  END) AS desfase_run_cicl
                                FROM '||x.db_name||'.RUN
                                JOIN '||x.db_name||'.TESTCYCL ON TC_TESTCYCL_ID = RN_TESTCYCL_ID
                                JOIN '||x.db_name||'.RELEASE_CYCLES ON TC_ASSIGN_RCYC = RCYC_ID
                                JOIN '||x.db_name||'.CYCLE ON TC_CYCLE_ID = CY_CYCLE_ID
                                JOIN '||x.db_name||'.RELEASES on rcyc_parent_id = rel_id
                                WHERE 1=1
                                AND RCYC_NAME NOT LIKE ''%IDC%''
                                --AND REL_ID = ''1597''
                                GROUP BY REL_ID, RCYC_ID, REL_USER_01, REL_START_DATE, RCYC_USER_01) Des_ini ON REL1.REL_ID = Des_ini.REL_ID and 
                  Des_ini.RCYC_ID = RC.RCYC_ID
                  WHERE 1=1
                  AND RC.RCYC_NAME NOT LIKE ''%IDC%''
                  --AND REL1.REL_ID = ''1597''
                  GROUP BY REL1.REL_ID, REL1.REL_USER_01, REL1.REL_START_DATE) des_ini1 on rel.rel_id = des_ini1.rel_id

----------------------------------------- 


-------- CANTIDAD ESTADO REQUERIMIENTO PARA VALIDACION DE CANTIDAD DE INSTANCIAS 

LEFT JOIN (
            SELECT RE1.REL_ID, REL_NAME, COUNT(DISTINCT(RQ_USER_02)) CANT_ESTADO
            FROM '||x.db_name||'.RELEASES RE1
            INNER JOIN '||x.db_name||'.REQ_RELEASES RQR ON RQR.RQRL_RELEASE_ID=RE1.REL_ID
            INNER JOIN '||x.db_name||'.REQ RQ ON RQ.RQ_REQ_ID=RQR.RQRL_REQ_ID
            WHERE 1=1
            --AND RE1.REL_ID = ''1432''
            AND RQ_USER_02 not in (''En Análisis'', ''En Producción'')
            --AND RQ_TYPE_ID NOT IN (105, 106)
            AND RQ.RQ_TYPE_ID IN (3)
            GROUP BY RE1.REL_ID, REL_NAME
) CANT_EST ON CANT_EST.REL_ID = REL.REL_ID


-----------------------------------------------------------

WHERE 1=1

AND RCYC.RCYC_NAME NOT LIKE ''%IDC%''
AND(RF.RF_PATH not like ''AAAAAC%'' AND RQ.RQ_REQ_PATH not like ''AAAAAB%'')
--AND RQ.RQ_TYPE_ID NOT IN (105, 106)
AND RQ.RQ_TYPE_ID IN (3)
AND RQ.RQ_USER_02 not in (''En Análisis'')
--AND REL.REL_ID = ''1605''


group by 
REL.REL_ID ,
RCYC.RCYC_NAME ,
REL.REL_USER_05    ,
REL.REL_NAME               ,  
REL_USER_01,
REL_USER_03,
RCYC_USER_01,
RCYC_USER_02,
REL.REL_START_DATE         ,
REL.REL_END_DATE           ,
RCYC.RCYC_ID                , 
RCYC.RCYC_NAME              ,
RCYC.RCYC_START_DATE        ,
RCYC.RCYC_END_DATE          ,
TC.TC_STATUS  ,
defec.Cant_iteraciones,
defec.Cant_def,
defec.prom_iteraciones,
defec2.total_defectos,
defec13.prom_añejamiento,
desfase_inicio,
--desfase_rel,
RQ.RQ_USER_02,
TC.TC_EXEC_DATE,
REL.REL_USER_02,
CANT_ESTADO,
total_defectos2,
total_def_low,
total_def_Medium,
total_def_High,
total_def_Very_High,
total_def_Urgent,
total_def_Ambiente,
0,
total_def_Eliminar,
total_def_Diseño,
total_def_Software


)  tab_a
-----------------------------------------
left join ( SELECT
REL.REL_ID ||'' '' || REL.REL_NAME  PK_concatenacion,
count(TC.TC_TESTCYCL_ID)           "Cantidad Exitoso"

FROM  '||x.db_name||'.TESTCYCL TC

LEFT JOIN '||x.db_name||'.CYCLE CY ON CY.CY_CYCLE_ID = TC.TC_CYCLE_ID
LEFT JOIN '||x.db_name||'.RELEASE_CYCLES RCYC ON RCYC.RCYC_ID = CY.CY_ASSIGN_RCYC
LEFT JOIN '||x.db_name||'.RELEASES REL ON REL.REL_ID = RCYC.RCYC_PARENT_ID

WHERE 1=1
AND RCYC.RCYC_NAME NOT LIKE ''%IDC%''
AND TC.TC_STATUS = ''Passed''
group by REL.REL_ID ||'' '' || REL.REL_NAME) tab_b on tab_b.PK_concatenacion=tab_a.FK_concatenacion
left join (
SELECT
R.REL_ID ||'' '' || R.REL_NAME ||'' '' || RCYC_NAME PK_concatenacion3,

RCYC_START_DATE, RCYC_ID, rcyc_name, MAX(RN_EXECUTION_DATE), TABLA.fecha_ultima_eje
FROM '||x.db_name||'.RUN
JOIN '||x.db_name||'.TESTCYCL ON TC_TESTCYCL_ID = RN_TESTCYCL_ID
JOIN '||x.db_name||'.RELEASE_CYCLES ON TC_ASSIGN_RCYC = RCYC_ID
JOIN '||x.db_name||'.CYCLE ON TC_CYCLE_ID = CY_CYCLE_ID
JOIN '||x.db_name||'.RELEASES R on rcyc_parent_id = R.rel_id

       LEFT JOIN (SELECT REL_ID, REL_NAME, MAX(RN_EXECUTION_DATE) as fecha_ultima_eje
       FROM '||x.db_name||'.RUN
       JOIN '||x.db_name||'.TESTCYCL ON TC_TESTCYCL_ID = RN_TESTCYCL_ID
       JOIN '||x.db_name||'.RELEASE_CYCLES ON TC_ASSIGN_RCYC = RCYC_ID
       JOIN '||x.db_name||'.CYCLE ON TC_CYCLE_ID = CY_CYCLE_ID
       JOIN '||x.db_name||'.RELEASES on rcyc_parent_id = rel_id
       WHERE 1=1
       AND RCYC_NAME NOT LIKE ''%IDC%''
       GROUP BY REL_ID, REL_NAME
       ORDER BY REL_ID)  TABLA ON TABLA.REL_ID = R.REL_ID  

WHERE 1=1
AND RCYC_NAME NOT LIKE ''%IDC%''
GROUP BY R.REL_ID, R.REL_NAME, RCYC_ID, RCYC_START_DATE, RCYC_NAME, TABLA.fecha_ultima_eje
ORDER BY R.REL_ID

) tab_c on tab_a.FK_concatenacion3=tab_c.PK_concatenacion3

';

end loop;

execute immediate  'insert into ALM_REPORT.DATA_360 
select "PROYECTO",	"DOMINIO",	"FK_CONCATENACION",	"FK_CONCATENACION2",	"FK_CONCATENACION3",	"Id Release",	"JPQA",	"Nombre Release",	"Fecha Inicio Plan Release",	"Fecha Fin Plan Release",	"Avance en días",	"ACTUAL",	"Total RPlan Rel",	"Fecha Inicio Re-Plan Release",	"Fecha Fin Re-Plan Release",	"Dias rel plan",	"Defase Inicio Rel",	"Id Ciclo",	"Nombre Ciclo",	"Fecha Inicio Plan Ciclo",	"Fecha Fin Plan Ciclo",	"Fecha Inicio Re-Plan Ciclo",	"Fecha Fin Re-Plan Ciclo",	"Estado Ejecución",	"CANT_INSTANCIA",	"CANT_ITERACIONES",	"CANT_DEF",	"PROM_ITERACIONES",	"TOTAL_DEFECTOS",	"PROM_AÑEJAMIENTO",	"DESFASE_INICIO",	"ESTADO_REQUERIMIENTO",	"FECHA_EJECUCION",	"JEFE_AREA_DESARROLLO",	"TOTAL_DEFECTOS2",	"TOT_LOW",	"TOT_MEDIUM",	"TOT_HIGH",	"TOT_VHIGH",	"TOT_URGENT",	"TOT_AMBIENTE",	"TOT_EJE_AUTO",	"TOT_ELIMINAR",	"TOT_DISENO",	"TOT_SOFTWARE",	"SERVIDOR",	"PK_CONCATENACION",	"Cantidad Exitoso",	"PK_CONCATENACION3",	"RCYC_START_DATE",	"RCYC_ID",	"RCYC_NAME",	"MAX(RN_EXECUTION_DATE)",	"FECHA_ULTIMA_EJE" from DATA_360@SERVER_BCH
';

end;

/
