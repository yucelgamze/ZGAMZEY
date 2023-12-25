*&---------------------------------------------------------------------*
*& Report ZGAMZEY_STUDY2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgamzey_study3.

INCLUDE:
zgamzey_study3_top,
zgamzey_study3_lcl,
zgamzey_study3_moduls.


START-OF-SELECTION.
  CREATE OBJECT go_local.
  go_local->call_screen( ).
