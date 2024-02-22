@AbapCatalog.sqlViewName: 'zgy_cds_0013'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Associations with Cardinality'
define view zgy_ddl_0013 
  as select from mara as mara
  association[0..*] to makt as _makt on $projection.Malzeme = _makt.matnr     
{

  mara.matnr as Malzeme,
//  _makt            // exposed
  _makt.maktx       // ad-hoc 
} 
 