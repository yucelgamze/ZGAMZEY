@AbapCatalog.sqlViewName: 'zgy_cds_0017'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Access Control'
define view zgy_ddl_0017
  as select from mara
{
  matnr,
  meins,
  matkl,
  mtart
}

//  @AccessControl.authorizationCheck: #CHECK değilde not_allowed olursa yapılan access control etkisiz olur 
 