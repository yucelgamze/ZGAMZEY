*&---------------------------------------------------------------------*
*& Report ZGY_DYNAMIC
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_pratik MESSAGE-ID zgy_mc_0001.

INCLUDE:
zgy_pratik_top,
zgy_pratik_lcl,
zgy_pratik_frm,
zgy_pratik_mdl.

INITIALIZATION.
  CREATE OBJECT go_local.
  go_local->template_xls_button( ).

START-OF-SELECTION.
  go_local->upload_xls( ).
  go_local->call_screen( ).
