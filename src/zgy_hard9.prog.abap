*&---------------------------------------------------------------------*
*& Report ZGAMZEY_HARD9
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_hard9.

INCLUDE ZGY_HARD9_TOP.
*INCLUDE:zgamzey_hard9_top,
INCLUDE ZGY_HARD9_LCL.
*        zgamzey_hard9_lcl,
INCLUDE ZGY_HARD9_MDL.
*        zgamzey_hard9_moduls.

START-OF-SELECTION.
  CREATE OBJECT go_local.
  go_local->get_data( ).
  go_local->call_screen( ).
