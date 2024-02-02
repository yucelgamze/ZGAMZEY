*&---------------------------------------------------------------------*
*& Report ZGY_ALV_TEMPLATE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_p_0008 MESSAGE-ID zgy_mc_0001.

INCLUDE:
zgy_p_0008_top,
zgy_p_0008_lcl,
zgy_p_0008_mdl.


START-OF-SELECTION.
*  CREATE OBJECT go_local.
  go_local = NEW lcl_class( ).
  go_local->call_screen( ).
