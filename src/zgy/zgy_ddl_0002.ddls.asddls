@AbapCatalog.sqlViewName: 'zgy_cds_0002'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Numeric Functions'
define view zgy_ddl_0002
  as select from zgy_t_0020
{
  matnr,
  miktar,
  round(miktar,1)      as miktar_round1,
  round(miktar,2)      as miktar_round2,
  ceil(miktar)         as miktar_ceil,
  floor(miktar)        as miktar_floor,
  div(miktar,5)        as miktar_div,
  division(miktar,3,2) as miktar_division,
  mod(ceil(miktar),10) as miktar_mod,
  miktar*-1            as miktar2,
  abs( miktar*-1 )     as miktar2_abs
}


// round     ->virgüldeki rakam  kadar yuvarlar
// ceil      ->yukarı tam sayı yuvarlar
// floor     ->aşağı tam sayı yuvarlar
// div       ->yanındaki sayıya böler
// division  ->yanındaki sayıya böler ve virgülden sonra kaç sayı
// mod       ->yanındaki sayı kadar mod alır
// abs       ->mutlak değer alır  
 