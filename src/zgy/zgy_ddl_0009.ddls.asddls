@AbapCatalog.sqlViewName: 'zgy_cds_0009'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Right Outer Join'
define view zgy_ddl_0009
  as select from    zgy_egt_table1 as t1
   right outer join zgy_egt_table2 as t2 on t1.col1 = t2.col1   // ikinciyi alıp birincide eşleşenleri getirir
{
  t1.col1 as t1_col,
  t2.col1 as t2_col
}  
 