@AbapCatalog.sqlViewName: 'zgy_cds_0014'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Annotations'



@AbapCatalog.buffering.status: #ACTIVE
@AbapCatalog.buffering.type: #FULL



/*+[hideWarning] { "IDS" : [ "KEY_CHECK" ]  } */
define view zgy_ddl_0014
  as select from vbap
{
  key vbeln,
      @UI.hidden: true
      posnr,
      @Consumption.hidden: true
      matnr,
      @Semantics.quantity.unitOfMeasure: 'MEINS'
      kwmeng,
      @Semantics.unitOfMeasure: true
      meins
} 
 