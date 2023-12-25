FUNCTION zgy_test_provider.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_MATNR) TYPE  MATNR
*"  EXPORTING
*"     VALUE(ES_DETAIL) TYPE  MARA
*"----------------------------------------------------------------------

  DATA: lv_matnr TYPE matnr.

*  CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
*    EXPORTING
*      input        = iv_matnr
*    IMPORTING
*      output       = lv_matnr
*    EXCEPTIONS
*      length_error = 1
*      OTHERS       = 2.
*  IF sy-subrc <> 0.
** Implement suitable error handling here
*  ENDIF.

  lv_matnr = |{ iv_matnr ALPHA = IN }|.

  SELECT SINGLE *
    FROM mara
    INTO es_detail
    WHERE matnr EQ lv_matnr.



ENDFUNCTION.
