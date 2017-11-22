--------------------------------------------------------
--  DDL for Procedure cargarQueryHP1
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ALM_REPORT"."cargarQueryHP1" AS

BEGIN
execute immediate 'TRUNCATE TABLE ALM_REPORT.QUERY_HP1';


for x in (select DB_NAME from alm_siteadmin_db_12.projects where domain_name in ('PROYECTOS')) loop
execute immediate  'insert into ALM_REPORT.QUERY_HP1 
SELECT
RELEASES.REL_NAME,
RELEASES.REL_USER_03,
RUN.RN_RUN_ID,
rn_testcycl_id,
RUN.RN_EXECUTION_DATE,
RUN.RN_TESTER_NAME,
TEST.TS_USER_01,
RUN.RN_SUBTYPE_ID,
TEST.TS_TEST_ID,
to_char(RN_EXECUTION_DATE,''yyyy-mm'') "Mes",
RUN.RN_STATUS,
'''||x.db_name||''' AS esquema
FROM
'||x.db_name||'.Run, '||x.db_name||'.Test, '||x.db_name||'.RELEASES, '||x.db_name||'.RELEASE_FOLDERS, '||x.db_name||'.release_cycles
WHERE
rn_test_id = ts_test_id and
rn_assign_rcyc = rcyc_id and
rcyc_parent_id = rel_id and
rel_parent_id = rf_id
and to_char(RN_EXECUTION_DATE,''yyyy-mm-dd'')
between
(TO_CHAR(SYSDATE,''yyyy''))||''-''||(TO_CHAR(SYSDATE,''mm''))||''-''||''01''  and
(TO_CHAR(SYSDATE,''yyyy''))||''-''||(TO_CHAR(SYSDATE,''mm'')-1)||''-''||to_char(last_day(SYSDATE),''dd'')
ORDER BY  TS_TEST_ID


';


end loop;
/*
(TO_CHAR(SYSDATE,''yyyy''))||''-''||(TO_CHAR(SYSDATE,''mm''))||''-''||''01''  and
(TO_CHAR(SYSDATE,''yyyy''))||''-''||(TO_CHAR(SYSDATE,''mm'')-1)||''-''||to_char(last_day(SYSDATE),''dd'')
*/

end;

/
