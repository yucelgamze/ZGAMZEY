@AbapCatalog.sqlViewName: 'zgy_cds54'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'odata service'
@OData.publish: true
define view zgy_ddl54
  as select from vbak
{
  key vbeln,
      erdat,
      erzet,
      auart
} 
 