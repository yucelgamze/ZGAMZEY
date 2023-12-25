*&---------------------------------------------------------------------*
*& Report ZGAMZEY_HARD9
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgamzey_hard9.

INCLUDE:zgamzey_hard9_top,
        zgamzey_hard9_lcl,
        zgamzey_hard9_moduls.

START-OF-SELECTION.
  CREATE OBJECT go_local.
  go_local->get_data( ).
  go_local->call_screen( ).
