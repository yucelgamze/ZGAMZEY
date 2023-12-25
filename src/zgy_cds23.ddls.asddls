@AbapCatalog.sqlViewName: 'zgy_cds23'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'zgy_cds23'
define view zgy_ddl23 
with parameters p_mtype : mtart
as select from zgy_ddl19( p_mtype: $parameters.p_mtype , p_mgroup: 'A3001' )
{
    //ZGY_DDL19 INPUT
    matnr,
    mtart,
    matkl,
    ntgew
} 
 