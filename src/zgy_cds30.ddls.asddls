@AbapCatalog.sqlViewName: 'zgy_cds30'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'call table function 2'
define view zgy_ddl30 as select from zgy_cds28(p_order_type : 'ARAC') as _order
inner join afko as _order_header  on _order.prod_order = _order_header.aufnr
{
    _order.prod_order,
    _order.order_type,
    _order_header.aufpl
} 

 