*&---------------------------------------------------------------------*
*& Report ZGAMZEY_STUDY2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgamzey_study2.

INCLUDE:zgamzey_study2_top,
        zgamzey_study2_lcl,
        zgamzey_study2_moduls.

START-OF-SELECTION.
  CREATE OBJECT go_local.
  go_local->call_screen( ).
