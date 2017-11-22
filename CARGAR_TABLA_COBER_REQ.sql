--------------------------------------------------------
--  DDL for Procedure CARGAR_TABLA_COBER_REQ
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ALM_REPORT"."CARGAR_TABLA_COBER_REQ" AS 
BEGIN
 execute immediate 'TRUNCATE TABLE ALM_REPORT.TABLACOBERREQ';
 
for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME from alm_siteadmin_db_12.projects where DB_NAME = 'bch_qa_certificación_bch_qa_d') loop
execute immediate  'insert into ALM_REPORT.TABLACOBERREQ 

SELECT
'''||x.DOMAIN_NAME||''' as DOMINIO,
'''||x.PROJECT_NAME||''' as PROYECTO,
REL_NAME AS RELEASES,
RQ_REQ_ID AS ID_REQ,
RCYC_NAME AS NOMBRE_CICLO,
TS_TEST_ID AS ID_CASO,  
to_date(TC.TC_EXEC_DATE,''DD/MM/YYYY'') AS FECHA_INSTANCIA,
TC.TC_EXEC_TIME AS HORA_INSTANCIA,
TC.TC_STATUS AS ESTADO_INSTANCIA,
REL_ID AS ID_REL
FROM bch_qa_certificación_bch_qa_d.REQ
LEFT JOIN bch_qa_certificación_bch_qa_d.REQ_COVER ON RC_REQ_ID = RQ_REQ_ID
LEFT JOIN  bch_qa_certificación_bch_qa_d.TEST ON TS_TEST_ID = RC_ENTITY_ID
LEFT JOIN bch_qa_certificación_bch_qa_d.TESTCYCL TC ON TC.TC_TEST_ID = TS_TEST_ID
LEFT JOIN bch_qa_certificación_bch_qa_d.RELEASE_CYCLES ON RCYC_ID = TC_ASSIGN_RCYC
LEFT JOIN bch_qa_certificación_bch_qa_d.RELEASES ON REL_ID = RCYC_PARENT_ID 
WHERE 1=1
--AND RQ_REQ_ID = ''5471''
AND RQ_TYPE_ID IN (''3'')
ORDER BY RQ_REQ_ID, RCYC_NAME, TC.TC_EXEC_DATE,TC.TC_EXEC_TIME

'; end loop;

for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME  from alm_siteadmin_db_12.projects where DB_NAME = 'qa_qa_db0') loop
execute immediate  'insert into ALM_REPORT.TABLACOBERREQ

SELECT
'''||x.DOMAIN_NAME||''' as DOMINIO,
'''||x.PROJECT_NAME||''' as PROYECTO,
REL_NAME AS RELEASES,
RQ_REQ_ID AS ID_REQ,
RCYC_NAME AS NOMBRE_CICLO,
TS_TEST_ID AS ID_CASO,  
to_date(TC.TC_EXEC_DATE,''DD/MM/YYYY'') AS FECHA_INSTANCIA,
TC.TC_EXEC_TIME AS HORA_INSTANCIA,
TC.TC_STATUS AS ESTADO_INSTANCIA,
REL_ID AS ID_REL
FROM QA_QA_DB0.REQ
LEFT JOIN QA_QA_DB0.REQ_COVER ON RC_REQ_ID = RQ_REQ_ID
LEFT JOIN  QA_QA_DB0.TEST ON TS_TEST_ID = RC_ENTITY_ID
LEFT JOIN QA_QA_DB0.TESTCYCL TC ON TC.TC_TEST_ID = TS_TEST_ID
LEFT JOIN QA_QA_DB0.RELEASE_CYCLES ON RCYC_ID = TC_ASSIGN_RCYC
LEFT JOIN QA_QA_DB0.RELEASES ON REL_ID = RCYC_PARENT_ID 
WHERE 1=1
--AND RQ_REQ_ID = ''5471''
AND RQ_TYPE_ID IN (''3'')
ORDER BY RQ_REQ_ID, RCYC_NAME, TC.TC_EXEC_DATE,TC.TC_EXEC_TIME


'; end loop;

 
END;

/