FUNCTION zgy_fm_0001.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IT_MATNR) TYPE  ZGY_TT_0009
*"  EXPORTING
*"     VALUE(ET_SORGU) TYPE  ZGY_TT_0010
*"----------------------------------------------------------------------
  DATA:gs_sorgu   TYPE zgy_s_0010.

  IF it_matnr IS NOT INITIAL.

    SELECT * FROM mara
    INTO TABLE @DATA(lt_mara)
      FOR ALL ENTRIES IN @it_matnr
      WHERE matnr EQ @it_matnr-matnr.

    LOOP AT it_matnr INTO DATA(ls_matnr).
      gs_sorgu-matnr = ls_matnr-matnr.

      READ TABLE lt_mara ASSIGNING FIELD-SYMBOL(<lfs_mara>) WITH KEY matnr = ls_matnr-matnr. "index 1 de denilebilirdi zaten bir kayıt var for all entries in den dolayı
      IF sy-subrc EQ 0. "tablodan bir satır okuyabiliyor muyum
        gs_sorgu-sorgu = 'VAR'.
      ELSE.
        gs_sorgu-sorgu = 'YOK'.
      ENDIF.
    ENDLOOP.

    APPEND gs_sorgu TO et_sorgu.

  ENDIF.



ENDFUNCTION.
