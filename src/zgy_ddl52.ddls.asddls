@AbapCatalog.sqlViewName: 'ZGY_CDS52'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Coalence'
define view ZGY_DDL52
  as select from    zgy_egt_table6 as t6
    left outer join zgy_egt_table7 as a on  a.matnr = t6.malzeme
                                        and a.lgort = '1001'
    left outer join zgy_egt_table7 as b on  b.matnr = t6.malzeme
                                        and b.lgort = '1002'

{
  t6.malzeme,
  //  a.menge as a_menge,
  //  b.menge as b_menge

  //  coalence yerine case when then else ile kullanım:

  //  case when a.menge is null then b.menge
  //       else a.menge end as menge

  // coalence kullanımı:
  coalesce(a.menge, b.menge) as menge

} 
 