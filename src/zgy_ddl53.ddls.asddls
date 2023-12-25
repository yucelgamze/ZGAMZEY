@AbapCatalog.sqlViewName: 'ZGY_CDS53'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'for OData'
@OData.publish: true
define view zgy_ddl53
  as select from zgy_t_draft
{

  key  bukrs as Bukrs,
  key  belnr as Belnr,
  key  gjahr as Gjahr,
       budat as Budat,
       bldat as Bldat,
       umskz as Umskz,
       shkzg as Shkzg,
       dmbtr as Dmbtr,
       wrbtr as Wrbtr,
       waers as Waers
} 
 