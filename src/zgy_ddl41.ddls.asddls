@AbapCatalog.sqlViewName: 'ZGY_CDS41'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'cross join'
define view ZGY_DDL41
  as select from zgy_egt_table1 as dbt1
    cross join   zgy_egt_table2 as dbt2
{
  dbt1.col1 as t1_col,
  dbt2.col1 as t2_col
}
//cross join de kartezyen çarpım şeklinde eşleştirme yapılır 
 