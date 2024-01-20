*&---------------------------------------------------------------------*
*& Report ZGAMZEY_STUDY2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_study2.

INCLUDE ZGY_STUDY2_TOP.
*INCLUDE:zgamzey_study2_top,
INCLUDE ZGY_STUDY2_LCL.
*        zgamzey_study2_lcl,
INCLUDE ZGY_STUDY2_MDL.
*        zgamzey_study2_moduls.

START-OF-SELECTION.
  CREATE OBJECT go_local.
  go_local->call_screen( ).
