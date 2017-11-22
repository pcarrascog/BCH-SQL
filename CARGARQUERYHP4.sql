--------------------------------------------------------
--  DDL for Procedure CARGARQUERYHP4
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ALM_REPORT"."CARGARQUERYHP4" AS 
BEGIN
execute immediate 'TRUNCATE TABLE ALM_REPORT.QUERY_HP4';

for x in (select DB_NAME, PROJECT_NAME, DESCRIPTION from alm_siteadmin_db_12.projects where domain_name in ('PROYECTOS')) loop
execute immediate  'insert into ALM_REPORT.QUERY_HP4
SELECT
REQ.RQ_REQ_NAME as NOMBRE_BSL_PRODUCTO,
TO_NUMBER(SUBSTR(REQ.RQ_USER_11,1,100)) as LINEAS_CODIGO,
req.RQ_USER_04 AS TESTER,
REQ.RQ_USER_07 as INCID_PPM_ART,
SUBSTR(REL.rel_name,1,100) as FASE,
REQ.RQ_USER_13 as ESTADO_FINAL,
REQ.RQ_REQ_STATUS as COVERTURA,
REQ.RQ_USER_24 as LENGUAJE,
REQ.RQ_USER_26 as PRODUCTO_1,
REQ.RQ_USER_27 as PRODUCTO_2,
REQ.RQ_USER_18 as PLATAFORMA,
REQ.RQ_VC_CHECKIN_DATE as FECHA_ULTIMO_MOV,
REQ.RQ_VC_CHECKIN_USER_NAME as USUARIO_ULTIMO_MOV,
REQ.RQ_USER_28 as PROVEE_DESARROLLO,
'''||X.PROJECT_NAME||''' AS ESQUEMA

FROM '||X.DB_NAME||'.REQ REQ, '||X.DB_NAME||'.REQ_RELEASES RQRL, '||X.DB_NAME||'.RELEASES REL
WHERE TRUNC(REQ.RQ_VC_CHECKIN_DATE) BETWEEN (trunc(sysdate, ''mm'')-10) AND  LAST_DAY(TRUNC(SYSDATE ,''Month''))
AND REQ.RQ_REQ_STATUS <> ''N/A''
AND lower(substr(REQ.RQ_REQ_NAME,1,6)) <> ''prueba''
AND lower(substr(REQ.RQ_REQ_NAME,1,4)) <> ''elim''
AND lower(substr(REQ.RQ_REQ_NAME,1,4)) <> ''borr''
AND REQ.RQ_USER_13 is not null
AND REQ.rq_req_id = RQRL.rqrl_req_id (+)
AND RQRL.rqrl_release_id = REL.rel_id (+)
ORDER by REQ.RQ_VC_CHECKIN_DATE

';

end loop;
end;

/
