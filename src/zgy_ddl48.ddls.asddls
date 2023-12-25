@AbapCatalog.sqlViewName: 'ZGY_CDS48'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Access Control'
define view ZGY_DDL48
  as select from mara
{
  key matnr,
      meins,
      matkl,
      mtart
} 
 