*&---------------------------------------------------------------------*
*& Report ZGY_DYNAMIC
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_dynamic MESSAGE-ID zgy_mc_0001.

INCLUDE:
zgy_dynamic_top,
zgy_dynamic_lcl,
zgy_dynamic_frm,
zgy_dynamic_mdl.

INITIALIZATION.
  CREATE OBJECT go_local.
  go_local->template_xls_button( ).

START-OF-SELECTION.
  go_local->upload_xls( ).
  go_local->call_screen( ).
