@EndUserText.label: 'table function'
define table function zgy_tf1
  with parameters
    p_order_type : auart
returns
{
  client      : abap.clnt;
  prod_order  : aufnr;
  order_type  : auart;
  routing     : co_aufpl;
  counter     : co_aplzl;
  std_value_1 : vgwrt;
  std_value_2 : vgwrt;

}
implemented by method
  zgy_cl_tf=>get_order_details;
