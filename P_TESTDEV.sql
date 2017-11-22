--------------------------------------------------------
--  DDL for Procedure P_TESTDEV
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ALM_REPORT"."P_TESTDEV" AS 
BEGIN
 EXECUTE immediate 'SELECT
   *
FROM
TEST_DEV TS';
END P_TESTDEV;

/
