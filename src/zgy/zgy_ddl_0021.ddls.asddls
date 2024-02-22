@AbapCatalog.sqlViewName: 'zgy_cds_0021'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Coalence'
define view zgy_ddl_0021
  as select from    zgy_egt_table6 as t6
    left outer join zgy_egt_table7 as a on  a.matnr = t6.malzeme
                                        and a.lgort = '1001'
    left outer join zgy_egt_table7 as b on  b.matnr = t6.malzeme
                                        and b.lgort = '1002'
{
  t6.malzeme,
  //  a.menge as a_menge,
  //  b.menge as b_menge

  // coalence yerine "case when then else end" de olabilir -> yani hangi değer dolu ise yazılsın

  //  case when a.menge is null then b.menge
  //       else a.menge end as alias1


  coalesce(a.menge, b.menge) as alias1
} 
 