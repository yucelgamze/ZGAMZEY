@AbapCatalog.sqlViewName: 'zgy_cds_0011'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Union Views'
define view zgy_ddl_0011
  as select from zgy_egt_table1
{
  col1 as union_column
}
where
  col1 > 10
union all select from zgy_egt_table2
{
  col1 as union_column
}
where
  col1 < 10
union all select from zgy_egt_table3
{
  col2 as union_column
}
//union da çekilen kolon isimleri her tabloda aynı olmalıdır
//ve toplam kolon sayısı aynı olmalıdır
//aynı isimde değilseler alias ise "as" denilip ortak isim verilir
//"union all" yerine sadece "union" denilirse aynı olan kayıtları getirmez

//join de yana kolon eklenirken
//union da alta satır eklenir 
 