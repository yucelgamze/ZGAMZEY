*&---------------------------------------------------------------------*
*& Report ZGAMZEY_BONUS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgamzey_medium_bonus.

INCLUDE:
zgamzey_medium_bonus_top,
zgamzey_medium_bonus_class,
zgamzey_medium_bonus_moduls.


START-OF-SELECTION.
  CREATE OBJECT go_local.
  go_local->get_data( ).
  go_local->call_screen( ).
