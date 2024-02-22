@AbapCatalog.sqlViewName: 'zgy_cds_0003'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'String Functions'
define view zgy_ddl_0003
  as select from zgy_t_0021
{
  hello,
  dil,
  concat(hello,dil)              as concat_cols1,
  concat(concat(hello,','),dil)  as concat_cols2,
  concat_with_space(hello,dil,3) as concatws_cols,
  substring(dil,2,3)             as substring_cols,
  length(dil)                    as length_col,
  left(dil,2)                    as left_col,
  right(dil,2)                   as right_col,
  ltrim(dil,'A')                 as ltrim_col,
  rtrim(dil,'P')                 as rtrim_col
}



// concat               birleştirir
// concat_with_space    boşluklu birleştirir
// substring            parça alma
// length               uzunluk
// left                 soldan karakter alır
// right                sağdan karakter alır
// ltrim                soldan eşleşen karakteri sil genelde boşluk
// rtrim                sağdan eşleşen karakteri sil genelde boşluk  
 