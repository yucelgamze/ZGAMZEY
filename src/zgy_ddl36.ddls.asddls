@AbapCatalog.sqlViewName: 'ZGY_CDS36'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cast Function'
define view ZGY_DDL36
  as select from zgy_t_stok
{
  alt_malzeme,
  stok_miktari,
  cast(stok_miktari as abap.char( 20 ))   as miktar_c,
  cast(stok_miktari as abap.dec( 10, 2 )) as miktar_d,
  '20200103'                              as miktar_date1,
  cast('20200103' as abap.dats)           as miktar_date2
} 
 