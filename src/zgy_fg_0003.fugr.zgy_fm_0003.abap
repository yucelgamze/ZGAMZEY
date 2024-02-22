FUNCTION zgy_fm_0003.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IV_MATNR) TYPE  MATNR
*"     REFERENCE(IV_VKORG) TYPE  VKORG
*"  EXPORTING
*"     REFERENCE(EV_EXIST) TYPE  CHAR1
*"----------------------------------------------------------------------

  SELECT SINGLE matnr, vkorg
  FROM mvke
  WHERE matnr EQ @iv_matnr
  AND   vkorg EQ @iv_vkorg
  INTO @DATA(ls_tab).

  IF sy-subrc IS INITIAL.
    ev_exist = 'X'.
  ELSE.
    ev_exist = ' '.
  ENDIF.



ENDFUNCTION.
