@AbapCatalog.sqlViewName: 'ZGY_CDS2'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'zgy_cds2'
define view zgy_DDL2
  as select from    vbak
    left outer join vbap on vbak.vbeln = vbap.vbeln
{
    key vbak.vbeln,
    key posnr,
    kwmeng,
    div(vbap.kwmeng,3) as zdiv,
    division(vbap.kwmeng,3,3) as zdivision,
    ceil(division(vbap.kwmeng,3,3)) as zceil,
    floor(division(vbap.kwmeng,3,3)) as zfloor,
    round(ceil(division(vbap.kwmeng,3,3)) , 0) as zround0,
    round(ceil(division(vbap.kwmeng,3,3)) , 1) as zround1,
    round(ceil(division(vbap.kwmeng,3,3)) , 2) as zround2,
    round(ceil(division(vbap.kwmeng,3,3)) , 3) as zround3,
    
    concat(ltrim(vbak.vbeln, '0'),ltrim(vbap.posnr, '0') ) as zconcat,
    
    $session.user as zuser
  } 
 