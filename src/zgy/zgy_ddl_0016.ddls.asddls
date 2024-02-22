@AbapCatalog.sqlViewName: 'zgy_cds_0016'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'for Extend View'
define view zgy_ddl_0016
  as select from zgy_egt_table4 as t4
  association to zgy_egt_table5 as _t5 on t4.pers_id = _t5.pers_id
{
  t4.pers_id,
  t4.pers_ad,
  _t5.pers_depart
} 
 