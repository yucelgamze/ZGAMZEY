*&---------------------------------------------------------------------*
*& Report ZGAMZEY_HARD_1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_hard1.

INCLUDE:
INCLUDE ZGY_HARD1_TOP.
* zgamzey_hard_1_top,
INCLUDE ZGY_HARD1_LCL.
* zgamzey_hard_1_lcl,
INCLUDE ZGY_HARD1_MDL.
* zgamzey_hard_1_moduls.

START-OF-SELECTION.
  CREATE OBJECT go_local.
  go_local->get_data( ).
  go_local->call_screen( ).
