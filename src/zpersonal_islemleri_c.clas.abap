class ZPERSONAL_ISLEMLERI_C definition
  public
  final
  create public .

public section.

  methods PERSONAL_KONTROLU
    importing
      !IV_PERNR type P_PERNR
    exporting
      !EV_SUCCESS type XFELD
      !EV_MESSAGE type BAPI_MSG .
  methods PERSONAL_AKTIVITE_EKLE
    importing
      !IV_PERNR type P_PERNR
      !IV_ACT_DATE type DATUM
      !IV_DESCP type ZDESCP_DE
    exporting
      !EV_SUCCESS type XFELD
      !EV_MESSAGE type BAPI_MSG .
protected section.
private section.
ENDCLASS.



CLASS ZPERSONAL_ISLEMLERI_C IMPLEMENTATION.


  METHOD personal_aktivite_ekle.

    "İŞ BAŞLANGIÇ TARİHİ ZPERNR_T'DEN ÇEKİLİR
    SELECT SINGLE start_date
      FROM zpernr_t
      INTO @DATA(lv_start)
      WHERE pernr EQ @iv_pernr.

    DATA:ls_aktivite TYPE zaktivite_t.
    SELECT SINGLE *
      FROM zaktivite_t
      INTO ls_aktivite
      WHERE pernr EQ iv_pernr AND act_date EQ iv_act_date.

    IF ls_aktivite IS NOT INITIAL.
      ev_success = ''.
      ev_message = iv_pernr && ' personelin' && iv_act_date && ' tarihinde önceden aktivitesi girilmiş!'.
    ELSE.
      IF iv_act_date LE lv_start.
        ev_success = ' '.
        ev_message = 'Personel işe başlama tarihinden öncesine aktivite giremez!'.
      ELSE.
        ls_aktivite-pernr    = iv_pernr.
        ls_aktivite-act_date = iv_act_date.
        ls_aktivite-descp    = iv_descp.
        INSERT zaktivite_t FROM ls_aktivite.
        ev_success = 'X'.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD personal_kontrolu.

    SELECT SINGLE *
      FROM zpernr_t
      INTO @DATA(ls_pernr)
      WHERE pernr EQ @iv_pernr.

    IF sy-subrc EQ 0.
      ev_success = 'X'.
    ELSEIF sy-subrc EQ 4.
      ev_success = ' '.
      ev_message = 'Personel numarası bulunamadı!'.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
