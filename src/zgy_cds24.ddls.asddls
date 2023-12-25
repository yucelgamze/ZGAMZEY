@AbapCatalog.sqlViewName: 'zgy_cds24'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'zgy_cds24'
define view zgy_ddl24
  as select from     vbak                  as _sheader
    inner join       vbap                  as _sitem    on _sheader.vbeln = _sitem.vbeln
  //                                and _sheader.vbtyp = 'C'
    inner join       vbrp                  as _sbilling on _sheader.vbeln = _sbilling.aubel
    left outer join  kna1                  as _customer on _sheader.kunnr = _customer.kunnr
  //    left outer join I_AddressEmailAddress as _email    on _customer.adrnr = _email.AddressID //standart cds view has been called
    right outer join I_AddressEmailAddress as _email    on _customer.adrnr = _email.AddressID //standart cds view has been called

{
  key _sheader.vbeln      as Sales_Order,
      _sheader.vbtyp      as Order_Type,
      _sitem.posnr        as Sales_Item,
      _sitem.matnr        as Material,
      _sbilling.vbeln     as Billing_Document,
      _customer.kunnr     as Customer,
      _email.EmailAddress as Customer_Email
} 
 