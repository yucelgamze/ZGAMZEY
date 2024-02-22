*&---------------------------------------------------------------------*
*& Report ZGY_P_0015
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_p_0015 MESSAGE-ID zgy_mc_0001.

INCLUDE:
zgy_p_0015_top,
zgy_p_0015_lcl,
zgy_p_0015_mdl.


START-OF-SELECTION.
*  CREATE OBJECT go_local.
  go_local = NEW lcl_class( ).
  go_local->call_screen( ).
