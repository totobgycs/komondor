CREATE PROCEDURE P_RATES
RETURNS (
    CURRENCY CHAR(3),
    RATE NUMERIC(15,6),
    ROUNDING SMALLINT)
AS
begin
  for select currency, rounding from t_currencies
      into :currency, :rounding do
    begin
      select rate from t_curr_rates r1
        where r1.currency = :currency
          and r1.rate_DATE = (select max(r2.rate_DATE)
             from t_curr_rates r2 where r2.currency = :currency)
        into :rate;
      suspend;
    end
end