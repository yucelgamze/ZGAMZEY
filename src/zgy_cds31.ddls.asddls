@AbapCatalog.sqlViewName: 'zgy_cds31'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'call table function'
define view zgy_ddl31 as select from zgy_tf1(p_order_type : 'ARAC')
{
    prod_order,
    order_type
} 
 