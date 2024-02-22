@AbapCatalog.sqlViewName: 'zgy_cds_0007'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Inner Join'
define view zgy_ddl_0007
  as select from    zgy_egt_table1 as t1
    inner join zgy_egt_table2 as t2 on t1.col1 = t2.col1    // ortak olanları getirir
{
  t1.col1 as t1_col,
  t2.col1 as t2_col
} 
 