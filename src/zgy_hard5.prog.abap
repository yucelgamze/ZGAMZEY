*&---------------------------------------------------------------------*
*& Report ZGAMZEY_HARD5
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_hard5 MESSAGE-ID zgamzey_mc_hard5.

INCLUDE ZGY_HARD5_TOP.
*INCLUDE:zgamzey_hard5_top,
INCLUDE ZGY_HARD5_LCL.
*        zgamzey_hard5_lcl,
INCLUDE ZGY_HARD5_MDL.
*        zgamzey_hard5_moduls.

START-OF-SELECTION.
  CREATE OBJECT go_local.
  CREATE OBJECT go_personal.
  go_local->call_screen( ).
