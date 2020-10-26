CREATE PROCEDURE P_ACTIVATE_PERIODE (
    PERID VARCHAR(10))
AS
declare variable state char(1);
begin
  select p.state from s_periods p where p.peropdid=:perid into :state;
  if (state = 'P') then
    begin
    update s_periods p set p.state='P' where p.state = 'A';
    update s_periods p set p.state='A' where p.peropdid = :perid;
    update s_options o set o.string_value=:perid where o.option_id = 'ACTMONTH';
    end
end