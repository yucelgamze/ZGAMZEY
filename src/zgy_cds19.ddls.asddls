@AbapCatalog.sqlViewName: 'ZGY_CDS19'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'zgy_cds19'
define view zgy_ddl19
  with parameters
    p_mtype  : mtart,
    p_mgroup : matkl
  as select from mara
{
  key matnr,
      mtart,
      matkl,
      ntgew
}
where
      mtart = $parameters.p_mtype
  and matkl = $parameters.p_mgroup
  
   //cds with input parameters 
 