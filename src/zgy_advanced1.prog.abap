*&---------------------------------------------------------------------*
*& Report ZGAMZEY_ADVANCED1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_advanced1.

INCLUDE zgy_advanced1_top.
*INCLUDE:zgamzey_advanced1_top,
INCLUDE zgy_advanced1_lcl.
*        zgamzey_advanced1_lcl,
INCLUDE zgy_advanced1_mdl.
*        zgamzey_advanced1_moduls.

START-OF-SELECTION.
  CREATE OBJECT go_local.
  go_local->call_screen( ).
