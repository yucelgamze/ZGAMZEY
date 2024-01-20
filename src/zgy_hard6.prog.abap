*&---------------------------------------------------------------------*
*& Report ZGAMZEY_HARD6
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_hard6.

INCLUDE ZGY_HARD6_TOP.
*INCLUDE:zgamzey_hard6_top,
INCLUDE ZGY_HARD6_LCL.
*        zgamzey_hard6_lcl,
INCLUDE ZGY_HARD6_MDL.
*        zgamzey_hard6_moduls.

START-OF-SELECTION.
  CREATE OBJECT go_local.
  go_local->get_data( ).
  go_local->call_screen( ).
