@AbapCatalog.sqlViewName: 'ZGY_CD51'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Casting of Data Elements'
define view ZGY_DDL51
  as select from mara
{
  matnr,
  '1000000011'                 as m1,
  cast( '1000000011'as matnr ) as m2
} 
 