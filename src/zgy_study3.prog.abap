*&---------------------------------------------------------------------*
*& Report ZGAMZEY_STUDY2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_study3.

INCLUDE:
INCLUDE ZGY_STUDY3_TOP.
*zgamzey_study3_top,
INCLUDE ZGY_STUDY3_LCL.
*zgamzey_study3_lcl,
INCLUDE ZGY_STUDY3_MDL.
*zgamzey_study3_moduls.


START-OF-SELECTION.
  CREATE OBJECT go_local.
  go_local->call_screen( ).
