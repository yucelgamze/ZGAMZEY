*&---------------------------------------------------------------------*
*& Report ZGAMZEY_HARD6
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgamzey_hard6.

INCLUDE:zgamzey_hard6_top,
        zgamzey_hard6_lcl,
        zgamzey_hard6_moduls.

START-OF-SELECTION.
  CREATE OBJECT go_local.
  go_local->get_data( ).
  go_local->call_screen( ).
