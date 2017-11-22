--------------------------------------------------------
--  DDL for Procedure CARGA_MANTENCIONES
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ALM_REPORT"."CARGA_MANTENCIONES" AS 

ESTADO VARCHAR2(10);

select 
T.ts_test_id, ts_status
FROM  bch_qa_certificación_bch_qa_d.TEST T

BEGIN

WHILE (ESTADO) LOOP
DBMS_OUTPUT.PUT_LINE(vr_emple.emp_no||' * '
||vr_emple.apellido);
END LOOP;

  NULL;
END PROCEDURE1;





create or replace PROCEDURE CARGA_MANTENCIONES AS 
BEGIN

 execute immediate 'TRUNCATE TABLE ALM_REPORT.PRUEBAINFO';


for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME from alm_siteadmin_db_12.projects where DB_NAME = 'bch_qa_certificación_bch_qa_d') loop
execute immediate  'insert into ALM_REPORT.PRUEBAINFO  

select 
T.ts_test_id, ts_status
FROM  '||x.db_name||'.TEST T



';

end loop;
END;

/
