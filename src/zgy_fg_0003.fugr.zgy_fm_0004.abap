FUNCTION ZGY_FM_0004.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IV_MATNR) TYPE  MATNR
*"     REFERENCE(IV_VKORG) TYPE  VKORG
*"     REFERENCE(IV_VTWEG) TYPE  VTWEG
*"  EXPORTING
*"     REFERENCE(EV_EXIST) TYPE  CHAR1
*"----------------------------------------------------------------------


  SELECT SINGLE matnr, vkorg, vtweg
  FROM mvke
  WHERE matnr EQ @iv_matnr
  AND   vkorg EQ @iv_vkorg
  AND   vtweg EQ @iv_vtweg
  INTO @DATA(ls_tab).

  IF sy-subrc IS INITIAL.
    ev_exist = 'X'.
  ELSE.
    ev_exist = ' '.
  ENDIF.


ENDFUNCTION.
