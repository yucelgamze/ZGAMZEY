FUNCTION zgy_title.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IV_TITLE_ID) TYPE  ZPERS_TITLE_ID
*"  EXPORTING
*"     REFERENCE(EV_FOUND) TYPE  CHAR1
*"----------------------------------------------------------------------
  SELECT SINGLE *
    FROM ztitle_t
    INTO @DATA(ls_title)
    WHERE title_id EQ @iv_title_id.

    IF sy-subrc EQ 0.
      ev_found = 'X'.
      MESSAGE 'Girilen title ID mevcut' TYPE 'I' DISPLAY LIKE 'I'.
    ELSE.
      ev_found = ' '.
      MESSAGE 'HATA! Girilen title ID mevcut DEĞİL!' TYPE 'I' DISPLAY LIKE 'W'.
    ENDIF.

  ENDFUNCTION.
