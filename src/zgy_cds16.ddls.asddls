@AbapCatalog.sqlViewName: 'zgy_cds16'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'zgy_cds16'
define view zgy_ddl16 as select from t001 as t1
association to t005t as _t5
on $projection.zland = _t5.land1
//and _t5.land1 = 'T'
{
    t1.bukrs,
    t1.land1 as zland,
    t1.butxt,
//    _t5.land1   // ad-hoc association

// public
    _t5
} 
 