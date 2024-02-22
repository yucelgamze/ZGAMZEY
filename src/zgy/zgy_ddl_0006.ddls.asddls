@AbapCatalog.sqlViewName: 'zgy_cds_0006'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Aggregate Functions'
define view zgy_ddl_0006
  as select from zgy_t_0023
{
  vbeln,
  max(kwmeng)            as kwmeng_max,
  min(kwmeng)            as kwmeng_min,
  sum(kwmeng)            as kwmeng_sum,
  count(*)               as kwmeng_count,
  count(distinct kwmeng) as kwmeng_count_distinct
}
group by
  vbeln



// Max
// Min
// Sum
// Avg
// Count
// Count(Distinct) 
 