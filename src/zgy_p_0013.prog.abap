*&---------------------------------------------------------------------*
*& Report
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_p_0013 MESSAGE-ID zgy_mc_0001.

INCLUDE:
zgy_p_0013_top,
zgy_p_0013_lcl,
zgy_p_0013_frm,
zgy_p_0013_mdl.


INITIALIZATION.
  CREATE OBJECT go_local.
  go_local->template_xls_button( ).

START-OF-SELECTION.
  go_local->upload_xls( ).
  go_local->call_screen( ).
