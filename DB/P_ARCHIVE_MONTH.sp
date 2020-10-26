CREATE PROCEDURE P_ARCHIVE_MONTH (
    P_FROM DATE,
    P_TO DATE)
AS
declare variable v_trans_id d_ident;
begin
  insert into a_transaction select t.* from t_transaction t
    where t.trans_date between :p_from and :p_to;
  insert into a_operation select o.* from t_operation o
    join t_transaction t on t.trans_id=o.trans_id
    where t.trans_date between :p_from and :p_to;
  insert into a_oper_add select a.* from t_oper_add a
    join t_operation o on o.operation=a.operation
    join t_transaction t on t.trans_id=o.trans_id
    where t.trans_date between :p_from and :p_to;

  insert into t_transaction (trans_id, trans_date, trans_desc, lastmod)
    values (gen_id(gen_transaction,1), :p_to,
      'Archived ' /*|| cast(:p_from as char) || '-' || cast(:p_to as char)*/,
      cast('NOW' as date)) returning trans_id into :v_trans_id;

  insert into t_operation (operation, trans_id, currency, income, payment,
      account, cp_ident, blabla, acc_income, acc_payment, acc_rate,
      hc_income, hc_payment, hc_rate, actmonth, project)
    select gen_id(gen_operation,1), :v_trans_id, currency, income, payment,
        account, cp_ident, 'arch', acc_income, acc_payment, 0,
        hc_income, hc_payment, 0, actmonth, project
  from (
    select o.currency, o.account, o.cp_ident,o.actmonth,o.project,
        sum(o.income) income, sum(o.payment) payment,
        sum(o.acc_income) acc_income, sum(o.acc_payment) acc_payment,
        sum(o.hc_income) hc_income, sum(o.hc_payment) hc_payment
      from t_operation o join t_transaction t on o.trans_id=t.trans_id
      where t.trans_date between :p_from and :p_to
      group by o.currency, o.account, o.cp_ident,o.actmonth,o.project);


  delete from t_oper_add t where t.oper_add_id in (
    select a.oper_add_id from a_oper_add a);
  delete from t_operation o where o.operation in (
    select a.operation from a_operation a);
  delete from t_transaction t where t.trans_id in (
    select a.trans_id from a_transaction a);

end