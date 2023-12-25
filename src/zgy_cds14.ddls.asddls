@AbapCatalog.sqlViewName: 'ZGY_CDS14'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'zgy_cds14'
define view zgy_DDL14
  as select from    mara        as main
    left outer join nsdm_v_mard as m1 on  main.matnr = m1.matnr
                                      and m1.werks   = '1000'
    left outer join nsdm_v_mard as m2 on  main.matnr = m2.matnr
                                      and m2.werks   = '2700'
{
  // ilk listelenecek eleman matnr seçiliyor
  main.matnr,

  m1.werks                     as m1_wekrs,
  m1.lgort                     as m1_lgort,
  m1.labst                     as m1_labst,

  m2.werks                     as m2_werks,
  m2.lgort                     as m2_lgort,
  m2.labst                     as m2_labst,

  //   coalesce-> ilk argüman alan olarak yoksa ikinci argümanı listeler
  coalesce(m2.labst, m1.labst) as zstok
} 
 