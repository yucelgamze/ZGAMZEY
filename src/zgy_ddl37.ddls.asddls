@AbapCatalog.sqlViewName: 'ZGY_CDS37'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Aggregate Functions'
define view ZGY_DDL37
  as select from zgy_t_sip
{
  vbeln,
  //  posnr,
  //  kwmeng,
  max(kwmeng)            as kwmeng_max,
  min(kwmeng)            as kwmeng_min,
  sum(kwmeng)            as kwmeng_sum,
  avg(kwmeng)            as kwmeng_avg,
  count(*)               as kwmeng_count1,
  count(distinct kwmeng) as kwmeng_count2
}
group by
  vbeln // , posnr

//max -> en yükseği çeker
//min -> en düşüğü çeker
//sum -> key bazında verileri toplar
//avg -> ortalamasını alır
//count -> kaç satır var onu sayar
//count(distinct) -> aynı olan verileri sayma  
 