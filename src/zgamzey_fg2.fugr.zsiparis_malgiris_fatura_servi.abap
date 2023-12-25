FUNCTION zsiparis_malgiris_fatura_servi.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IT_EBELN) TYPE  ZEBELN_TT
*"  EXPORTING
*"     VALUE(ET_FATURA) TYPE  ZFATURA_TT
*"----------------------------------------------------------------------

  DATA:
    gt_ebeln  TYPE TABLE OF zebeln_s,
    gs_ebeln  TYPE zebeln_s,
    gt_fatura TYPE TABLE OF zfatura_s,
    gs_fatura TYPE zfatura_s.

  IF it_ebeln IS NOT INITIAL.
    SELECT
      t1~ebeln,
      t2~mblnr,
      t2~mjahr,
      t3~belnr,
      t3~gjahr
      FROM zsas_t AS t1
      LEFT JOIN zmgir_t AS t2
      ON t1~ebeln EQ t2~ebeln
      LEFT JOIN zfatura_t AS t3
      ON t2~mblnr EQ t3~mblnr AND t2~mjahr EQ t3~mjahr
      INTO CORRESPONDING FIELDS OF TABLE @gt_fatura
      FOR ALL ENTRIES IN @it_ebeln
      WHERE t1~ebeln EQ @it_ebeln-ebeln.

    LOOP AT gt_fatura INTO gs_fatura.
      IF gs_fatura-mblnr IS INITIAL.
        gs_fatura-durum = 'SAS Mevcut'.
      ELSEIF gs_fatura-belnr IS INITIAL.
        gs_fatura-durum = 'SAS ve Mal Girişi Mevcut'.
      ELSE.
        gs_fatura-durum = 'SAS, Mal Girişi ve Fatura Mevcut '.
      ENDIF.
      APPEND gs_fatura TO et_fatura.
    ENDLOOP.

    CLEAR gs_fatura.

    LOOP AT it_ebeln INTO gs_ebeln.
      READ TABLE gt_fatura INTO gs_fatura WITH KEY ebeln = gs_ebeln-ebeln.
      IF sy-subrc NE 0.
        gs_fatura-ebeln = gs_ebeln-ebeln.
        gs_fatura-durum = 'SAS Bulunmadı'.
      ENDIF.
      APPEND gs_fatura TO et_fatura.
    ENDLOOP.
  ENDIF.

  SORT et_fatura ASCENDING BY ebeln ASCENDING mblnr ASCENDING belnr.

ENDFUNCTION.
