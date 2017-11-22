--------------------------------------------------------
--  DDL for Procedure cargarQueryHP3
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ALM_REPORT"."cargarQueryHP3" AS
BEGIN
execute immediate 'TRUNCATE TABLE ALM_REPORT.QUERY_HP3';

for x in (select DB_NAME, PROJECT_NAME, DESCRIPTION from alm_siteadmin_db_12.projects where domain_name in ('PROYECTOS')) loop
execute immediate  'insert into ALM_REPORT.QUERY_HP3
SELECT
REQ.RQ_REQ_ID as Id_REQ_MET,
REQ.RQ_FATHER_ID AS Padre,
REQ.RQ_TYPE_ID as GUIA_MET,
req.RQ_USER_04 AS Tester,
REQ.RQ_USER_07 as INCID_PPM_MET_1,
SUBSTR(REL.rel_name,1,100) as INCID_PPM_MET,
REQ.RQ_REQ_STATUS as Covertura_MET,
REQ.RQ_USER_24 as Lenguaje_MET,
REQ.RQ_USER_26 as Prod_1_MET,
REQ.RQ_USER_27 as Prod_2_MET,
REQ.RQ_USER_18 as Plat_MET,
REQ.RQ_USER_13 as Est_Fin_MET,
REQ.RQ_VC_CHECKIN_DATE as FEC_CHK_IN_MET,
REQ.RQ_VC_CHECKIN_USER_NAME as USU_MET,
TO_NUMBER(SUBSTR(REQ.RQ_USER_11,1,100)) as Lin_MET,
REQ.RQ_USER_28 as REQ_PROV_MET,
'''||X.PROJECT_NAME||''' AS ESQUEMA
FROM '||X.DB_NAME||'.REQ REQ, '||X.DB_NAME||'.REQ_RELEASES RQRL, '||X.DB_NAME||'.RELEASES REL
WHERE TRUNC(REQ.RQ_VC_CHECKIN_DATE) between to_date(''22-01-2016'',''dd-mm-yyyy'') and to_date(''29-02-2016'',''dd-mm-yyyy'')
AND REQ.RQ_USER_23 is not null
AND REQ.RQ_USER_22 <> ''Not Covered''
AND REQ.rq_req_id = RQRL.rqrl_req_id (+)
AND RQRL.rqrl_release_id = REL.rel_id (+)
ORDER by REQ.RQ_USER_02
';

end loop;
end;

/
