@AbapCatalog.sqlViewName: 'ZGY_CDS44'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Associations with Cardinality'
define view ZGY_DDL44 
  as select from mara as mara
  association [0..*] to makt as _makt on $projection.MaterialNo = _makt.matnr
{
  mara.matnr  as MaterialNo, 
  _makt.maktx     //ad-hoc 
}  
 