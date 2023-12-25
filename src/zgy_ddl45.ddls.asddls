@AbapCatalog.sqlViewName: 'ZGY_CDS45'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Annotations'

@AbapCatalog.buffering.status: #ACTIVE
@AbapCatalog.buffering.type: #FULL
define view ZGY_DDL45
  as select from vbap
{
  key    vbeln,
         @UI.hidden:true
         posnr,
         @Consumption.hidden: true
         matnr,
         @Semantics.quantity.unitOfMeasure: 'MEINS'
         kwmeng,
         @Semantics.unitOfMeasure: true
         meins
} 
 