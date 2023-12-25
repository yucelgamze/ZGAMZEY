@AbapCatalog.sqlViewName: 'ZGY_CDS12'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'zgy_cds12'
define view zgy_DDL12 as select from e070 
left outer join zgy_DDL13 
    on e070.trkorr = zgy_DDL13.trkorr
{
    key e070.as4user,
    count( * ) as total_count,
    sum( zgy_DDL13.total_object ) as total_object
}
group by as4user 
 