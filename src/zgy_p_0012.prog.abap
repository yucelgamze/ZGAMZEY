*&---------------------------------------------------------------------*
*& Report ZGY_ALV_TEMPLATE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_p_0012 MESSAGE-ID zgy_mc_0001.

INCLUDE:
zgy_p_0012_top,
zgy_p_0012_lcl,
zgy_p_0012_mdl.

START-OF-SELECTION.
*  CREATE OBJECT go_local.
  go_local = NEW lcl_class( ).
  go_local->call_screen( ).
