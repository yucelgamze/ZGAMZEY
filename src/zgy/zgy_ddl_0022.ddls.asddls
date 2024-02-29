@AbapCatalog.sqlViewName: 'zgy_cds_0022'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ODATA service'

@OData.publish: true
define view zgy_ddl_0022
  as select from vbak
{
  key vbeln,
      erdat,
      erzet,
      auart
} 
 