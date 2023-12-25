@AbapCatalog.sqlViewName: 'ZGY_CDS13'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'zgy_cds13'
define view zgy_DDL13 as select from e071
    
{
    key  trkorr,
    count( * ) as total_object
}
group by trkorr 
 