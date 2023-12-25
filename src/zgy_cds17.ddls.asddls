@AbapCatalog.sqlViewName: 'zgy_cds17'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'zgy_cds17'
define view zgy_ddl17 as select from acdoca as acd
association to zgy_ddl16 as _company 
on acd.rbukrs = _company.bukrs
{
    acd.rldnr,
    acd.rbukrs,
    acd.gjahr,
    acd.belnr,
    
    _company.zland,
    _company.butxt,
    _company._t5.natio50
    
} 
 