*&---------------------------------------------------------------------*
*& Report ZGAMZEY_ADVANCED4
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgamzey_advanced4.

INCLUDE:zgamzey_advanced4_top,
        zgamzey_advanced4_lcl,
        zgamzey_advanced4_moduls.

START-OF-SELECTION.
  CREATE OBJECT go_local.
  go_local->call_screen( ).
