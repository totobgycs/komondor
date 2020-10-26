CREATE PROCEDURE GET_OPTION_STR (
    OPTION_ID VARCHAR(10))
RETURNS (
    RESULT VARCHAR(50))
AS
begin
  select o.string_value
    from s_options o
    where o.option_id = :option_id
    into :result;
  suspend;
end