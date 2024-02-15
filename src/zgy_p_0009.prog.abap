*&---------------------------------------------------------------------*
*& Report ZGY_ALV_TEMPLATE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_p_0009 MESSAGE-ID zgy_mc_0001.

INCLUDE:
zgy_p_0009_top,
zgy_p_0009_lcl,
zgy_p_0009_mdl.


START-OF-SELECTION.
*  CREATE OBJECT go_local.
  go_local = NEW lcl_class( ).
  go_local->call_screen( ).
