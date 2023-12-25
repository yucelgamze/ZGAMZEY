@AbapCatalog.sqlViewName: 'ZGY_CDS47'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Extend View'
define view ZGY_DDL47
  as select from zgy_egt_table4 as t4
  association to zgy_egt_table5 as _t5 on _t5.pers_id = t4.pers_id
{
  t4.pers_id,
  t4.pers_ad,
  _t5.pers_depart
} 
 