@EndUserText.label: 'table function'
define table function zgy_cds28
  with parameters
 p_order_type : auart
returns
{
  client     : abap.clnt;
  prod_order : aufnr;
  order_type : auart;

}
implemented by method
  zgy_class_tf=>get_order_details;
  
