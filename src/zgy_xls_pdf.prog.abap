*&---------------------------------------------------------------------*
*& Report ZGY_SATIS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_xls_pdf.

INCLUDE:
zgy_xls_pdf_top,
zgy_xls_pdf_lcl,
zgy_xls_pdf_frm,
zgy_xls_pdf_mdl.

INITIALIZATION.
  CREATE OBJECT go_local.
  go_local->template_xls_button( ).

START-OF-SELECTION.
  go_local->upload_xls( ).
  go_local->call_screen( ).
