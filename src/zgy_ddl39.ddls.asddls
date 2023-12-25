@AbapCatalog.sqlViewName: 'ZGY_CDS39'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Joins 2'
define view ZGY_DDL39
  as select from    zgy_egt_table1 as dbt1
    left outer join zgy_egt_table2 as dbt2 on dbt1.col1 = dbt2.col1
{
  dbt1.col1 as t1_col,
  dbt2.col1 as t2_col
} 
 