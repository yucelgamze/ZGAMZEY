@AbapCatalog.sqlViewName: 'ZGY_CDS7'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'zgy_cds7'
define view zgy_DDL7
    with parameters p_lgort : abap.char( 4 )
as select from zgy_DDL6
{
    matnr,
    sum(zfark) as zfark
}
where lgort = $parameters.p_lgort
group by matnr

//bir önceki cds6 te keyler alındığı için belgenin kalemleri
// bazında gelmiş oldu bütün veriler cds7 de ise malzeme bazında 
// bugüne kadar ne kadar mal hareketi olmuş 101 hareketi - 102 hareketi olarak 
 