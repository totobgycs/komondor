CREATE TRIGGER T_OPERATION_BIU0 FOR T_OPERATION
ACTIVE BEFORE INSERT OR UPDATE POSITION 10
AS
begin
  if (abs(NEW.hc_payment) > 0.001) then
    begin
    NEW.hc_rate = NEW.payment/NEW.hc_payment;
    NEW.acc_rate = NEW.acc_payment/NEW.hc_payment;
    end
  if (abs(NEW.hc_income) > 0.001) then
    begin
    NEW.hc_rate = NEW.income/NEW.hc_income;
    NEW.acc_rate = NEW.acc_income/NEW.hc_income;
    end
end
^