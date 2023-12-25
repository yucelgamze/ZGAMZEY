@AbapCatalog.sqlViewName: 'zgy_cds26'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'zgy_cds26'
define view zgy_ddl26
  as select from vbak as _sheader
  association [1..1] to vbap                  as _sitem    on _sheader.vbeln = _sitem.vbeln
  association [1..*] to I_BillingDocumentItem as _billing  on _sheader.vbeln = _billing.SalesDocument
  // rule: do not create association mapping between the associations!
  //  association [1..*] to I_Material            as _material on _sitem.matnr = _material.Material
  association [1]    to I_Customer            as _customer on _sheader.kunnr = _customer.Customer
{

      // rule: whatever field you are using for mapping that needs to be avaliable in your selection list !
  key _sheader.vbeln,
      _sheader.vbtyp,
      _sheader.kunnr as customer,

      //Association as public
      _sitem.posnr,         //Ad Hoc Association
     // _sitem,
      _billing,
      _customer
} 
 