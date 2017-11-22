--------------------------------------------------------
--  DDL for Procedure cargarQueryHP2
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ALM_REPORT"."cargarQueryHP2" AS
BEGIN
execute immediate 'TRUNCATE TABLE ALM_REPORT.QUERY_HP2';


for x in (select DB_NAME from alm_siteadmin_db_12.projects where domain_name in ('PROYECTOS')) loop
execute immediate  'insert into ALM_REPORT.QUERY_HP2
select
Nombre_Proyecto,
b.RCYC_NAME as Nombre_Ciclo,

count(case when c.TC_STATUS not in (''N/A'') then c.TC_STATUS  end) as Total_Casos2,
count(case when c.TC_STATUS=''Passed'' then c.TC_STATUS end) as Total_Casos_OK,
count(case when c.TC_STATUS=''Failed'' then c.TC_STATUS end) as Total_Casos_ERROR,
count(case when c.TC_STATUS not in (''Passed'',''Failed'',''N/A'') then c.TC_STATUS  end) as Total_Otros2,


sum((select count(*) from '||x.db_name||'.run x2 where x2.RN_TESTCYCL_ID=c.TC_TESTCYCL_ID and RN_STATUS in (''Passed'',''Failed'',''Not Completed''))) as ejecuciones2,

sum((select count(*) from '||x.db_name||'.run x2 where x2.RN_TESTCYCL_ID=c.TC_TESTCYCL_ID and RN_STATUS=''Passed'')) as Passed,

sum((select count(*) from '||x.db_name||'.run x2 where x2.RN_TESTCYCL_ID=c.TC_TESTCYCL_ID and RN_STATUS=''Not Completed'')) as Otros,
sum((select count(*) from '||x.db_name||'.run x2 where x2.RN_TESTCYCL_ID=c.TC_TESTCYCL_ID and RN_STATUS=''Failed'')) as Failed,


min((select count(*) from '||x.db_name||'.BUG x3 where x3.BG_TARGET_RCYC=b.RCYC_ID)) as defectos_general,
min((select count(*) from '||x.db_name||'.BUG x3 where x3.BG_TARGET_RCYC=b.RCYC_ID and bg_status not in (''Postpone'',''Canceled'',''Closed''))) as defectos_activos,
min((select count(*) from '||x.db_name||'.BUG x3 where x3.BG_TARGET_RCYC=b.RCYC_ID and bg_status in (''Postpone'',''Canceled'',''Closed''))) as defectos_inactivos,

min((select count(*) from '||x.db_name||'.BUG x3 where x3.BG_TARGET_RCYC=b.RCYC_ID and x3.BG_USER_06 in (''Error de Requerimiento'',''Error de Diseño'',''Error de Codificación - Funcional'',''Error de Codificación - IDC'',''Error de Procesamiento de Interfaces'',''Error de Parametros''))) as defectos_desarrollo,
min((select count(*) from '||x.db_name||'.BUG x3 where x3.BG_TARGET_RCYC=b.RCYC_ID and bg_status not in (''Postpone'',''Canceled'',''Closed'') and x3.BG_USER_06 in (''Error de Requerimiento'',''Error de Diseño'',''Error de Codificación - Funcional'',''Error de Codificación - IDC'',''Error de Procesamiento de Interfaces'',''Error de Parametros''))) as defectos_activos_desa,
min((select count(*) from '||x.db_name||'.BUG x3 where x3.BG_TARGET_RCYC=b.RCYC_ID and bg_status in (''Postpone'',''Canceled'',''Closed'') and x3.BG_USER_06 in (''Error de Requerimiento'',''Error de Diseño'',''Error de Codificación - Funcional'',''Error de Codificación - IDC'',''Error de Procesamiento de Interfaces'',''Error de Parametros''))) as defectos_inactivos_desa,

min((select count(*) from '||x.db_name||'.BUG x3 where x3.BG_TARGET_RCYC=b.RCYC_ID and x3.BG_USER_06 in (''Error de Ambiente Hardware'',''Error de Ambiente Software'',''Error de Pruebas''))) as defectos_ambiente,
min((select count(*) from '||x.db_name||'.BUG x3 where x3.BG_TARGET_RCYC=b.RCYC_ID and bg_status not in (''Postpone'',''Canceled'',''Closed'') and x3.BG_USER_06 in (''Error de Ambiente Hardware'',''Error de Ambiente Software'',''Error de Pruebas''))) as defectos_activos_ambiente,
min((select count(*) from '||x.db_name||'.BUG x3 where x3.BG_TARGET_RCYC=b.RCYC_ID and bg_status in (''Postpone'',''Canceled'',''Closed'') and x3.BG_USER_06 in (''Error de Ambiente Hardware'',''Error de Ambiente Software'',''Error de Pruebas''))) as defectos_inactivos_ambiente,
'''||x.db_name||''' as esquema

from
(select
c.rel_name as Nombre_Proyecto,
c.REL_ID

from '||x.db_name||'.RELEASE_FOLDERS d   inner join '||x.db_name||'.RELEASES c
on  c.rel_parent_id = d.rf_id
and c.REL_ID in (1002)) uno left join '||x.db_name||'.RELEASE_CYCLES b
on  b.RCYC_PARENT_ID=uno.REL_ID
-----------------------------------------------------
left join '||x.db_name||'.TESTCYCL c
on c.TC_ASSIGN_RCYC=b.RCYC_ID
-----------------------------------------------------
----------------------------------------------------
group by  Nombre_Proyecto,b.RCYC_NAME
order by Nombre_Proyecto asc

';


end loop;


end;

/
