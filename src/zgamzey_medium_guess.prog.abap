*&---------------------------------------------------------------------*
*& Report ZGAMZEY_MEDIUM_GUESS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgamzey_medium_guess.

INCLUDE:zgamzey_medium_guess_top,
        zgamzey_medium_guess_class,
        zgamzey_medium_guess_moduls.

START-OF-SELECTION.
  CREATE OBJECT go_local.
  go_local->get_data( ).
  go_local->call_screen( ).
