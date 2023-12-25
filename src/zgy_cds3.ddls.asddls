@AbapCatalog.sqlViewName: 'ZGY_CDS3'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'zgy_cds3'
define view zgy_DDL3
  as select from eket
    inner join   ekpo on  eket.ebeln = ekpo.ebeln
                      and eket.ebelp = ekpo.ebelp
    inner join   ekko on ekko.ebeln = ekpo.ebeln
{
  key ekko.ebeln,
  key ekpo.ebelp,
      eket.menge,
      eket.wemng,
      eket.menge - eket.wemng as zacik_miktar

      //    case
      //    when eket.menge = eket.wemng
      //    then 'X'
      //    when eket.menge <> eket.wemng
      //    then ''
      //    end as gosterge
}
//where eket.menge <> eket.wemng 
 