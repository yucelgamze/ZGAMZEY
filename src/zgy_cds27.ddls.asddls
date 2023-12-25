@AbapCatalog.sqlViewName: 'ZGY_CDS27'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
//@EndUserText.label: 'Path Expression and calling association cds view'
define view zgy_DDL27 as select from zgy_ddl26
{
    // zgy_cds26 associations
    
    vbeln,
    vbtyp,
    customer,
    posnr,
    /* Associations */
    // zgy_ddl26 associations
    
    _billing[inner].SalesDocument,
    
   // _customer.CustomerName,
     _customer[Customer = '0001000007'].CustomerName
    
} 
 