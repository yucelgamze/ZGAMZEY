@AbapCatalog.sqlViewName: 'ZGY_CDS_0001'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Date definition language'
define view zgy_V_0001
  as select from mara
{
  matnr,
  meins,
  mtart,
  matkl
} 
 where meins = 'ST' 
 