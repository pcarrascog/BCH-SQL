--------------------------------------------------------
--  DDL for Procedure cargarConteoTest
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ALM_REPORT"."cargarConteoTest" AS
BEGIN
execute immediate 'TRUNCATE TABLE ALM_REPORT.CONTEO_TEST';

for x in (select DB_NAME, PROJECT_NAME, DESCRIPTION from alm_siteadmin_db_12.projects where domain_name in ('PROYECTOS') and PR_IS_ACTIVE = 'Y' ) loop
execute immediate  'insert into ALM_REPORT.CONTEO_TEST
SELECT 
DISTINCT 
esquema,
manual,
automatico,
jpqa,
CASE WHEN sum(estado) > 0 THEN ''Activo'' ELSE ''No Activo''  END as estado,
fecha,
automatico_modificados,
automatico_ejecutados,
dominio

FROM
(
SELECT
DISTINCT 
'''||x.PROJECT_NAME||''' as esquema,
COUNT(DISTINCT CASE WHEN TS_TYPE = ''MANUAL'' THEN TS_TEST_ID  END ) as manual,
COUNT(DISTINCT CASE WHEN TS_TYPE = ''QUICKTEST_TEST'' THEN TS_TEST_ID  END ) as automatico,
R.REL_USER_04 as jpqa,

(SELECT  count(DISTINCT  RQ_USER_02)
FROM  '||x.db_name||'.REQ,  '||x.db_name||'.REQ_RELEASES 
WHERE RQ_TYPE_ID = 101 AND RQRL_RELEASE_ID = R.REL_ID and RQRL_REQ_ID = RQ_REQ_ID
AND RQ_USER_02 NOT IN (''Términado QA'',''Finalizado'',''Cancelado'',''En Producción'',''Pospuesto'',''Cerrado QA'',''Traspaso a Continuidad'') )  as estado,

min(R.REL_START_DATE) as fecha,

COUNT(DISTINCT CASE WHEN TS_TYPE = ''QUICKTEST_TEST'' AND 
TO_DATE(T.TS_VTS,''yyyy-mm-dd HH24:MI:SS'')  
BETWEEN TO_DATE(''2016-01-01'',''yyyy-mm-dd'')     AND   
TO_DATE(''2016-01-31'',''yyyy-mm-dd'')
 THEN TS_TEST_ID  END ) as automatico_modificados,

COUNT(DISTINCT CASE WHEN TS_TYPE = ''QUICKTEST_TEST'' AND 
TS_EXEC_STATUS != ''No Run'' THEN TS_TEST_ID  END ) as automatico_ejecutados,

''PROYECTOS'' as dominio


FROM '||x.DB_NAME||'.RELEASES R, '||x.DB_NAME||'.TEST T
WHERE 
R.REL_NAME != ''Prueba'' AND
T.TS_CREATION_DATE >= TO_DATE(''2016-01-01'',''yyyy-mm-dd'') AND 
T.TS_CREATION_DATE <= TO_DATE(''2016-01-31'',''yyyy-mm-dd'') 

GROUP BY
R.REL_ID,
R.REL_USER_04
)
GROUP BY
esquema,
manual,
automatico,
jpqa,
fecha,
automatico_modificados,
automatico_ejecutados,
dominio


';

end loop;

for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME, DESCRIPTION from alm_siteadmin_db_12.projects WHERE DB_NAME = 'proveedores_testing_sqa_db') loop
execute immediate  'insert into ALM_REPORT.CONTEO_TEST
SELECT 
DISTINCT 
esquema,
manual,
automatico,
jpqa,
CASE WHEN sum(estado) > 0 THEN ''Activo'' ELSE ''No Activo''  END as estado,
fecha,
automatico_modificados,
automatico_ejecutados,
dominio


FROM
(
SELECT
DISTINCT 
'''||x.PROJECT_NAME||''' as esquema,
COUNT(DISTINCT CASE WHEN TS_TYPE = ''MANUAL'' THEN TS_TEST_ID  END ) as manual,
COUNT(DISTINCT CASE WHEN TS_TYPE = ''QUICKTEST_TEST'' THEN TS_TEST_ID  END ) as automatico,
R.REL_USER_04 as jpqa,

(SELECT  count(DISTINCT  RQ_USER_02)
FROM  '||x.db_name||'.REQ,  '||x.db_name||'.REQ_RELEASES 
WHERE RQ_TYPE_ID = 101 AND RQRL_RELEASE_ID = R.REL_ID and RQRL_REQ_ID = RQ_REQ_ID
AND RQ_USER_02 NOT IN (''Términado QA'',''Finalizado'',''Cancelado'',''En Producción'',''Pospuesto'',''Cerrado QA'',''Traspaso a Continuidad'') )  as estado,

min(R.REL_START_DATE) as fecha,


COUNT(DISTINCT CASE WHEN TS_TYPE = ''QUICKTEST_TEST'' AND 
TO_DATE(T.TS_VTS,''yyyy-mm-dd HH24:MI:SS'')  
BETWEEN TO_DATE(''2016-01-01'',''yyyy-mm-dd'')     AND   
TO_DATE(''2016-01-31'',''yyyy-mm-dd'')
 THEN TS_TEST_ID  END ) as automatico_modificados,

COUNT(DISTINCT CASE WHEN TS_TYPE = ''QUICKTEST_TEST'' AND 
TS_EXEC_STATUS != ''No Run'' THEN TS_TEST_ID  END ) as automatico_ejecutados,

''Proveedores Testing'' as dominio

FROM '||x.DB_NAME||'.RELEASES R, '||x.DB_NAME||'.TEST T
WHERE 
R.REL_NAME != ''Prueba'' AND
T.TS_CREATION_DATE >= TO_DATE(''2016-01-01'',''yyyy-mm-dd'') AND 
T.TS_CREATION_DATE <= TO_DATE(''2016-01-31'',''yyyy-mm-dd'') 

GROUP BY
R.REL_ID,
R.REL_USER_04
)
GROUP BY
esquema,
manual,
automatico,
jpqa,
fecha,
automatico_modificados,
automatico_ejecutados,
dominio


';
end loop;

for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME, DESCRIPTION from alm_siteadmin_db_12.projects WHERE DB_NAME = 'bch_qa_certificación_bch_qa_d') loop
execute immediate  'insert into ALM_REPORT.CONTEO_TEST

SELECT 
'''||x.PROJECT_NAME||''' as esquema,
NVL (MAN.CANT_MANUAL,0)  as manual,
NVL (cre.Creados ,0) AS automatico,
RQ.RQ_USER_03 AS JDP_QA,
  CASE WHEN  (
  COUNT  (DISTINCT CASE when RQ_USER_04 not in  (''Términado QA'',''Finalizado'',''Cancelado'',''En Producción'',''Pospuesto'',''Cerrado QA'',''Traspaso a Continuidad'')
  AND RQ_TYPE_ID = 107  THEN RQ_USER_04  end)
  )>0 THEN ''Activo'' ELSE ''No Activo''  END 
  as estado,

MIN(REL.REL_START_DATE) as fecha,
NVL (MANT.CANT_MANTENCION, 0) AS automatico_modificados ,
NVL (EJEC.CANT_EJEC ,0) AS automatico_ejecutados,

''BCH_QA_CERTIFICACIÓN_QA_D'' as dominio

FROM '||x.db_name||'.TEST TS
INNER JOIN '||x.db_name||'.AUDIT_LOG AU2 ON AU2.AU_ENTITY_ID = TS.TS_TEST_ID
INNER JOIN '||x.db_name||'.ALL_LISTS AL ON TS.TS_SUBJECT = AL.AL_ITEM_ID
LEFT JOIN '||x.db_name||'.REQ_COVER RC ON RC.RC_ENTITY_ID=TS.TS_TEST_ID
LEFT JOIN '||x.db_name||'.REQ RQ ON RQ.RQ_REQ_ID=RC.RC_REQ_ID
LEFT JOIN '||x.db_name||'.REQ_RELEASES RR ON RR.RQRL_REQ_ID=RQ.RQ_REQ_ID 
LEFT JOIN '||x.db_name||'.RELEASES REL ON REL.REL_ID=RR.RQRL_RELEASE_ID

LEFT JOIN (SELECT distinct (a.TS_TEST_ID) , Creados FROM (
                SELECT distinct (T.TS_TEST_ID )AS TS_TEST_ID ,1 AS Creados
                 FROM  '||x.db_name||'.TEST T
                INNER JOIN '||x.db_name||'.AUDIT_LOG AU ON AU.AU_ENTITY_ID = T.TS_TEST_ID
                INNER JOIN '||x.db_name||'.AUDIT_PROPERTIES AP ON AP.AP_ACTION_ID = AU.AU_ACTION_ID
                WHERE AU.AU_ENTITY_TYPE = ''TEST'' AND  T.TS_TYPE NOT IN (''MANUAL'') 
                AND AP.AP_PROPERTY_NAME IN (''Estado'')
                and AP_NEW_VALUE = ''Desarrollo'' or  AP_NEW_VALUE = ''Pruebas Internas'' or AP_NEW_VALUE = ''En Validación''
                having count (TS_TEST_ID)>=3
                GROUP BY T.TS_TEST_ID ) A                                                                                                                                                                                       
		LEFT JOIN (SELECT DISTINCT(TT.TS_TEST_ID),  COUNT (AP1.AP_NEW_VALUE)
                                FROM  '||x.db_name||'.TEST TT
                                INNER JOIN '||x.db_name||'.AUDIT_LOG AU1 ON AU1.AU_ENTITY_ID = TT.TS_TEST_ID
                                INNER JOIN '||x.db_name||'.AUDIT_PROPERTIES AP1 ON AP1.AP_ACTION_ID = AU1.AU_ACTION_ID
                                WHERE AU1.AU_ENTITY_TYPE = ''TEST'' AND  TT.TS_TYPE NOT IN (''MANUAL'') 
                                AND AP1.AP_PROPERTY_NAME IN (''Estado'')
                                AND (AP1.AP_NEW_VALUE = ''Mantención'' OR AP1.AP_NEW_VALUE =''En Corrección'' OR AP1.AP_NEW_VALUE =''Temporal'' )
                                GROUP BY TT.TS_TEST_ID  ) B
ON(A.TS_TEST_ID=B.TS_TEST_ID)
WHERE B.TS_TEST_ID IS NULL
) cre ON CRE.TS_TEST_ID=TS.TS_TEST_ID


LEFT JOIN (SELECT DISTINCT (TS_TEST_ID), COUNT (AP.AP_NEW_VALUE) AS CANT_MANTENCION
                                               FROM  '||x.db_name||'.TEST T
                                                               INNER JOIN '||x.db_name||'.AUDIT_LOG AU ON AU.AU_ENTITY_ID = T.TS_TEST_ID
                                                               INNER JOIN '||x.db_name||'.AUDIT_PROPERTIES AP ON AP.AP_ACTION_ID = AU.AU_ACTION_ID
                                                               INNER JOIN '||x.db_name||'.ALL_LISTS AL ON T.TS_SUBJECT = AL.AL_ITEM_ID
                                                               WHERE AU.AU_ENTITY_TYPE = ''TEST'' AND  T.TS_TYPE NOT IN (''MANUAL'') 
                                                               AND AL_ABSOLUTE_PATH   LIKE ''%AAAAAPAADAAR%''
                                                               AND AP.AP_PROPERTY_NAME IN (''Estado'')
                                                               AND AP.AP_NEW_VALUE = ''Mantención''
                                                               GROUP BY TS_TEST_ID)  MANT  ON MANT.TS_TEST_ID=TS.TS_TEST_ID
        
LEFT JOIN ( SELECT REL.REL_ID,  COUNT (RN_RUN_ID)AS CANT_EJEC
            FROM  '||x.db_name||'.RUN RN
            INNER JOIN '||x.db_name||'.RELEASE_CYCLES RC ON RC.RCYC_ID=RN.RN_ASSIGN_RCYC
            INNER JOIN '||x.db_name||'.TEST TS ON TS.TS_TEST_ID =RN.RN_TEST_ID
            INNER JOIN '||x.db_name||'.ALL_LISTS AL ON TS.TS_SUBJECT = AL.AL_ITEM_ID  
            INNER  JOIN '||x.db_name||'.RELEASES REL ON REL.REL_ID=RC.RCYC_PARENT_ID
            WHERE TS.TS_TYPE NOT IN (''MANUAL'') 
           AND AL_ABSOLUTE_PATH   LIKE ''%AAAAAPAADAAR%''
            group by REL.REL_ID) EJEC ON EJEC.REL_ID=REL.REL_ID
			
LEFT JOIN (SELECT REL.REL_ID,  COUNT (DISTINCT TS_TEST_ID)AS CANT_MANUAL
            FROM '||x.db_name||'.TEST TS
          INNER JOIN '||x.db_name||'.ALL_LISTS AL ON TS.TS_SUBJECT = AL.AL_ITEM_ID
          INNER JOIN '||x.db_name||'.REQ_COVER RC ON RC.RC_ENTITY_ID=TS.TS_TEST_ID
          INNER JOIN '||x.db_name||'.REQ RQ ON RQ.RQ_REQ_ID=RC.RC_REQ_ID
          INNER JOIN '||x.db_name||'.REQ_RELEASES RR ON RR.RQRL_REQ_ID=RQ.RQ_REQ_ID 
          INNER JOIN '||x.db_name||'.RELEASES REL ON REL.REL_ID=RR.RQRL_RELEASE_ID
            WHERE TS.TS_TYPE IN (''MANUAL'') 
          AND AL_ABSOLUTE_PATH   LIKE ''%AAAAAPAAI%''
            group by REL_ID
)MAN ON MAN.REL_ID=REL.REL_ID
WHERE AU2.AU_ENTITY_TYPE = ''TEST''-- AND AL.AL_ABSOLUTE_PATH LIKE ''%AAAAAPAAI%''
GROUP BY
MAN.CANT_MANUAL,
cre.Creados ,
RQ.RQ_USER_03 ,
REL.REL_START_DATE,
MANT.CANT_MANTENCION ,
EJEC.CANT_EJEC
';
end loop;


/*
for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME from alm_siteadmin_db_12.projects where DOMAIN_NAME = 'QA') loop
execute immediate  'insert into ALM_REPORT.CONTEO_TEST
SELECT DISTINCT
esquema,
jpqa, 
CASE WHEN sum(estado) > 0 THEN ''Activo'' ELSE ''No Activo''  END as estado,
descripcion

FROM
(SELECT
DISTINCT 
'''||x.PROJECT_NAME||''' as esquema,
R.REL_USER_04 as jpqa,
(SELECT  count(DISTINCT  RQ_USER_02)
FROM  '||x.db_name||'.REQ,  '||x.db_name||'.REQ_RELEASES 
WHERE RQ_TYPE_ID = 103 AND RQRL_RELEASE_ID = R.REL_ID and RQRL_REQ_ID = RQ_REQ_ID
AND RQ_USER_02 NOT IN (''Términado QA'',''Finalizado'',''Cancelado'',''En Producción'') )  as estado,
'''||x.DESCRIPTION||''' as descripcion

FROM '||x.db_name||'.RELEASE_FOLDERS RF
LEFT JOIN '||x.db_name||'.RELEASES R ON R.REL_PARENT_ID = RF.RF_ID

WHERE 
R.REL_NAME != ''Prueba'' and R.REL_NAME != '' ''

START WITH RF.RF_ID = 105
CONNECT BY PRIOR RF.RF_ID = RF_PARENT_ID

)
group by 
esquema,
jpqa,
descripcion
';

end loop;
*/


end;

/
