@AbapCatalog.sqlViewName: 'zgy_cds25'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'zgy_cds25'
define view zgy_ddl25
  as select from    vbak                  as _sheader
    inner join      vbap                  as _sitem    on _sheader.vbeln = _sitem.vbeln
    inner join      I_BillingDocumentItem as _billing  on _sheader.vbeln = _billing.SalesDocument
    left outer join I_Material            as _material on _sitem.matnr = _material.Material
    left outer join I_Customer            as _customer on _sheader.kunnr = _customer.Customer

{
      // Sales Order Header
  key _sheader.vbeln             as Sales_Order,
      _sheader.vbtyp             as Sales_Type,
      _sheader.kunnr             as Customer,
      
      // Sales Order Item
      _sitem.posnr               as Sales_Order_item,
      _sitem.matnr               as Material,
      
      //Billing Document
      _billing.BillingDocument   as Billing_Document,
      _billing.Plant             as Plant,
      
      //Material Details
      _material.MaterialType     as Material_Type,
      _material.MaterialBaseUnit as Material_unit,
      
      //Customer Details
      _customer.Country          as Customer_Country
} 
 