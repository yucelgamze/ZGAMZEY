*&---------------------------------------------------------------------*
*& Report ZGAMZEY_STUDY2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_study3.


INCLUDE zgy_study3_top.
*zgamzey_study3_top,
INCLUDE zgy_study3_lcl.
*zgamzey_study3_lcl,
INCLUDE zgy_study3_mdl.
*zgamzey_study3_moduls.


START-OF-SELECTION.
  CREATE OBJECT go_local.
  go_local->call_screen( ).
