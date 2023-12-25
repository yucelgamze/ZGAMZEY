FUNCTION zgy_dep.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IV_DEPARTMAN_ID) TYPE  ZPERS_DEPARTMAN_ID
*"  EXPORTING
*"     REFERENCE(EV_FOUND) TYPE  CHAR1
*"----------------------------------------------------------------------
  SELECT SINGLE *
    FROM zdep_t
    INTO @DATA(ls_dep)
    WHERE departman_id EQ @iv_departman_id.

  IF sy-subrc EQ 0.
    ev_found = 'X'.
    MESSAGE 'Girilen departman ID mevcuttur!' TYPE 'I' DISPLAY LIKE 'I'.
  ELSE.
    ev_found = ' '.
    MESSAGE 'HATA! Girilen departman ID mevcut değildir' TYPE 'I' DISPLAY LIKE 'I'.
  ENDIF.

ENDFUNCTION.
