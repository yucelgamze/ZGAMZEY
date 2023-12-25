@AbapCatalog.sqlViewName: 'ZGY_CDS18'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'zgy_cds18'
define view zgy_ddl18
  as select from mara
  //Joins, associations
{
  key matnr as Material_Number,
  key matkl as Material_Group,
      brgew

}
// where condition  
 