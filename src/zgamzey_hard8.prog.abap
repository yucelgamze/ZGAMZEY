*&---------------------------------------------------------------------*
*& Report ZGAMZEY_HARD8
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgamzey_hard8.

INCLUDE:zgamzey_hard8_top,
        zgamzey_hard8_lcl,
        zgamzey_hard8_moduls.

START-OF-SELECTION.
  CREATE OBJECT go_local.
  go_local->get_data( ).
  go_local->call_screen( ).
