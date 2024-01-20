*&---------------------------------------------------------------------*
*& Report ZGAMZEY_ADVANCED4
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_advanced4.

INCLUDE ZGY_ADVANCED4_TOP.
*INCLUDE:zgamzey_advanced4_top,
INCLUDE ZGY_ADVANCED4_LCL.
*        zgamzey_advanced4_lcl,
INCLUDE ZGY_ADVANCED4_MDL.
*        zgamzey_advanced4_moduls.

START-OF-SELECTION.
  CREATE OBJECT go_local.
  go_local->call_screen( ).
