CREATE TRIGGER T_OPERATION_BI0 FOR T_OPERATION
ACTIVE BEFORE INSERT POSITION 0
AS
begin
  if (new.operation is null) then
    new.operation = gen_id(gen_operation, 1);
end
^