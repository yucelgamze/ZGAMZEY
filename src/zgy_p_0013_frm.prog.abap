*&---------------------------------------------------------------------*
*& Include          ZGY_XLS_PDF_FRM
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form DOWNLOAD_TEMPLATE_XLS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM download_template_xls USING pv_object TYPE w3objid.

  DATA:ls_return TYPE bapiret2.

  CALL FUNCTION 'Z_EXPORT_TEMPLATE'
    EXPORTING
      iv_object_name = pv_object
    IMPORTING
      es_return      = ls_return.

  IF ls_return-type = 'E'.
    MESSAGE ID ls_return-id TYPE 'I' NUMBER ls_return-number DISPLAY LIKE 'E'.
  ENDIF.
ENDFORM.
