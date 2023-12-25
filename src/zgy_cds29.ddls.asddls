@AbapCatalog.sqlViewName: 'ZGY_CDS29'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'call table function'
define view zgy_DDL29
  as select from zgy_cds28(p_order_type : 'ARAC')
{
  prod_order,
  order_type

}
