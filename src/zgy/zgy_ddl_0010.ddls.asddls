@AbapCatalog.sqlViewName: 'zgy_cds_0010'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cross Join'
define view zgy_ddl_0010
  as select from    zgy_egt_table1 as t1
   cross join zgy_egt_table2 as t2  // çaprazlama yapıyor
{
  t1.col1 as t1_col,
  t2.col1 as t2_col
}  
 