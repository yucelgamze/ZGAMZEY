*&---------------------------------------------------------------------*
*& Report ZGAMZEY_MEDIUM_GUESS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_medium_guess.

INCLUDE ZGY_MEDIUM_GUESS_TOP.
*INCLUDE:zgamzey_medium_guess_top,
INCLUDE ZGY_MEDIUM_GUESS_LCL.
*        zgamzey_medium_guess_class,
INCLUDE ZGY_MEDIUM_GUESS_MDL.
*        zgamzey_medium_guess_moduls.

START-OF-SELECTION.
  CREATE OBJECT go_local.
  go_local->get_data( ).
  go_local->call_screen( ).
