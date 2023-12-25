FUNCTION zgy_fm_toplam_miktar.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_VBELN) TYPE  VBELN
*"  EXPORTING
*"     VALUE(EV_TOTAL) TYPE  CHAR10
*"     VALUE(EV_SUCCESS) TYPE  XFELD
*"     VALUE(EV_MESSAGE) TYPE  BAPI_MSG
*"----------------------------------------------------------------------


  DATA: lv_kwmeng TYPE kwmeng.

  SELECT
    SUM( kwmeng ) AS total
    FROM vbap
    WHERE vbeln EQ @iv_vbeln
    INTO @lv_kwmeng.

  IF lv_kwmeng IS NOT INITIAL.
    ev_total = lv_kwmeng.
    ev_success = abap_true.
  ELSE.
    ev_message = |Sipariş numarasını kontrol ediniz!!!|.
  ENDIF.

ENDFUNCTION.
