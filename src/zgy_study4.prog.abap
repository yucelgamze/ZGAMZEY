*&---------------------------------------------------------------------*
*& Report ZGAMZEY_STUDY4
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_study4.

INCLUDE ZGY_STUDY4_TOP.
*INCLUDE:zgamzey_study4_top,
INCLUDE ZGY_STUDY4_LCL.
*        zgamzey_study4_lcl,
INCLUDE ZGY_STUDY4_MDL.
*        zgamzey_study4_mdl.

START-OF-SELECTION.
  CREATE OBJECT go_local.
  go_local->call_screen( ).
