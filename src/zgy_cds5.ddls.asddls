@AbapCatalog.sqlViewName: 'ZGY_CDS5'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'zgy_cds5'
define view zgy_DDL5
  with parameters
    p_islem : abap.char( 1 ),
    p_sayi  : abap.int1
  as select from ekpo
{
  ebeln,
  ebelp,
  menge,
  $parameters.p_sayi  as zsayi,
  $parameters.p_islem as zislem,
  case $parameters.p_islem
  when '+' then
  menge +  $parameters.p_sayi
  when '-' then
  menge -  $parameters.p_sayi
  when '*' then
  menge *  $parameters.p_sayi
  end                 as zsonuc

} 
 