CREATE PROCEDURE P_LAST_CAR_OPER
RETURNS (
    DESCR VARCHAR(50),
    TRANS_DATE DATE,
    KM INTEGER)
AS
declare "Last_rec" cursor for (select t.trans_date, oa.km
    from t_oper_add oa join t_transaction t on oa.trans_id=t.trans_id
    order by t.trans_date desc, oa.km desc,  oa.operation desc);
declare "Last_fill" cursor for (select t.trans_date, oa.km
    from t_oper_add oa join t_transaction t on oa.trans_id=t.trans_id
    where oa.fulltank='T'
    order by t.trans_date desc, oa.km desc, oa.operation desc);
begin
  descr = 'Utolsó bejegyzés';
  open "Last_rec";
  fetch "Last_rec" into :trans_date, :km;
  suspend;
  descr = 'Utolsó teletank';
  open "Last_fill";
  fetch "Last_fill" into :trans_date, :km;
  suspend;
end