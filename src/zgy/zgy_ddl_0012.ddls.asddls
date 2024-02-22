@AbapCatalog.sqlViewName: 'zgy_cds_0012'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Associations'
//define view zgy_ddl_0012 as select from data_source_name
//association [1] to target_data_source_name as _association_name
//    on $projection.element_name = _association_name.target_element_name
//{
//
//    _association_name // Make association public
//}


//define view zgy_ddl_0012
//  as select from mara as mara
//  association to makt as _makt on mara.matnr = _makt.matnr     //ASSOCIATION arkasında LEFT OUTER JOIN var ( SQL view da görülebilir ) ANCAK çekilmeyen alan için LEFT JOIN yapılmaz
//{
//
//  mara.matnr,
//  _makt.maktx                   // ad-hoc association
//} 



//define view zgy_ddl_0012
//  as select from mara as mara
//  association to makt as _makt on mara.matnr = _makt.matnr    
//{
//  mara.matnr,
//  _makt                  // exposed                               ---> eğer _makt den kolon çekilirse otomatik left join atılır şu durumda atılı değildir.
//} 


define view zgy_ddl_0012
  as select from mara as mara
  association[0..1] to makt as _makt on mara.matnr = _makt.matnr     
{

  mara.matnr,
  _makt.maktx       // ad-hoc with cardinality 0 - 1
} 
 