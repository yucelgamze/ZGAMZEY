@AbapCatalog.sqlViewName: 'ZGY_CDS42'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Union Views'
define view ZGY_DDL42
  as select from zgy_egt_table1 as dbt1
{
  col1 as union_column
}
where
  col1 > 10

union all select from zgy_egt_table2 as dbt2
{
  col1 as union_column
}
where
  col1 < 10

union all select from zgy_egt_table3 as dbt3
{
  col2 as union_column
}
// union da çekilen kolon isimleri her tabloda aynı olmalıdır
// ve toplam kolon sayısı aynı olmalıdır
// aynı isimde değilseler alias ise as denilip ortak isim verilir  
// union all yerine sadece union denilirse aynı olan kayıtları getirmez 
 