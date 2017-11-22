--------------------------------------------------------
--  DDL for Procedure CARGAR_HIS_INC
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ALM_REPORT"."CARGAR_HIS_INC" AS 
BEGIN
execute immediate 'delete from hist_incidentes
where PERÍODO = TO_DATE(''01/''||TO_CHAR(SYSDATE,''mm'')||TO_CHAR(SYSDATE,''YYYY''),''dd/mm/yyyy'')
';

execute immediate  'insert into ALM_REPORT.HIST_INCIDENTES 
select
TO_DATE(''01/''||TO_CHAR(SYSDATE,''mm'')||TO_CHAR(SYSDATE,''YYYY''),''dd/mm/yyyy'') as Periodo,
count(a.rq_req_id) as CREADO,
  (select
  count(a.rq_req_id)
  from
  bch_qa_certificación_bch_qa_d.hist_req a
  where
  (a.rq_user_39<>(select x.rq_user_39 from bch_qa_certificación_bch_qa_d.hist_req x where x.rq_req_id=a.rq_req_id and x.RQ_VC_VERSION_NUMBER=(a.RQ_VC_VERSION_NUMBER-1)) or a.RQ_VC_VERSION_NUMBER=1)
  and (select n.rq_type_id from bch_qa_certificación_bch_qa_d.REQ n where a.rq_req_id = n.rq_req_id) in (102,116,121,124,125,113)
  and a.rq_user_04 = ''Ingresado''
  and TO_DATE(a.rq_vts, ''yyyy-mm-ddHH24:mi:ss'') >= TO_DATE(''01/''||TO_CHAR(SYSDATE,''mm'')||TO_CHAR(SYSDATE,''YYYY''),''dd/mm/yyyy'')   AND
  TO_DATE(a.rq_vts, ''yyyy-mm-ddHH24:mi:ss'') <= TO_DATE(to_char(last_day(SYSDATE),''dd'')||''/''||TO_CHAR(SYSDATE,''mm'')||''/''||TO_CHAR(SYSDATE,''YYYY''), ''dd/mm/yyyy'')
  )as INGRESADO,
  
  (select
  count(a.rq_req_id)
  from
  bch_qa_certificación_bch_qa_d.req a
  where
  (a.rq_user_39<>(select x.rq_user_39 from bch_qa_certificación_bch_qa_d.hist_req x where x.rq_req_id=a.rq_req_id and x.RQ_VC_VERSION_NUMBER=(a.RQ_VC_VERSION_NUMBER-1)) or a.RQ_VC_VERSION_NUMBER=1)
  and (select n.rq_type_id from bch_qa_certificación_bch_qa_d.REQ n where a.rq_req_id = n.rq_req_id) in (102,116,121,124,125,113)
  and a.rq_user_04 in(''Finalizado'',''Cerrado'')
  and TO_DATE(a.rq_vts, ''yyyy-mm-ddHH24:mi:ss'') >= TO_DATE(''01/''||TO_CHAR(SYSDATE,''mm'')||TO_CHAR(SYSDATE,''YYYY''),''dd/mm/yyyy'')   AND
  TO_DATE(a.rq_vts, ''yyyy-mm-ddHH24:mi:ss'') <= TO_DATE(to_char(last_day(SYSDATE),''dd'')||''/''||TO_CHAR(SYSDATE,''mm'')||''/''||TO_CHAR(SYSDATE,''YYYY''), ''dd/mm/yyyy'')
  )as CERRADO,  
  
  (select
count(a.rq_req_id)
from
bch_qa_certificación_bch_qa_d.hist_req a
where
(a.rq_user_39<>(select x.rq_user_39 from bch_qa_certificación_bch_qa_d.hist_req x where x.rq_req_id=a.rq_req_id and x.RQ_VC_VERSION_NUMBER=(a.RQ_VC_VERSION_NUMBER-1)) or a.RQ_VC_VERSION_NUMBER=1)
and (select n.rq_type_id from bch_qa_certificación_bch_qa_d.REQ n where a.rq_req_id = n.rq_req_id) in (102,116,121,124,125,113)
and a.rq_user_04 = ''Cancelado''
and TO_DATE(a.rq_vts, ''yyyy-mm-ddHH24:mi:ss'') >= TO_DATE(''01/''||TO_CHAR(SYSDATE,''mm'')||TO_CHAR(SYSDATE,''YYYY''),''dd/mm/yyyy'')   AND
TO_DATE(a.rq_vts, ''yyyy-mm-ddHH24:mi:ss'') <= TO_DATE(to_char(last_day(SYSDATE),''dd'')||''/''||TO_CHAR(SYSDATE,''mm'')||''/''||TO_CHAR(SYSDATE,''YYYY''), ''dd/mm/yyyy'')
)as CANCELADO,
  
(select
  count(count(a.rq_req_id))
  from
  bch_qa_certificación_bch_qa_d.hist_req a
  where
  (a.rq_user_39<>(select x.rq_user_39 from bch_qa_certificación_bch_qa_d.hist_req x where x.rq_req_id=a.rq_req_id and x.RQ_VC_VERSION_NUMBER=(a.RQ_VC_VERSION_NUMBER-1)) or a.RQ_VC_VERSION_NUMBER=1)
  and (select n.rq_type_id from bch_qa_certificación_bch_qa_d.REQ n where a.rq_req_id = n.rq_req_id) in (102,116,121,124,125,113)
  and a.rq_user_04 not in (''Cerrado'',''Finalizado'',''Cancelado'')
  and TO_DATE(a.rq_vts, ''yyyy-mm-ddHH24:mi:ss'') >= TO_DATE(''01/''||TO_CHAR(SYSDATE,''mm'')||TO_CHAR(SYSDATE,''YYYY''),''dd/mm/yyyy'')   AND
  TO_DATE(a.rq_vts, ''yyyy-mm-ddHH24:mi:ss'') <= TO_DATE(to_char(last_day(SYSDATE),''dd'')||''/''||TO_CHAR(SYSDATE,''mm'')||''/''||TO_CHAR(SYSDATE,''YYYY''), ''dd/mm/yyyy'')
  group by a.rq_req_id)as BACKLOG  
  
from
bch_qa_certificación_bch_qa_d.hist_req a
where
(a.rq_user_39<>(select x.rq_user_39 from bch_qa_certificación_bch_qa_d.hist_req x where x.rq_req_id=a.rq_req_id and x.RQ_VC_VERSION_NUMBER=(a.RQ_VC_VERSION_NUMBER-1)) or a.RQ_VC_VERSION_NUMBER=1)
and (select n.rq_type_id from bch_qa_certificación_bch_qa_d.REQ n where a.rq_req_id = n.rq_req_id) in (102,116,121,124,125,113)
and a.rq_user_04 = ''Creado''
and a.rq_user_39 = ''Incompleto''
and TO_DATE(a.rq_vts, ''yyyy-mm-ddHH24:mi:ss'') >= TO_DATE(''01/''||TO_CHAR(SYSDATE,''mm'')||TO_CHAR(SYSDATE,''YYYY''),''dd/mm/yyyy'')   AND
TO_DATE(a.rq_vts, ''yyyy-mm-ddHH24:mi:ss'') <= TO_DATE(to_char(last_day(SYSDATE),''dd'')||''/''||TO_CHAR(SYSDATE,''mm'')||''/''||TO_CHAR(SYSDATE,''YYYY''), ''dd/mm/yyyy'')
group by sysdate


';
 
END;

/
