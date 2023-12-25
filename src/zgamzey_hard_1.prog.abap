*&---------------------------------------------------------------------*
*& Report ZGAMZEY_HARD_1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgamzey_hard_1.

INCLUDE:
 zgamzey_hard_1_top,
 zgamzey_hard_1_lcl,
 zgamzey_hard_1_moduls.

START-OF-SELECTION.
  CREATE OBJECT go_local.
  go_local->get_data( ).
  go_local->call_screen( ).
