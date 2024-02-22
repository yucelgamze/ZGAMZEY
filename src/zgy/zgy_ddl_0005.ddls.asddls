@AbapCatalog.sqlViewName: 'zgy_cds_0005'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cast Function'
define view zgy_ddl_0005
  as select from zgy_t_0020
{
  matnr,
  miktar,
  cast(miktar as abap.char( 20 ))   as miktar_c,
  cast(miktar as abap.dec( 10, 2 )) as miktar_d,
  '20240214'                        as miktar_date,
  cast('20240214' as abap.dats)     as miktar_dat2
} 
 