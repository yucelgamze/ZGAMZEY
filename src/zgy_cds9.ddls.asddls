@AbapCatalog.sqlViewName: 'ZGY_CDS9'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'zgy_cds9'
define view zgy_DDL9
  as select from eket as e
    inner join   ekpo as p on e.ebeln = p.ebeln
    and e.ebelp = p.ebelp
    inner join ekko as k on k.ebeln = p.ebeln
{
    key p.ebeln,
    key p.ebelp,
    e.menge,
    e.wemng,
    case
    when e.menge = e.wemng
    then cast('X' as abap.sstring( 1 ))
    when e.menge > e.wemng
    then ''
    else cast( ' ' as abap.sstring( 1 ))
    end as gosterge,
// @Semantics.unitOfMeasure
// meins as UnitOfMeasuse,
// @Semantics.currencyCode
// waers as CurrencyCode,
// 
// @Semantics.quantity.unitOfMeasure: 'UnitOfMeasure'
cast( e.menge - e.wemng as zaciksas ) as aciksas,

//@Semantics.amount.currencyCode: 'CurrencyCode'
netpr as GrossAmount,

//@Semantics.quantity.unitOfMeasure: 'UnitOfMeasure'
p.ktmng as Quantity
 
  }
//  where e.menge > e.wemng 
 