CREATE PROCEDURE P_PLAN_MONTH (
    ACT_MONTH VARCHAR(10))
AS
begin
  insert into t_act_debits (actdebid, act_month, description, cp_ident, account, acc_income, acc_payment)
    select gendebid, :act_month, description, cp_ident, account, acc_income, acc_payment
      from t_gen_debits g
      where not exists (select * from t_act_debits a
        where a.actdebid = g.gendebid and a.act_month = :act_month);
end