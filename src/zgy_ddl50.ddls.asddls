@AbapCatalog.sqlViewName: 'ZGY_CDS50'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sessions'
define view ZGY_DDL50
  as select from mara
{
  matnr,
  meins,
  matkl,
  mtart,
  $session.system_date     as sys_date,
  $session.client          as sys_client,
  $session.system_language as sys_lang,
  $session.user            as sys_user
}
//where ersda = $session.system_date  
 