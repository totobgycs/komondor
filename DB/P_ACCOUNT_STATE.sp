CREATE PROCEDURE P_ACCOUNT_STATE (
    END_DATE DATE)
RETURNS (
    ACCOUNT VARCHAR(10),
    ACC_DESCR VARCHAR(50),
    ACC_BALANCE NUMERIC(15,2),
    HC_BALANCE NUMERIC(15,2),
    CALC_RATE NUMERIC(15,6))
AS
begin
  for select a.account, a.name, sum(o.acc_income-o.acc_payment),
      sum(o.hc_income-o.hc_payment)
    from t_operation o
      join t_account a on o.account=a.account
      join t_transaction t on o.trans_id=t.trans_id
    where t.trans_date<=:end_date
    group by a.account, a.name
    into :account, :acc_descr, :acc_balance, :hc_balance do
      begin
      if (hc_balance <> 0) then
        calc_rate = acc_balance/hc_balance;
      suspend;
      end
end