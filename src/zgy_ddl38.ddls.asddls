@AbapCatalog.sqlViewName: 'ZGY_CDS38'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Joins'
define view ZGY_DDL38
  as select from zgy_egt_table1 as dbt1
    inner join   zgy_egt_table2 as dbt2 on dbt1.col1 = dbt2.col1
{
  dbt1.col1 as t1_col,
  dbt2.col1 as t2_col
} 
 