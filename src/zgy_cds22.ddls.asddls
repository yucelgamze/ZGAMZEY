@AbapCatalog.sqlViewName: 'ZGY_CDS22'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'zgy_cds22'
define view zgy_DDL22
  as select from ekpo
{
  key ebeln,
      ebelp,
      ltrim(matnr, '0') as Material_Number,

      case statu
      when 'Q' then 'Quotation exists'
      when 'F' then 'Having prod order'
      else 'No Quatation'
      end               as RFQ_Status,

      case
      when lgort = '0001' then 'STR1'
      when lgort = '0002' then 'STR2'
      end               as STR_LOC,
      
      netpr,
      ( netpr - 100 ) as discounted_price

}
where
      mandt = $session.client
  and aedat < $session.system_date

//SESSION VARIABLES have a predefined name and are set to predefined value when the CDS view is used in OPEN SQL. This also applies to CDS views
// that are used as data sources in other CDS views.
// $session.user            as system_user
// $session.client          as system_client
// $session.system_language as system_language
// $session.system_date     as system_date  
 