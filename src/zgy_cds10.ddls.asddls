@AbapCatalog.sqlViewName: 'ZGY_CDS10'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'zgy_cds10'
define view zgy_DDL10 as select from zem_mara
{
    matnr,
    substring(prdha, 1, 5) as zkdm1,
    substring(prdha, 1, 10) as zkdm2,
    substring(prdha, 1, 18) as zkdm3
//    substring(prdha, 1, 8) as zkdm4

} 
 