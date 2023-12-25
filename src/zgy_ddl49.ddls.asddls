@AbapCatalog.sqlViewName: 'ZGY_CDS49'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'OData Service'
@OData.publish: true
define view ZGY_DDL49
  as select from mara
{
  key matnr,
      meins,
      matkl,
      mtart
} 

// SAP GUI'DE /N/IWFN/MAINT_SERVICE
 