--------------------------------------------------------
--  DDL for Procedure CARGAR_INCIDENTES
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ALM_REPORT"."CARGAR_INCIDENTES" AS 
BEGIN
 execute immediate 'TRUNCATE TABLE ALM_REPORT.INCIDENTES_QA';
 
for x in (select DB_NAME, PROJECT_NAME, DOMAIN_NAME from alm_siteadmin_db_12.projects where DB_NAME = 'bch_qa_certificación_bch_qa_d') loop
execute immediate  'insert into ALM_REPORT.INCIDENTES_QA 

SELECT
RELEASES.Rel_ID as ID_Release,
RELEASES.Rel_Name as Nombre_Release,
RELEASES.REL_USER_TEMPLATE_02 AS Jefe_Area_Desarrollo, 
REQ.RQ_REQ_ID  as Id_Req,
REQ.RQ_REQ_AUTHOR   as Autor,
REQ.RQ_USER_03 as JDP_QA,
REQ.RQ_USER_04 as Estado,
REQ.RQ_USER_39 as Sub_Estado,
REQ.RQ_USER_10  as Sistema,
REQ.RQ_USER_02  as N_Incidente_o_PPM,
REQ.RQ_REQ_NAME as Nombre_Requerimiento,
''-'',--CAST (REPLACE(REGEXP_REPLACE( REPLACE (REPLACE(SUBSTR(REQ.RQ_DEV_COMMENTS,(INSTR(REQ.RQ_DEV_COMMENTS,''________________________________________'',-1)),LENGTH(REQ.RQ_DEV_COMMENTS)+1-(INSTR(REQ.RQ_DEV_COMMENTS,''________________________________________'',-1))),''________________________________________</b></span></font><font face="Arial"><span style="font-size:8pt"><br /></span></font><font face="Arial" color="#000080"><span style="font-size:8pt"><b>'',''''),''</b></span></font><font face="Arial"><span style="font-size:8pt">'','''' ),''<[^>]*>'',''''),chr(13),'''') AS VARCHAR2(3000))"Situación_Actual",
''-'',--REQ.RQ_USER_32 as Comentario_Banco,
RELEASES.REL_START_DATE as Fec_Ini_Cert,
TO_DATE(REQ.RQ_USER_28, ''YYYY-MM-dd'') as Fec_Fin_Cert,
REQ.RQ_USER_11 as Proveedor,
REQ.RQ_USER_33 as Coordinador_QA,
REQ.RQ_USER_07 as Tester,
REQ.RQ_REQ_DATE as Fecha_Creación,
FECHA_ULT_MOD_ESTADO as Fecha_Último_Estado,
sysdate,
TPR_NAME as Tipo_Requerimiento,
DIAS_LABORABLES(REQ.RQ_REQ_DATE,SYSDATE) as Avance_en_días,
''SERVIDOR TSOFT'' as Servidor,
REQ.RQ_USER_22 as Prioridad,
DIAS_LABORABLES(FECHA_ULT_MOD_ESTADO,SYSDATE) as AVANCE_ULTIMO

FROM '||x.db_name||'.REQ
left join '||x.db_name||'.REQ_RELEASES on RQ_REQ_ID = RQRL_REQ_ID
left join '||x.db_name||'.RELEASES on RQRL_RELEASE_ID = REL_ID
left join '||x.db_name||'.RELEASE_CYCLES on REL_ID = RELEASE_CYCLES.RCYC_PARENT_ID
left join '||x.db_name||'.REQ_TYPE ON RQ_TYPE_ID = TPR_TYPE_ID
--left join '||x.db_name||'.RELEASE_FOLDERS RF ON RF.RF_ID = RELEASES.REL_PARENT_ID 

LEFT JOIN
      (SELECT MAX(AU_TIME) AS FECHA_ULT_MOD_ESTADO, AU_ENTITY_ID AS ID_ENTIDAD--, AP_OLD_VALUE, AP_NEW_VALUE
      FROM '||x.db_name||'.AUDIT_LOG 
      JOIN '||x.db_name||'.AUDIT_PROPERTIES ON AP_ACTION_ID = AU_ACTION_ID
      WHERE 1=1
      AND AU_ENTITY_TYPE = ''REQ''
      AND AP_FIELD_NAME = ''RQ_USER_04''
      GROUP BY AU_ENTITY_ID
      ) TB ON TB.ID_ENTIDAD = REQ.RQ_REQ_ID
WHERE REQ.RQ_TYPE_ID in (102,116,121,124,125,113)
and ((RELEASE_CYCLES.RCYC_NAME not like ''%IDC%''and RELEASE_CYCLES.RCYC_NAME not like ''%UAT%''and RELEASE_CYCLES.RCYC_NAME not like ''codigo'')
      or RELEASE_CYCLES.RCYC_NAME is null)
--AND REQ.RQ_USER_04 not in (''Cancelado'',''Cerrado'')
AND REQ.RQ_USER_39 not in (''Incompleto'')
--AND RELEASES.rel_name is not null
--AND RQ_REQ_ID = ''8009''
ORDER by REQ.RQ_REQ_ID



'; end loop;

execute immediate  'insert into ALM_REPORT.INCIDENTES_QA 
select * from INCIDENTES_QA@SERVER_BCH
';

end;

/
