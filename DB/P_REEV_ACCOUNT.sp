CREATE PROCEDURE P_REEV_ACCOUNT (
    ACCOUNT VARCHAR(10),
    FOR_DATE DATE)
AS
declare variable rate numeric(15,6);
declare variable acc_bal numeric(15,2) = 0;
declare variable hc_bal numeric(15,2) = 0;
declare variable trans_id varchar(10);
declare variable currency char(3) = 'EUR';
begin
  select r.rate, r.currency
    from p_rates r
      join t_account a on a.currency=r.currency
    where a.account = :account
    into :rate, :currency;
  if (rate <> 1) then
    begin
    select s.acc_balance, s.hc_balance
      from p_account_state(:for_date) s
      where s.account = :account
      into :acc_bal, :hc_bal;
    if ((acc_bal <> 0) and (hc_bal<>0) ) then
      begin
      trans_id = gen_id(gen_transaction, 1);
      insert into t_transaction(trans_id, trans_date, trans_desc)
        values(:trans_id, :for_date, 'Átértékelés');
      insert into t_operation (trans_id, currency, payment, account,
          cp_ident, acc_payment, hc_payment, project)
        values (:trans_id, :currency, :acc_bal, :account,
          88, :acc_bal, :hc_bal, '-');
      insert into t_operation (trans_id, currency, INCOME, account,
          cp_ident, acc_income, hc_income, project)
        values (:trans_id, :currency, :acc_bal, :account,
          88, :acc_bal, :acc_bal/:rate, '-');
      end
    end
end