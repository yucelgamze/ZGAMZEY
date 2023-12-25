@AbapCatalog.sqlViewName: 'ZGY_CDS1'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'cds1'
define view zgy_DDL1
  as select from vbap
{
  vbeln,
  cast('A' as abap.char( 2 )) as ztext,
  @Semantics.quantity.unitOfMeasure: 'MEINS'
  sum( kwmeng ) as sum_menge,
  cast(min( kwmeng ) as zmin_ga ) as min_menge,
  max( kwmeng ) as max_menge,
  avg( netpr as abap.curr( 11, 2 ) )  as avg_netpr,
  @Semantics.unitOfMeasure: 'MEINS'
  meins

}
group by
  vbeln,
  meins 
 