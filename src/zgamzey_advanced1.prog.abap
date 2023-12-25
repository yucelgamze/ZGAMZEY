*&---------------------------------------------------------------------*
*& Report ZGAMZEY_ADVANCED1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgamzey_advanced1.

INCLUDE:zgamzey_advanced1_top,
        zgamzey_advanced1_lcl,
        zgamzey_advanced1_moduls.

START-OF-SELECTION.
  CREATE OBJECT go_local.
  go_local->call_screen( ).
