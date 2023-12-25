@AbapCatalog.sqlViewName: 'ZGY_CDS11'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'zgy_cds11'
define view zgy_ddl11
  as select from zgy_DDL10 as Z
    inner join   t179t     as T on  (
        Z.zkdm1                             = T.prodh
        or Z.zkdm2                          = T.prodh
        or Z.zkdm3                          = T.prodh
      )
                                and T.spras = 'T'
{
  ltrim(matnr, '0') as matnr,
  T.prodh,
  case length(T.prodh)
  when 5 then 'K1'
  when 10 then 'K2'
  when 18 then 'K3'
  end               as kdmno,
  T.vtext
} 
 