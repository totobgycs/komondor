CREATE PROCEDURE P_REEV_CURRENCY (
    FOR_CURRENCY CHAR(3),
    FOR_DATE DATE)
AS
declare variable acc varchar(10);
begin
  for select a.account from t_account a
    where a.currency = :for_currency into :acc do
      execute procedure p_reev_account(acc, for_date);
end