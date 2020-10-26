CREATE TRIGGER T_OPER_ADD_BI0 FOR T_OPER_ADD
ACTIVE BEFORE INSERT POSITION 0
AS
begin
  new.oper_add_id = gen_id(gen_oper_add, 1);
end
^