FUNCTION zgy_fm_0002.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IV_MATNR) TYPE  MATNR
*"  EXPORTING
*"     REFERENCE(EV_EXIST) TYPE  CHAR1
*"----------------------------------------------------------------------

  SELECT SINGLE matnr
  FROM mara
  WHERE matnr EQ @iv_matnr
  INTO @DATA(lv_matnr).

  IF sy-subrc IS INITIAL.
    ev_exist = 'X'.
  ELSE.
    ev_exist = ' '.
  ENDIF.

ENDFUNCTION.
