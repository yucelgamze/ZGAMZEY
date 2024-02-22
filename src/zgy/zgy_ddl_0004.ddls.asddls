@AbapCatalog.sqlViewName: 'zgy_cds_0004'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Date Functions'
define view zgy_ddl_0004
  as select from zgy_t_0022
{
  pers_id,
  birth_date,
  dats_is_valid(birth_date)                                    as disvalid1,
  dats_is_valid(cast('20230717' as abap.dats))                 as disvalid2,
  dats_is_valid(cast('12345678' as abap.dats))                 as disvalid3,
  dats_days_between(birth_date, cast('20240219' as abap.dats)) as ddb,
  dats_add_days(birth_date,10,'NULL')                          as dad1,
  dats_add_days(birth_date,-10,'NULL')                         as dad2,
  dats_add_months(birth_date,2,'NULL')                         as dam1,
  dats_add_months(birth_date,2,'NULL')                         as dam2
}


// dats_is_valid        Geçerlilik kontrolü (0,1)
// dats_days_between    İki tarih arasındaki fark
// dats_add_days        Gün ekleme
// dats_add_days        Gün çıkarma
// dats_add_months      Ay ekleme
// dats_add_months      Ay çıkarma  
 