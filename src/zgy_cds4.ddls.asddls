@AbapCatalog.sqlViewName: 'ZGY_CDS4'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'zgy_cds4'
define view zgy_DDL4 as select from zgy_dil
{
    key userid,
    concat(concat(concat(concat(ing,fra),rus),ita),isp) as zdilx,
    length(concat(concat(concat(concat(ing,fra),rus),ita),isp)) as zdil
} 
 