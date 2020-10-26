CREATE PROCEDURE P_ACCOUNTLIST (
    P_ACCOUNT VARCHAR(10),
    P_FROM DATE,
    P_TO DATE)
RETURNS (
    TRANS_ID VARCHAR(10),
    TRANS_DATE DATE,
    ACCOUNT VARCHAR(10),
    INC NUMERIC(15,2),
    PAY NUMERIC(15,2),
    ACC_INC NUMERIC(15,2),
    ACC_PAY NUMERIC(15,2),
    ACC_BAL NUMERIC(12,2),
    HC_INC NUMERIC(15,2),
    HC_PAY NUMERIC(15,2),
    HC_BAL NUMERIC(15,2))
AS
declare variable cnt integer;
begin
  select 'Nyit', :p_from, o.account,
      sum(o.income), sum(o.payment),
      sum(o.acc_income), sum(o.acc_payment),
      sum(o.hc_income), sum(o.hc_payment),
      count(*)
    from t_operation o join t_transaction t on o.TRANS_ID =t.TRANS_ID
    where t.trans_date < :p_from
      and o.account = :p_account
    group by o.account
    into TRANS_ID, TRANS_DATE, ACCOUNT,
      INC, PAY, acc_INC, acc_PAY, hc_INC, hc_PAY, CNT;
  if (CNT > 0) then
    begin
    acc_BAL = acc_INC - acc_PAY;
    hc_BAL = hc_INC - hc_PAY;
    suspend;
    end
  else
    begin
    acc_BAL = 0;
    hc_BAL = 0;
    end
  for select o.TRANS_ID, t.trans_date, o.account,
        sum(o.income) as inc, sum(o.payment) as pay,
        sum(o.acc_income), sum(o.acc_payment),
        sum(o.hc_income), sum(o.hc_payment)
      from t_operation o join t_transaction t on o.TRANS_ID =t.TRANS_ID
      where t.trans_date between :p_from and :p_to
        and o.account = :p_account
      group by o.account, t.trans_date, o.TRANS_ID
      order by t.trans_date asc, 4 desc, 5 desc
      into TRANS_ID, TRANS_DATE, ACCOUNT,
        INC, PAY, acc_INC, acc_PAY, hc_INC, hc_PAY do
    begin
      acc_BAL = acc_BAL + acc_INC - acc_PAY;
      hc_BAL = hc_BAL + hc_INC - hc_PAY;
      suspend;
    end
end