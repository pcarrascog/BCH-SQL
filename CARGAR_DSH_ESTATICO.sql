--------------------------------------------------------
--  DDL for Procedure CARGAR_DSH_ESTATICO
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ALM_REPORT"."CARGAR_DSH_ESTATICO" AS 
BEGIN

 execute immediate 'TRUNCATE TABLE ALM_REPORT.DATA_DSH_ESTATICO';

for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME from alm_siteadmin_db_12.projects where DB_NAME = 'bch_qa_certificación_bch_qa_d') loop
execute immediate  'insert into ALM_REPORT.DATA_DSH_ESTATICO  

--BCH_QA LISTO

SELECT RETP.REL_ID AS REL_ID, RETP.REL_NAME,
REQTP.RQ_REQ_ID AS REQ_ID, RQTP.TPR_NAME AS TIPO_PROYECTO, REQTP.RQ_REQ_NAME AS REQPADRE, REQTP.RQ_TYPE_ID AS ID_TIPO_REQ, REQTP.RQ_USER_04 AS ESTADO_REQP, 
--TIPO_REQ_CICLO, REQCICLO, REQCTCI, NVL(TOTAL_CASOS_COBREQCI,0) AS TOTAL_CASOS_COBREQCI,
''-'' AS TIPO_SPRINT, ''-'' AS NOMBRE_SPRINT, ''-'' AS ESTADO_COB_SPRINT, 0 AS TOTAL_CASOS_COB_SP, 
TIPOREQFUN, REQFUN, REQCTFUN, NVL(TOTAL_CASOS_COBFUN,0) AS TOTAL_CASOS_COBFUN, 
TIPOREQPRUEBA, ID_REQTCR, REQTCR, REQCTPR, NVL(SUM_TOTALCASOSCOB,0) AS SUM_TOTALCASOSCOB,
'''||x.DOMAIN_NAME||'''as dominio,
'''||x.PROJECT_NAME||''' as Proyecto, 
RETP.REL_USER_TEMPLATE_01, RETP.REL_USER_TEMPLATE_02, --REQ_ID_TC,
NVL(SISTEMA, ''Sin Cobertura''),
NVL(MODULO, ''Sin Cobertura''),
ESTADO_CASO,
ID_REQ_FUN,
RQ_USER_33 AS COORDINADOR,
''SERVIDOR TSOFT'' as SERVIDOR

FROM '||x.db_name||'.RELEASES RETP
JOIN '||x.db_name||'.REQ_RELEASES ON RQRL_RELEASE_ID = RETP.REL_ID
JOIN '||x.db_name||'.REQ REQTP ON REQTP.RQ_REQ_ID = RQRL_REQ_ID
JOIN '||x.db_name||'.REQ_TYPE RQTP ON TPR_TYPE_ID = REQTP.RQ_TYPE_ID
LEFT JOIN '||x.db_name||'.RELEASE_FOLDERS RFTP ON  RFTP.RF_ID = RETP.REL_PARENT_ID

     
     LEFT JOIN (    





                        SELECT RETF.REL_ID, REQF.RQ_REQ_ID AS ID_REQ_FUN, RQ_REQ_STATUS AS REQCTFUN, RTF.TPR_NAME AS TIPOREQFUN, REQF.RQ_REQ_NAME AS REQFUN,  REQF.RQ_TYPE_ID, REQF.RQ_USER_04 AS ESTADO_REQP, REQF.RQ_FATHER_ID,  
                        ID_REQTCR, REQTCR, REQCTPR, TIPOREQPRUEBA, CASE WHEN (RQ_REQ_STATUS <> ''Not Covered'')  THEN TS_USER_01 ELSE ''Sin Cobertura''  END  AS SISTEMA,
                        CASE WHEN (RQ_REQ_STATUS <> ''Not Covered'')  THEN TS_USER_05 ELSE ''Sin Cobertura''  END  AS MODULO,
                        TS_STATUS AS ESTADO_CASO,
                        (TOTAL_CASOS_COB) AS SUM_TOTALCASOSCOB, COUNT(DISTINCT(TS_TEST_ID)) AS TOTAL_CASOS_COBFUN
                        FROM '||x.db_name||'.RELEASES RETF
                        JOIN '||x.db_name||'.REQ_RELEASES ON RQRL_RELEASE_ID = RETF.REL_ID
                        JOIN '||x.db_name||'.REQ REQF ON REQF.RQ_REQ_ID = RQRL_REQ_ID
                        JOIN '||x.db_name||'.REQ_TYPE RTF ON TPR_TYPE_ID = REQF.RQ_TYPE_ID
                        LEFT JOIN '||x.db_name||'.REQ_COVER ON RC_REQ_ID = RQ_REQ_ID
                        LEFT JOIN '||x.db_name||'.TEST ON RC_ENTITY_ID = TS_TEST_ID
                        LEFT JOIN '||x.db_name||'.RELEASE_FOLDERS RF ON  RF.RF_ID = RETF.REL_PARENT_ID
                                                
                        LEFT JOIN (
                        
                                  SELECT REL_ID, RQ_REQ_ID AS ID_REQTCR, RQ_REQ_NAME AS REQTCR, RQ_TYPE_ID, RQ_USER_04, RQ_REQ_STATUS AS REQCTPR, RQ_FATHER_ID, 
                                  TPR_NAME AS TIPOREQPRUEBA, COUNT(DISTINCT(TS_TEST_ID)) AS TOTAL_CASOS_COB
                                  FROM '||x.db_name||'.RELEASES
                                  JOIN '||x.db_name||'.REQ_RELEASES ON RQRL_RELEASE_ID = REL_ID
                                  JOIN '||x.db_name||'.REQ ON RQ_REQ_ID = RQRL_REQ_ID
                                  JOIN '||x.db_name||'.REQ_TYPE ON TPR_TYPE_ID = RQ_TYPE_ID
                                  LEFT JOIN '||x.db_name||'.REQ_COVER ON RC_REQ_ID = RQ_REQ_ID
                                  LEFT JOIN '||x.db_name||'.TEST ON RC_ENTITY_ID = TS_TEST_ID
                                  JOIN '||x.db_name||'.RELEASE_FOLDERS RF ON  RF.RF_ID = REL_PARENT_ID
                                  WHERE 1=1
                                  AND TPR_TYPE_ID IN (''115'', ''106'', ''109'', ''105'')                                               
                                  AND(RF.RF_PATH not like ''AAAAAD%''  AND RF.RF_PATH not like ''AAAAADAAC%'' AND RF.RF_PATH not like ''AAAAADAAB%'' AND RF.RF_PATH not like ''AAAAAG%'' AND RQ_REQ_PATH not like ''AAAAAC%'')
                                  --AND REL_ID = 1851
                                  GROUP BY REL_ID, 
                                  RQ_REQ_ID, RQ_REQ_NAME, RQ_TYPE_ID, RQ_USER_04, RQ_REQ_STATUS, RQ_FATHER_ID, TPR_NAME) REQTCR ON REQTCR.REL_ID = RETF.REL_ID AND REQTCR.RQ_FATHER_ID = REQF.RQ_REQ_ID
                                  
                        WHERE 1=1
                        AND REQF.RQ_TYPE_ID IN (''3'')
                        AND(RF.RF_PATH not like ''AAAAAD%''  AND RF.RF_PATH not like ''AAAAADAAC%'' AND RF.RF_PATH not like ''AAAAADAAB%'' AND RF.RF_PATH not like ''AAAAAG%'' AND RQ_REQ_PATH not like ''AAAAAC%'')
                        --AND RETF.REL_ID = 1851
                        GROUP BY RETF.REL_ID, REQF.RQ_REQ_ID, RTF.TPR_NAME, REQF.RQ_REQ_NAME,  REQF.RQ_TYPE_ID, REQF.RQ_USER_04, REQF.RQ_FATHER_ID, RQ_REQ_STATUS,
                        ID_REQTCR, REQTCR, REQCTPR, TIPOREQPRUEBA, TOTAL_CASOS_COB, TS_USER_01,TS_USER_05, TS_STATUS         
                        
                         ) SUBREQTC ON SUBREQTC.REL_ID = RETP.REL_ID AND SUBREQTC.RQ_FATHER_ID = REQTP.RQ_REQ_ID

WHERE 1=1
--AND RETP.REL_ID = 1851
AND REQTP.RQ_TYPE_ID IN (''117'',''119'', ''107'', ''116'')
AND REQTP.RQ_USER_04 in (''Creado'', ''Estática QA'', ''Pendiente Dinámica'', ''Pruebas QA'', ''Suspendido'',''Ingresado'',''Fase Estática'',''Ambientación'',''Fase Dinámica'',''Pruebas UAT'')
AND(RFTP.RF_PATH not like ''AAAAAD%''  AND RFTP.RF_PATH not like ''AAAAADAAC%'' AND RFTP.RF_PATH not like ''AAAAADAAB%'' AND RFTP.RF_PATH not like ''AAAAAG%'' AND REQTP.RQ_REQ_PATH not like ''AAAAAC%'')
                          
GROUP BY 
RETP.REL_ID, RETP.REL_NAME,
REQTP.RQ_REQ_ID, REQTP.RQ_REQ_NAME, REQTP.RQ_TYPE_ID, REQTP.RQ_USER_04,
RQTP.TPR_NAME,
--REQCICLO, TIPO_REQ_CICLO, TOTAL_CASOS_COBREQCI, REQCTCI, REQ_ID_TC
''-'', 0,
TIPOREQFUN, REQFUN, REQCTFUN, TIPOREQPRUEBA, ID_REQTCR, REQTCR, REQCTPR, SUM_TOTALCASOSCOB, TOTAL_CASOS_COBFUN, 
RETP.REL_USER_TEMPLATE_01, RETP.REL_USER_TEMPLATE_02, SISTEMA, MODULO, ESTADO_CASO, ID_REQ_FUN, RQ_USER_33
                        

';

end loop;


for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME  from alm_siteadmin_db_12.projects where DB_NAME = 'qa_qa_db0') loop
execute immediate  'insert into ALM_REPORT.DATA_DSH_ESTATICO


              SELECT RETSP.REL_ID AS REL_ID, RETSP.REL_NAME,
              REQTSP.RQ_REQ_ID AS REQ_ID_TS, ''-'' AS TIPO_PROYECTO, ''-'' AS NOMBRE_REQ_PADRE, 0 AS ID_TIPO_REQ, ''-'' AS ESTADO_REQ_PADRE,
              RQTSP.TPR_NAME AS TIPO_REQ_SPRINT, REQTSP.RQ_REQ_NAME AS REQSPRINT, RQ_REQ_STATUS AS REQCTSP, COUNT(DISTINCT(TS_TEST_ID)) AS TOTAL_CASOS_COBREQSP,  
              TIPOREQFUN, REQFUN, REQCTFUN, NVL(TOTAL_CASOS_COBFUN,0) AS TOTAL_CASOS_COBFUN,
              ''-'' AS TIPO_REQ_PRUEBA, 0 AS ID_REQ_PRUEBA, ''-'' AS NOMBRE_REQ_PRUEBA, ''-'' AS COB_REQ_PRUEBA, 0 AS SUM_TOT_CASOS,
              '''||x.DOMAIN_NAME||'''as dominio,
              '''||x.PROJECT_NAME||''' as Proyecto,
              RETSP.REL_USER_05, RETSP.REL_USER_02,
              SISTEMA, MODULO, ESTADO_CASO, ID_REQ_FUN,          
              RQ_USER_09 AS COORDINADOR,
              ''SERVIDOR TSOFT'' as SERVIDOR
                                     
              FROM '||x.db_name||'.RELEASES RETSP
              JOIN '||x.db_name||'.REQ_RELEASES ON RQRL_RELEASE_ID = RETSP.REL_ID
              JOIN '||x.db_name||'.REQ REQTSP ON REQTSP.RQ_REQ_ID = RQRL_REQ_ID
              JOIN '||x.db_name||'.REQ_TYPE RQTSP ON TPR_TYPE_ID = REQTSP.RQ_TYPE_ID
              LEFT JOIN '||x.db_name||'.REQ_COVER ON RC_REQ_ID = RQ_REQ_ID
              LEFT JOIN '||x.db_name||'.TEST ON RC_ENTITY_ID = TS_TEST_ID
              LEFT JOIN '||x.db_name||'.RELEASE_FOLDERS RFTC ON  RFTC.RF_ID = RETSP.REL_PARENT_ID  
                                                      
                                                      LEFT  JOIN (                                         
                                                      
                                                      SELECT RETF.REL_ID, REQF.RQ_REQ_ID AS ID_REQ_FUN, RQ_REQ_STATUS AS REQCTFUN, RTF.TPR_NAME AS TIPOREQFUN, REQF.RQ_REQ_NAME AS REQFUN,  REQF.RQ_TYPE_ID, REQF.RQ_USER_04 AS ESTADO_REQP, REQF.RQ_FATHER_ID,   
                                                      CASE WHEN (RQ_REQ_STATUS <> ''Not Covered'')  THEN TS_USER_05 ELSE ''Sin Cobertura''  END  AS SISTEMA,
                                                      CASE WHEN (RQ_REQ_STATUS <> ''Not Covered'')  THEN TS_USER_02 ELSE ''Sin Cobertura''  END  AS MODULO,
                                                      TS_STATUS AS ESTADO_CASO,
                                                      COUNT(DISTINCT(TS_TEST_ID)) AS TOTAL_CASOS_COBFUN
                                                      FROM '||x.db_name||'.RELEASES RETF
                                                      JOIN '||x.db_name||'.REQ_RELEASES ON RQRL_RELEASE_ID = RETF.REL_ID
                                                      JOIN '||x.db_name||'.REQ REQF ON REQF.RQ_REQ_ID = RQRL_REQ_ID
                                                      JOIN '||x.db_name||'.REQ_TYPE RTF ON TPR_TYPE_ID = REQF.RQ_TYPE_ID
                                                      LEFT JOIN '||x.db_name||'.REQ_COVER ON RC_REQ_ID = RQ_REQ_ID
                                                      LEFT JOIN '||x.db_name||'.TEST ON RC_ENTITY_ID = TS_TEST_ID
                                                      LEFT JOIN '||x.db_name||'.RELEASE_FOLDERS RF ON  RF.RF_ID = RETF.REL_PARENT_ID 
                                                      WHERE 1=1
                                                      AND REQF.RQ_TYPE_ID IN (''3'', ''114'', ''115'')
                                                      --AND REL_ID = ''1714''
                                                      AND(RF.RF_PATH not like ''AAAAAC%'')
                                                      GROUP BY RETF.REL_ID, REQF.RQ_REQ_ID, RTF.TPR_NAME, REQF.RQ_REQ_NAME,  REQF.RQ_TYPE_ID, REQF.RQ_USER_04, REQF.RQ_FATHER_ID, RQ_REQ_STATUS, TS_USER_05, TS_USER_02, TS_STATUS
                                                      
                                                      ) SUBREQ ON SUBREQ.REL_ID = RETSP.REL_ID AND SUBREQ.RQ_FATHER_ID = REQTSP.RQ_REQ_ID 
              WHERE 1=1                          
              --AND RETSP.REL_ID = ''1714''
              AND REQTSP.RQ_TYPE_ID IN (''111'')                          
              AND(RFTC.RF_PATH not like ''AAAAAC%'')                        
              GROUP BY RETSP.REL_ID, RETSP.REL_NAME,
              REQTSP.RQ_REQ_ID, ''-'', 0,
              RQTSP.TPR_NAME, REQTSP.RQ_REQ_NAME, RQ_REQ_STATUS, 
              TIPOREQFUN, REQFUN, REQCTFUN, NVL(TOTAL_CASOS_COBFUN,0), 
              RETSP.REL_USER_05, RETSP.REL_USER_02,
              SISTEMA, MODULO, ESTADO_CASO, ID_REQ_FUN,          
              RQ_USER_09                                     

                   


'; end loop;
 
 
 
execute immediate  'insert into ALM_REPORT.DATA_DSH_ESTATICO 
select "ID_RELEASE",	"NOMBRE_RELEASE",	"ID_REQ_PADRE",	"TIPO_PROYECTO",	"NOMBRE_REQ_PADRE",	"ID_TIPO_REQ",	"ESTADO_REQ_PADRE",	"TIPO_REQ_SPRINT",	"NOMBRE_REQ_SPRINT",	"COB_REQ_SPRINT",	"TOT_CASOS_COB_SPRINT",	"TIPO_REQ_FUN",	"NOMBRE_REQ_FUN",	"COB_REQ_FUN",	"TOT_CASOS_COB_FUN",	"TIPO_REQ_PRUEBA",	"ID_REQ_PRUEBA",	"NOMBRE_REQ_PRUEBA",	"COB_REQ_PRUEBA",	"SUM_TOT_CASOS",	"DOMINIO",	"PROYECTO",	"JPQA",	"JEFE_AREA_DES",	"SISTEMA",	"MODULO",	"ESTADO_CASO",	"ID_REQ_FUN",	"COORDINADOR",	"SERVIDOR" from DATA_DSH_ESTATICO@SERVER_BCH
';
 
 
END;

/
