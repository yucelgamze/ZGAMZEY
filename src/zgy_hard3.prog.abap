*&---------------------------------------------------------------------*
*& Report ZGAMZEY_HARD3
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_hard3 MESSAGE-ID zrez_mc.

INCLUDE ZGY_HARD3_TOP.
*INCLUDE:zgamzey_hard3_top,
INCLUDE ZGY_HARD3_LCL.
*        zgamzey_hard3_lcl,
INCLUDE ZGY_HARD3_MDL.
*        zgamzey_hard3_moduls.

START-OF-SELECTION.
  CREATE OBJECT go_local.
  go_local->get_data( ).
  go_local->call_screen( ).
