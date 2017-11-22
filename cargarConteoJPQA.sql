--------------------------------------------------------
--  DDL for Procedure cargarConteoJPQA
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ALM_REPORT"."cargarConteoJPQA" AS
BEGIN
execute immediate 'TRUNCATE TABLE ALM_REPORT.CONTEO_JPQA';

for x in (select DB_NAME, PROJECT_NAME, DESCRIPTION from alm_siteadmin_db_12.projects where domain_name in ('PROYECTOS') and PR_IS_ACTIVE = 'Y') loop
execute immediate  'insert into ALM_REPORT.CONTEO_JPQA
SELECT DISTINCT
esquema,
jpqa, 
CASE WHEN sum(estado) > 0 THEN ''Activo'' ELSE ''No Activo''  END as estado,
fecha_minima,
requerimiento,
dominio,
release,
tipo_requerimiento,
estado_requerimiento,
CICLO,
FECHA_EJECUCION


FROM
(SELECT
DISTINCT 
'''||x.PROJECT_NAME||''' as esquema,

RQ.RQ_USER_03 as jpqa,

(SELECT  count(DISTINCT  RQ_USER_02)
FROM  '||x.db_name||'.REQ_RELEASES 
JOIN '||x.db_name||'.REQ ON  RQRL_REQ_ID = RQ_REQ_ID
JOIN '||x.DB_NAME||'.REQ_TYPE RT ON RT.TPR_TYPE_ID = RQ_TYPE_ID
WHERE RT.TPR_NAME IN (''Proyecto'',''Proyecto Evolutivo'',''Proyecto Normativo'') 
AND RQRL_RELEASE_ID = R.REL_ID AND 
RQ_USER_02 NOT IN (''Términado QA'',''Finalizado'',''Cancelado'',''En Producción'',''Pospuesto'',''Cerrado QA'',''Traspaso a Continuidad'') )  as estado,


min(R.REL_START_DATE) as fecha_minima,

NVL((SELECT DISTINCT  MAX(RQ_REQ_NAME) 
FROM  '||x.db_name||'.REQ_RELEASES 
JOIN '||x.db_name||'.REQ ON  RQRL_REQ_ID = RQ_REQ_ID
JOIN '||x.DB_NAME||'.REQ_TYPE RT ON RT.TPR_TYPE_ID = RQ_TYPE_ID
WHERE RT.TPR_NAME IN (''Proyecto'',''Proyecto Evolutivo'',''Proyecto Normativo'') 
AND RQRL_RELEASE_ID = R.REL_ID), 
''No tiene trazabilidad al requerimiento'') as requerimiento ,

''PROYECTOS'' as dominio,

R.REL_NAME as release,

NVL((SELECT DISTINCT  MAX(TPR_NAME)
FROM  '||x.db_name||'.REQ_RELEASES 
JOIN '||x.db_name||'.REQ ON  RQRL_REQ_ID = RQ_REQ_ID
JOIN '||x.DB_NAME||'.REQ_TYPE RT ON RT.TPR_TYPE_ID = RQ_TYPE_ID
WHERE RT.TPR_NAME IN (''Proyecto'',''Proyecto Evolutivo'',''Proyecto Normativo'') 
AND RQRL_RELEASE_ID = R.REL_ID ),
''No tiene trazabilidad al requerimiento o se encuentra vacio'') as tipo_requerimiento,

(SELECT  MAX(DISTINCT  RQ_USER_02)

FROM  '||x.db_name||'.REQ_RELEASES 
JOIN '||x.db_name||'.REQ ON  RQRL_REQ_ID = RQ_REQ_ID
JOIN '||x.DB_NAME||'.REQ_TYPE RT ON RT.TPR_TYPE_ID = RQ_TYPE_ID
WHERE RT.TPR_NAME IN (''Proyecto'',''Proyecto Evolutivo'',''Proyecto Normativo'') 
AND RQRL_RELEASE_ID = R.REL_ID  )  as estado_requerimiento,

RCYC.RCYC_NAME "CICLO",
CASE 
WHEN TO_CHAR(TC.TC_EXEC_DATE, ''DD-MM-YYYY'') IS NULL THEN ''Sin fecha de ejecución'' else TO_CHAR(TC.TC_EXEC_DATE, ''DD-MM-YYYY'') 
END as FECHA_EJECUCION

FROM '||x.DB_NAME||'.RELEASES R
JOIN '||x.DB_NAME||'.REQ_RELEASES RQRL ON RQRL.RQRL_RELEASE_ID = R.REL_ID 
JOIN '||x.DB_NAME||'.REQ RQ ON RQ.RQ_REQ_ID = RQRL.RQRL_REQ_ID 
LEFT JOIN '||x.DB_NAME||'.RELEASE_CYCLES RCYC ON RCYC.RCYC_PARENT_ID = R.REL_ID
LEFT JOIN '||x.DB_NAME||'.TESTCYCL TC ON TC.TC_ASSIGN_RCYC = RCYC.RCYC_ID


WHERE 
R.REL_NAME != ''Prueba''
AND R.REL_PARENT_ID NOT IN (SELECT RF_ID FROM '||x.DB_NAME||'.RELEASE_FOLDERS 
START WITH RF_NAME= ''Papelera'' CONNECT BY PRIOR RF_ID = RF_PARENT_ID)


GROUP BY
R.REL_USER_04,
R.REL_ID,
R.REL_NAME,
RQ.RQ_USER_03,
RCYC.RCYC_NAME,
TC.TC_EXEC_DATE

)
group by 
esquema,
jpqa,
fecha_minima,
requerimiento,
dominio,
release,
tipo_requerimiento,
estado_requerimiento,
CICLO,
FECHA_EJECUCION

';

end loop;

for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME, DESCRIPTION from alm_siteadmin_db_12.projects WHERE DB_NAME = 'proveedores_testing_sqa_db') loop
execute immediate  'insert into ALM_REPORT.CONTEO_JPQA
SELECT DISTINCT
esquema,
jpqa, 
CASE WHEN sum(estado) > 0 THEN ''Activo'' ELSE ''No Activo''  END as estado,
fecha_minima,
requerimiento,
dominio,
release,
tipo_requerimiento,
estado_requerimiento,
CICLO,
FECHA_EJECUCION

FROM
(SELECT
DISTINCT 
'''||x.PROJECT_NAME||''' as esquema,

RQ.RQ_USER_03 as jpqa,

(SELECT  count(DISTINCT  RQ_USER_02)
FROM  '||x.db_name||'.REQ_RELEASES 
JOIN '||x.db_name||'.REQ ON  RQRL_REQ_ID = RQ_REQ_ID
JOIN '||x.DB_NAME||'.REQ_TYPE RT ON RT.TPR_TYPE_ID = RQ_TYPE_ID
WHERE RT.TPR_NAME IN (''Proyecto'',''Proyecto Evolutivo'',''Proyecto Normativo'') 
AND RQRL_RELEASE_ID = R.REL_ID AND 
RQ_USER_02 NOT IN (''Términado QA'',''Finalizado'',''Cancelado'',''En Producción'',''Pospuesto'',''Cerrado QA'',''Traspaso a Continuidad'') )  as estado,


min(R.REL_START_DATE) as fecha_minima,

NVL((SELECT DISTINCT  MAX(RQ_REQ_NAME) 
FROM  '||x.db_name||'.REQ_RELEASES 
JOIN '||x.db_name||'.REQ ON  RQRL_REQ_ID = RQ_REQ_ID
JOIN '||x.DB_NAME||'.REQ_TYPE RT ON RT.TPR_TYPE_ID = RQ_TYPE_ID
WHERE RT.TPR_NAME IN (''Proyecto'',''Proyecto Evolutivo'',''Proyecto Normativo'') 
AND RQRL_RELEASE_ID = R.REL_ID), 
''No tiene trazabilidad al requerimiento'') as requerimiento ,

''Proveedores Testing'' as dominio,

R.REL_NAME as release,

NVL((SELECT DISTINCT  MAX(TPR_NAME)
FROM  '||x.db_name||'.REQ_RELEASES 
JOIN '||x.db_name||'.REQ ON  RQRL_REQ_ID = RQ_REQ_ID
JOIN '||x.DB_NAME||'.REQ_TYPE RT ON RT.TPR_TYPE_ID = RQ_TYPE_ID
WHERE RT.TPR_NAME IN (''Proyecto'',''Proyecto Evolutivo'',''Proyecto Normativo'') 
AND RQRL_RELEASE_ID = R.REL_ID ),
''No tiene trazabilidad al requerimiento o se encuentra vacio'') as tipo_requerimiento,

(SELECT  MAX(DISTINCT  RQ_USER_02)

FROM  '||x.db_name||'.REQ_RELEASES 
JOIN '||x.db_name||'.REQ ON  RQRL_REQ_ID = RQ_REQ_ID
JOIN '||x.DB_NAME||'.REQ_TYPE RT ON RT.TPR_TYPE_ID = RQ_TYPE_ID
WHERE RT.TPR_NAME IN (''Proyecto'',''Proyecto Evolutivo'',''Proyecto Normativo'') 
AND RQRL_RELEASE_ID = R.REL_ID  )  as estado_requerimiento,

RCYC.RCYC_NAME "CICLO",
CASE 
WHEN TO_CHAR(TC.TC_EXEC_DATE, ''DD-MM-YYYY'') IS NULL THEN ''Sin fecha de ejecución'' else TO_CHAR(TC.TC_EXEC_DATE, ''DD-MM-YYYY'') 
END as FECHA_EJECUCION

FROM '||x.DB_NAME||'.RELEASES R
JOIN '||x.DB_NAME||'.REQ_RELEASES RQRL ON RQRL.RQRL_RELEASE_ID = R.REL_ID 
JOIN '||x.DB_NAME||'.REQ RQ ON RQ.RQ_REQ_ID = RQRL.RQRL_REQ_ID 
LEFT JOIN '||x.DB_NAME||'.RELEASE_CYCLES RCYC ON RCYC.RCYC_PARENT_ID = R.REL_ID
LEFT JOIN '||x.DB_NAME||'.TESTCYCL TC ON TC.TC_ASSIGN_RCYC = RCYC.RCYC_ID


WHERE 
R.REL_NAME != ''Prueba''
AND R.REL_PARENT_ID NOT IN (SELECT RF_ID FROM '||x.DB_NAME||'.RELEASE_FOLDERS 
START WITH RF_NAME= ''Papelera'' CONNECT BY PRIOR RF_ID = RF_PARENT_ID)


GROUP BY
R.REL_USER_04,
R.REL_ID,
R.REL_NAME,
RQ.RQ_USER_03,
RCYC.RCYC_NAME,
TC.TC_EXEC_DATE

)
group by 
esquema,
jpqa,
fecha_minima,
requerimiento,
dominio,
release,
tipo_requerimiento,
estado_requerimiento,
CICLO,
FECHA_EJECUCION
';
end loop;

for x in (select DB_NAME, PROJECT_NAME, DESCRIPTION from alm_siteadmin_db_12.projects where  DB_NAME = 'bch_qa_certificación_bch_qa_d') loop
execute immediate  'insert into ALM_REPORT.CONTEO_JPQA

SELECT DISTINCT

'''||x.PROJECT_NAME||''' as esquema,

RQ.RQ_USER_03 as jpqa,

case WHEN RQ.RQ_USER_04 in (''Términado QA'',''Finalizado'',''Cancelado'',''En Producción'',''Pospuesto'',''Cerrado QA'',''Traspaso a Continuidad'')  
then ''No Activo'' else ''Activo'' end  as estado,


(SELECT min(REL_START_DATE) FROM '||x.DB_NAME||'.RELEASES JOIN '||x.DB_NAME||'.REQ_RELEASES ON RQRL_RELEASE_ID = REL_ID 
WHERE RQRL_REQ_ID = RQ.RQ_REQ_ID) as fecha_minima,

RQ.RQ_REQ_NAME as requerimiento ,

''BCH_QA_CERTIFICACIÓN_QA_D'' as dominio,

NVL((SELECT MAX(REL_NAME) FROM '||x.DB_NAME||'.RELEASES r2 JOIN '||x.DB_NAME||'.REQ_RELEASES ON RQRL_RELEASE_ID = REL_ID 
WHERE RQRL_REQ_ID = RQ.RQ_REQ_ID), ''No tiene trazababilidad al release'') as release,

RT.TPR_NAME as tipo_requerimiento,

RQ.RQ_USER_04 as estado_requerimiento,
RCYC.RCYC_NAME "CICLO",
CASE 
WHEN  TO_CHAR(TC.TC_EXEC_DATE, ''DD-MM-YYYY'') IS NULL THEN ''Sin fecha de ejecución'' else TO_CHAR(TC.TC_EXEC_DATE, ''DD-MM-YYYY'') 
END as FECHA_EJECUCION

FROM '||x.DB_NAME||'.REQ RQ
JOIN '||x.DB_NAME||'.REQ_TYPE RT ON RT.TPR_TYPE_ID = RQ.RQ_TYPE_ID
LEFT JOIN '||x.DB_NAME||'.REQ_CYCLES RQC ON RQC.RQC_REQ_ID = RQ.RQ_REQ_ID
LEFT JOIN '||x.DB_NAME||'.RELEASE_CYCLES RCYC ON RCYC.RCYC_ID = RQC.RQC_CYCLE_ID
LEFT JOIN '||x.DB_NAME||'.TESTCYCL TC ON TC.TC_ASSIGN_RCYC = RCYC.RCYC_ID 

WHERE 
RT.TPR_NAME IN (''Proyecto'',''Proyecto Evolutivo'',''Proyecto Normativo'') 


';

end loop;
/*

########### VALIDAR CAMPOS PERSONALIZADOS EN ESQUEMA QA ##################

for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME from alm_siteadmin_db_12.projects where DOMAIN_NAME = 'QA') loop
execute immediate  'insert into ALM_REPORT.CONTEO_JPQA

SELECT DISTINCT

'''||x.PROJECT_NAME||''' as esquema,

RQ.RQ_USER_03 as jpqa,

case WHEN RQ.RQ_USER_04 in (''Términado QA'',''Finalizado'',''Cancelado'',''En Producción'',''Pospuesto'',''Cerrado QA'',''Traspaso a Continuidad'')  
then ''No Activo'' else ''Activo'' end  as estado,


(SELECT min(REL_START_DATE) FROM '||x.DB_NAME||'.RELEASES JOIN '||x.DB_NAME||'.REQ_RELEASES ON RQRL_RELEASE_ID = REL_ID 
WHERE RQRL_REQ_ID = RQ.RQ_REQ_ID) as fecha_minima,

RQ.RQ_REQ_NAME as requerimiento ,

''BCH_QA_CERTIFICACIÓN_QA_D'' as dominio,

NVL((SELECT MAX(REL_NAME) FROM '||x.DB_NAME||'.RELEASES r2 JOIN '||x.DB_NAME||'.REQ_RELEASES ON RQRL_RELEASE_ID = REL_ID 
WHERE RQRL_REQ_ID = RQ.RQ_REQ_ID), ''No tiene trazababilidad al release'') as release,

RT.TPR_NAME as tipo_requerimiento,

RQ.RQ_USER_04 as estado_requerimiento,
RCYC.RCYC_NAME "CICLO",
CASE 
WHEN  TO_CHAR(TC.TC_EXEC_DATE, ''DD-MM-YYYY'') IS NULL THEN ''Sin fecha de ejecución'' else TO_CHAR(TC.TC_EXEC_DATE, ''DD-MM-YYYY'') 
END as FECHA_EJECUCION

FROM '||x.DB_NAME||'.REQ RQ
JOIN '||x.DB_NAME||'.REQ_TYPE RT ON RT.TPR_TYPE_ID = RQ.RQ_TYPE_ID
LEFT JOIN '||x.DB_NAME||'.REQ_CYCLES RQC ON RQC.RQC_REQ_ID = RQ.RQ_REQ_ID
LEFT JOIN '||x.DB_NAME||'.RELEASE_CYCLES RCYC ON RCYC.RCYC_ID = RQC.RQC_CYCLE_ID
LEFT JOIN '||x.DB_NAME||'.TESTCYCL TC ON TC.TC_ASSIGN_RCYC = RCYC.RCYC_ID 

WHERE 
RT.TPR_NAME IN (''Proyecto'',''Proyecto Evolutivo'',''Proyecto Normativo'') 

';

end loop;*/
end;

/
