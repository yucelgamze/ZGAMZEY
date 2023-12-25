*&---------------------------------------------------------------------*
*& Report ZGAMZEY_STUDY4
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgamzey_study4.

INCLUDE:zgamzey_study4_top,
        zgamzey_study4_lcl,
        zgamzey_study4_mdl.

START-OF-SELECTION.
  CREATE OBJECT go_local.
  go_local->call_screen( ).
