*&---------------------------------------------------------------------*
*& Report ZGAMZEY_MEDIUM_PERS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgamzey_medium_pers.

INCLUDE:
zgamzey_medium_pers_top,
zgamzey_medium_pers_class,
zgamzey_medium_pers_moduls.

START-OF-SELECTION.
  CREATE OBJECT go_local.
  go_local->get_data( ).
  go_local->call_screen( ).
