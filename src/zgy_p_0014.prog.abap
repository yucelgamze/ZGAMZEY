*&---------------------------------------------------------------------*
*& Report
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_p_0014.

INCLUDE:
zgy_p_0014_top,
zgy_p_0014_lcl,
zgy_p_0014_mdl.

START-OF-SELECTION.
*  CREATE OBJECT go_local.
  go_local = NEW lcl_class( ).
  go_local->call_screen( ).