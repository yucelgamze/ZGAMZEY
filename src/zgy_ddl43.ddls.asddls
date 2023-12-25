@AbapCatalog.sqlViewName: 'ZGY_CDS43'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Associations'
//define view ZGY_DDL43 as select from data_source_name
//association [1] to target_data_source_name as _association_name
//    on $projection.element_name = _association_name.target_element_name
//{
//
//    _association_name // Make association public
//}


//define view ZGY_DDL43
//  as select from mara as mara
//  association to makt as _makt on mara.matnr = _makt.matnr
//{
//  mara.matnr,
//  _makt.maktx     //ad-hoc association
//} 


// left join ile association aynı şey


//define view ZGY_DDL43
//  as select from mara as mara
// left outer join makt as makt on mara.matnr = makt.matnr
//{
//  mara.matnr,
//  makt.maktx
//}   

//define view ZGY_DDL43
//  as select from mara as mara
//  association to makt as _makt on mara.matnr = _makt.matnr
//{
//  mara.matnr
//} 

//define view ZGY_DDL43
//  as select from mara as mara
// left outer join makt as makt on mara.matnr = makt.matnr
//{
//  mara.matnr
//}   

//define view ZGY_DDL43
//  as select from mara as mara
//  association to makt as _makt on mara.matnr = _makt.matnr
//{
//  mara.matnr,
//  _makt     //exposed 
//} 

define view ZGY_DDL43
  as select from mara as mara
  association [0..1] to makt as _makt on mara.matnr = _makt.matnr
{
  mara.matnr,
  _makt.maktx     //ad-hoc 
} 

 