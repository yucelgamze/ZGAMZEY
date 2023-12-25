FUNCTION zgamzey_kontrol_fm.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IT_MATNR) TYPE  ZGAMZEY_MATNR_S_TT
*"  EXPORTING
*"     VALUE(ET_KONTROL) TYPE  ZGAMZEY_MATNR_KONTROL_TT
*"----------------------------------------------------------------------
  DATA:gt_mara    TYPE TABLE OF mara,
       gs_mara    TYPE mara,
       gs_matnr   TYPE zgamzey_matnr_s,
       gs_kontrol TYPE zgamzey_matnr_kontrol_s.

  IF it_matnr IS NOT INITIAL.
    SELECT *
      FROM mara
      INTO  TABLE gt_mara
      FOR ALL ENTRIES IN it_matnr
      WHERE matnr EQ it_matnr-matnr.

    LOOP AT it_matnr INTO gs_matnr.
      gs_kontrol-matnr = gs_matnr-matnr.
      READ TABLE gt_mara INTO gs_mara WITH KEY matnr = gs_matnr-matnr.
      IF sy-subrc EQ 0.
        gs_kontrol-kontrol = 'Var'.
      ELSE.
        gs_kontrol-kontrol = 'Yok'.
      ENDIF.
      APPEND gs_kontrol TO et_kontrol.
    ENDLOOP.
  ENDIF.

ENDFUNCTION.
