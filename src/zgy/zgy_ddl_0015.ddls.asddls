@AbapCatalog.sqlViewName: 'zgy_cds_0015'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Parameters'
define view zgy_ddl_0015
  with parameters
    p_meins : meins,
    p_mtart : mtart
  as select from mara
{
  matnr,
  matkl,
  mtart,
  meins
} 
where meins = $parameters.p_meins and
      mtart = $parameters.p_mtart

 