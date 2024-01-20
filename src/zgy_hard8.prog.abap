*&---------------------------------------------------------------------*
*& Report ZGAMZEY_HARD8
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_hard8.

INCLUDE ZGY_HARD8_TOP.
*INCLUDE:zgamzey_hard8_top,
INCLUDE ZGY_HARD8_LCL.
*        zgamzey_hard8_lcl,
INCLUDE ZGY_HARD8_MDL.
*        zgamzey_hard8_moduls.

START-OF-SELECTION.
  CREATE OBJECT go_local.
  go_local->get_data( ).
  go_local->call_screen( ).
