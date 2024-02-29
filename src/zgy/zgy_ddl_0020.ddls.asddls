@AbapCatalog.sqlViewName: 'zgy_cds_0020'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Casting of Data Elements'



define view zgy_ddl_0020
  as select from mara
{
  matnr,
  '10000000011'                  as mat1,
  cast( '10000000011' as matnr ) as mat2
} 
 