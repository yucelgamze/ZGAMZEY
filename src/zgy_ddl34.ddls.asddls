@AbapCatalog.sqlViewName: 'ZGY_CDS34'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'String Functions'
define view ZGY_DDL34
  as select from zgy_t_langs
{
  col1,
  col2,
  concat(col1,col2)              as concat_cols,
  concat(concat(col1,','),col2)  as concat_cols2,
  concat_with_space(col1,col2,3) as cws_cols,
  substring(col2,2,3)            as substring_cols,
  length(col2)                   as length_col,
  left(col2,2)                   as left_col,
  right(col2,2)                  as right_col,
  ltrim(col2,'A')                as ltrim_col,
  rtrim(col2,'T')                as rtrim_col
}
// concat            -> birleştirir
// concat_with_space -> boşluklu birleştirme
// substring         -> parça alma
// length            -> uzunluk
// left              -> soldan karakter al
// right             -> sağdan karakter al
// ltrim             -> soldan eşleşen karakteri sil genelde boşluk
// rtrim             -> sağdan eşleşen karakteri sil genelde boşluk  
 