*&---------------------------------------------------------------------*
*& Report ZGAMZEY_ADVANCED1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_advanced1.

INCLUDE ZGY_ADVANCED1_TOP.
*INCLUDE:zgamzey_advanced1_top,
INCLUDE ZGY_ADVANCED1_LCL.
*        zgamzey_advanced1_lcl,
INCLUDE ZGY_ADVANCED1_moduls.
*        zgamzey_advanced1_moduls.

START-OF-SELECTION.
  CREATE OBJECT go_local.
  go_local->call_screen( ).
