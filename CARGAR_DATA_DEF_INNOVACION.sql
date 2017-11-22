--------------------------------------------------------
--  DDL for Procedure CARGAR_DATA_DEF_INNOVACION
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ALM_REPORT"."CARGAR_DATA_DEF_INNOVACION" AS 
BEGIN
execute immediate 'TRUNCATE TABLE ALM_REPORT.DATA_DEF_INNOVACION';

for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME from alm_siteadmin_db_12.projects where DB_NAME = 'qa_qa_db0') loop
execute immediate  'insert into ALM_REPORT.DATA_DEF_INNOVACION 

SELECT DISTINCT
REL.REL_ID        AS ID_RELEASES,
REL.REL_USER_05   AS JPQA,
REL.REL_NAME      AS NOMBRE_RELEASES,
BG.BG_BUG_ID      AS ID_DEFECTO,
BG.BG_SEVERITY    AS SEVERIDAD,
BG.BG_STATUS      AS ESTADO_DEFECTO,
prom_añejamiento  AS PROM_AÑEJAMIENTO,
Cant_iteraciones  AS CANT_ITERACIONES,
prom_iteraciones  AS PROMEDIO_ITERACIONES,
--SUM(DISTINCT(TOTAL_DIAS))   AS TOTAL_DIAS_DESARROLLO,

''SERVIDOR TSOFT''    AS SERVIDOR
FROM  '||x.db_name||'.BUG BG
LEFT JOIN '||x.db_name||'.RELEASES REL ON REL.REL_ID = BG.BG_TARGET_REL
LEFT JOIN '||x.db_name||'.RELEASE_CYCLES RCYC ON RCYC.RCYC_PARENT_ID = REL.REL_ID
LEFT JOIN '||x.db_name||'.RELEASE_FOLDERS RF ON  RF.RF_ID = REL.REL_PARENT_ID 
INNER JOIN '||x.db_name||'.REQ_RELEASES RQR ON RQR.RQRL_RELEASE_ID=REL.REL_ID
INNER JOIN '||x.db_name||'.REQ RQ ON RQ.RQ_REQ_ID=RQR.RQRL_REQ_ID

      --TRAE AÑEJAMIENTO
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
                                  --and rel_id = ''''1607''''
                                  AND RCYC_NAME NOT LIKE ''%IDC%''
                                  group by rel_id, BG_BUG_ID) BH ON BH.id_BG =  B.BG_BUG_ID AND BH.rel_id = RA.REL_ID              
                  where 1=1
                  --and RA.rel_id = ''''1607''''
                  and b.bg_status not in (''Closed'', ''Canceled'')
                  AND RCYC_NAME NOT LIKE ''%IDC%''
                  group by RA.rel_id, b.bg_bug_id, b.bg_detection_date, b.bg_status, sysdate, prom_añejamiento2
                  
                  ) defproma ON defproma.rel_id = rprom.rel_id 
                  
                --AND RPROM.REL_ID = ''''1607''''
             --AND(RF_PATH like ''AAAAAAAAA%'' Or RF_PATH like ''AAAAAAAAF%'' Or RF_PATH like ''AAAAAAAAR%'') 
             --AND RQ.RQ_USER_02 not in (''Cerrado QA'', ''Cancelado'', ''Cerrado'', ''Cerrado sin IDC'', ''Cerrado con Observaciones'', ''Con Cobertura'', ''Con Defecto'', ''En Análisis'', ''En Diseño'', ''No Revisado'', ''Rechazado'')
             --AND RQ.RQ_TYPE_ID NOT IN (105, 106)
             group by RPROM.REL_ID ) defec1 on defec1.rel_id = rel.rel_id    
        -----------------------------------------------------------
        
        --TRAE ITERACIONES
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
              group by re.rel_id, Cant_iteraciones) defec2 on defec2.rel_id = rel.rel_id 
      ------------------------------------------------------------------                             
WHERE 1=1
AND RCYC.RCYC_NAME NOT LIKE ''%IDC%''
--AND(RF.RF_PATH like ''AAAAAAAAA%'') 
--AND(RF_PATH like ''AAAAAAAAA%'' Or RF_PATH like ''AAAAAAAAF%'' Or RF_PATH like ''AAAAAAAAR%'')
AND(RF_PATH like ''AAAAADAAB%'' Or RF_PATH like ''AAAAADAAD%'' Or RF_PATH like ''AAAAAAAAR%'')
AND RQ.RQ_USER_02 not in (''Cerrado QA'', ''Cancelado'', ''Cerrado'', ''Cerrado sin IDC'', ''Cerrado con Observaciones'', ''Con Cobertura'', ''Con Defecto'', ''En Análisis'', ''En Diseño'', ''No Revisado'', ''Rechazado'')
AND RQ.RQ_TYPE_ID NOT IN (105, 106)
AND RCYC.RCYC_NAME NOT LIKE ''%IDC%''
--AND REL.REL_ID = ''1696''
group by 
REL.REL_ID,                
REL.REL_USER_05,           
REL.REL_NAME,
BG.BG_SEVERITY,
BG.BG_BUG_ID,
BG.BG_STATUS,
prom_añejamiento,
Cant_iteraciones,
prom_iteraciones

';
end loop;

execute immediate  'insert into ALM_REPORT.DATA_DEF_INNOVACION 
select * from DATA_DEF_INNOVACION@SERVER_BCH
';


end;

/
