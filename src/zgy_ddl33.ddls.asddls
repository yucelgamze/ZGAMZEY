@AbapCatalog.sqlViewName: 'ZGY_CDS33'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Numeric Functions'
define view ZGY_DDL33
  as select from zgy_t_stok
{
  alt_malzeme,
  stok_miktari,
  round(stok_miktari,2)      as miktar_round,
  ceil(stok_miktari)         as miktar_ceil,
  floor(stok_miktari)        as miktar_floor,
  div(stok_miktari,5)        as miktar_div,
  division(stok_miktari,5,3) as miktar_division,
  mod(ceil(stok_miktari),5)  as miktar_mod,
  abs(stok_miktari)          as miktar_abs,
  stok_miktari + 5           as miktar_add,
  stok_miktari - 5           as miktar_sub,
  stok_miktari * 5           as miktar_mul
}
// round -> yanındaki rakam kadar yuvalar
// ceil -> yukarı tam sayı yuvarlar
// floor -> aşağı tam sayı yuvarlar
// div -> yanndaki sayıya bölümü
// division -> yanındaki sayıya bölümü ve virgülden sonra kaç sayı
// mod -> yanındaki sayı kadar mod alma
// abs -> mutlak değer 
 