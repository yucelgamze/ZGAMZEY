@AbapCatalog.sqlViewName: 'zgy_cds32'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'call table function 2'
define view zgy_ddl32
  as select from zgy_tf1(p_order_type : 'ARAC') as _order
    inner join   afko    as _order_header on _order.prod_order = _order_header.aufnr
{
  _order.prod_order,
  _order.order_type,
  _order.routing,
  _order.counter,
  cast('MIN' as vgwrteh) as UOM,
  //annotation
  @Semantics.amount.currencyCode: 'UOM'
  _order.std_value_1,
  @Semantics.amount.currencyCode: 'UOM'
  _order.std_value_2,
  _order_header.aprio
       

} 
 