@AbapCatalog.sqlViewName: 'ZGY_CDS46'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Parameters'
define view ZGY_DDL46
    with parameters p_meins : meins,
                    p_mtart : mtart
as select from mara
{
    matnr,
    matkl,
    mtart
} 
where meins = $parameters.p_meins
and   mtart = $parameters.p_mtart
 