--------------------------------------------------------
--  DDL for Procedure cargarProyectos
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ALM_REPORT"."cargarProyectos" AS
BEGIN

execute immediate 'TRUNCATE TABLE ALM_REPORT.PROYECTOS';

execute immediate 'insert into ALM_REPORT.PROYECTOS
select 
P.PROJECT_NAME

from 
ALM_SITEADMIN_DB_12.PROJECTS P 
where 
P.domain_name in (''PROYECTOS'')
';
END;

/
