@AbapCatalog.sqlViewName: 'ZGY_CDS6'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'zgy_cds6'
define view zgy_DDL6 as select from nsdm_v_mseg
{
    mblnr,
    mjahr,
    zeile,
    lgort,
    matnr,
    meins,
    case
    when 
    bwart = '101' then menge
    when
    bwart = '102' then menge * -1
    end as zfark
}
where bwart = '101' or
      bwart = '102' 
 