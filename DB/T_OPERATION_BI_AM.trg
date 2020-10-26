CREATE TRIGGER T_OPERATION_BI_AM FOR T_OPERATION
ACTIVE BEFORE INSERT POSITION 5
AS
begin
  if (new.actmonth is null) then
    select string_value from s_options
      where OPTION_id='ACTMONTH' into new.actmonth;
end
^