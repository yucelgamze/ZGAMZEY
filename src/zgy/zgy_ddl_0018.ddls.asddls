@AbapCatalog.sqlViewName: 'zgy_cds_0018'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ODATA service'

@OData.publish: true

define view zgy_ddl_0018
  as select from mara
{
  key matnr,
      meins,
      matkl,
      mtart
} 
 