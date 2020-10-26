CREATE PROCEDURE P_REPLAN_MONTH (
    ACT_MONTH VARCHAR(10))
AS
declare variable income numeric(15,2) = 0;
declare variable payment numeric(15,2) = 0;
declare variable debid varchar(10);
begin
  execute procedure p_plan_month(act_month);
  for select g.gendebid, g.acc_income, g.acc_payment
    from t_gen_debits g into :debid, :income, :payment do
      update t_act_debits set acc_income = :income, acc_payment = :payment
        where actdebid=:debid and act_month=:act_month;
end