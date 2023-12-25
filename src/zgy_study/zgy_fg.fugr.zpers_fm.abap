FUNCTION zpers_fm.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IV_PERSONAL_ID) TYPE  ZPERS_ID_DE
*"  EXPORTING
*"     REFERENCE(EV_FOUND) TYPE  CHAR1
*"     REFERENCE(EV_MAAS) TYPE  ZPERS_MAAS_DE
*"----------------------------------------------------------------------
  SELECT SINGLE maas
    FROM  zpersonal_t
    INTO  ev_maas
    WHERE personal_id EQ iv_personal_id.

  IF sy-subrc EQ 0.
    ev_found = 'X'.
    MESSAGE i008(zpers_mc).
  ELSE.
    ev_found = ' '.
    MESSAGE i009(zpers_mc).
  ENDIF.
ENDFUNCTION.
