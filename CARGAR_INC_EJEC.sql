--------------------------------------------------------
--  DDL for Procedure CARGAR_INC_EJEC
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ALM_REPORT"."CARGAR_INC_EJEC" AS 
BEGIN
 execute immediate 'TRUNCATE TABLE ALM_REPORT.INC_EJEC';
 
execute immediate  'insert into ALM_REPORT.INC_EJEC 

SELECT  --* /*
  CASE when SUBSTR(CF_ITEM_PATH,1 ,9) = ''AAAAACAAB'' then ''Continuidad'' else ''Mantención Productiva'' end "Carpeta",
  RN_RUN_ID "Id. Ejecución", --Ejecutar.Id. de ejecución
  RN_TESTCYCL_ID "Id. Instancia",
  RN_EXECUTION_DATE "Fecha Ejecución", --Ejecutar.Fecha de ejecución
  RN_TESTER_NAME "Tester",
  TS_USER_01 "Sistema", --Prueba.Sistema
  RN_SUBTYPE_ID "Tipo Ejecución", --Ejecutar.Tipo
  TS_TEST_ID "Id. CDP", --Prueba.Id. de prueba
  RN_STATUS "Estado Ejecución",
  SUBSTR(CF_ITEM_PATH,1 ,6) "Carpeta",
  CASE when SUBSTR(CF_ITEM_PATH,1 ,6) = ''AAAAAA'' then ''Regresión'' else ''Certificación'' end "Regresión",
  ''SERVIDOR TSOFT'' as Servidor,
  TS_USER_08 as "Proveedor"

FROM
  bch_qa_certificación_bch_qa_d.RUN
     JOIN bch_qa_certificación_bch_qa_d.CYCLE     ON RN_CYCLE_ID = CY_CYCLE_ID
     JOIN bch_qa_certificación_bch_qa_d.CYCL_FOLD ON CY_FOLDER_ID = CF_ITEM_ID
     JOIN bch_qa_certificación_bch_qa_d.TEST      ON RN_TEST_ID = TS_TEST_ID
WHERE
--to_char(RN_EXECUTION_DATE,''yyyy-mm'') >= ''2017-07'' --between ''2016-01-04'' and ''2016-01-21''
SUBSTR(CF_ITEM_PATH,1 ,6) in (''AAAAAC'')  
and RN_SUBTYPE_ID like ''%MANUAL''
and RN_STATUS is not null
and RN_STATUS not like ''%No Run''

UNION  ALL
SELECT  --* /*
  CASE when SUBSTR(CF_ITEM_PATH,1 ,9) = ''AAAAACAAB'' then ''Continuidad'' else ''Mantención Productiva'' end "Carpeta",
  RN_RUN_ID "Id. Ejecución", --Ejecutar.Id. de ejecución
  RN_TESTCYCL_ID "Id. Instancia",
  RN_EXECUTION_DATE "Fecha Ejecución", --Ejecutar.Fecha de ejecución
  RN_TESTER_NAME "Tester",
  TS_USER_01 "Sistema", --Prueba.Sistema
  RN_SUBTYPE_ID "Tipo Ejecución", --Ejecutar.Tipo
  TS_TEST_ID "Id. CDP", --Prueba.Id. de prueba
  RNI_STATUS "Estado Ejecución",
  SUBSTR(CF_ITEM_PATH,1 ,6) "Carpeta",
  CASE when SUBSTR(CF_ITEM_PATH,1 ,9) = ''AAAAAA'' then ''Regresión'' else ''Certificación'' end "Regresión",
  ''SERVIDOR TSOFT'' as Servidor,
  TS_USER_08 as "Proveedor"
  
FROM
  bch_qa_certificación_bch_qa_d.RUN
     JOIN bch_qa_certificación_bch_qa_d.CYCLE         ON RN_CYCLE_ID = CY_CYCLE_ID
     JOIN bch_qa_certificación_bch_qa_d.CYCL_FOLD     ON CY_FOLDER_ID = CF_ITEM_ID
     JOIN bch_qa_certificación_bch_qa_d.TEST          ON RN_TEST_ID = TS_TEST_ID
     JOIN bch_qa_certificación_bch_qa_d.RUN_ITERATIONS ON RN_RUN_ID = RNI_RUN_ID
WHERE
--to_char(RN_EXECUTION_DATE,''yyyy-mm'') >= ''2017-07'' --between ''2016-01-04'' and ''2016-01-21''
SUBSTR(CF_ITEM_PATH,1 ,6) in (''AAAAAC'')
and RN_SUBTYPE_ID not like ''%MANUAL''
and RN_STATUS is not null
and RN_STATUS not like ''%No Run''
'; 

execute immediate  'insert into ALM_REPORT.INC_EJEC 
select * from INC_EJEC@SERVER_BCH
';


end;

/
