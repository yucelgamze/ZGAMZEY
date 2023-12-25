@AbapCatalog.sqlViewName: 'ZGY_CDS8'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'zgy_cds8'
define view zgy_DDL8
  with parameters
    p_lgort : abap.char( 4 )
  as select from zgy_DDL7 (p_lgort: $parameters.p_lgort) as z
    inner join   makt                                    as m on z.matnr = m.matnr
                                                              and spras  = 'T'
{
    z.matnr,
    m.maktx,
    z.zfark
  } 
 