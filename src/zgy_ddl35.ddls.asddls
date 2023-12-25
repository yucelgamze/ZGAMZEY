@AbapCatalog.sqlViewName: 'ZGY_CDS35'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Date Function'
define view ZGY_DDL35
  as select from zgy_t_pers
{

  pers_no,
  birth_date,
  dats_is_valid(birth_date)                                    as date_isvalid1,
  dats_is_valid(cast('20220609' as abap.dats))                 as date_isvalid2,
  dats_is_valid(cast('01234567' as abap.dats))                 as date_isvalid3,
  dats_days_between(birth_date, cast('20200101' as abap.dats)) as date_daysbetween,
  dats_add_days(birth_date,10,'NULL')                          as date_adddays1,
  dats_add_days(birth_date,-10,'NULL')                         as date_adddays2,
  dats_add_months(birth_date,2,'NULL')                         as date_addmonth1,
  dats_add_months(birth_date,-2,'NULL')                        as date_addmonth2
}

// dats_is_valid     -> geçerlilik kontrolü. (0 1)
// dats_days_between -> iki tarih arasındaki fark
// dats_add_days     -> gün ekleme
// dats_add_days     -> gün çıkarma
// dats_add_months   -> ay ekleme
// dats_add_months   -> ay çıkarma  
 