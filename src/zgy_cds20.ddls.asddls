@AbapCatalog.sqlViewName: 'ZGY_CDS20'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'zgy_cds20'
define view zgy_DDL20 as select from zgy_ddl19( p_mtype:'ROH' , p_mgroup: 'A3001' )
{
    //ZGY_DDL19 INPUT
    matnr,
    mtart,
    matkl,
    ntgew
} 
    
 