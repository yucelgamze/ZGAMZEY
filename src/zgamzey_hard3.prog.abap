*&---------------------------------------------------------------------*
*& Report ZGAMZEY_HARD3
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgamzey_hard3 MESSAGE-ID zrez_mc.

INCLUDE:zgamzey_hard3_top,
        zgamzey_hard3_lcl,
        zgamzey_hard3_moduls.

START-OF-SELECTION.
  CREATE OBJECT go_local.
  go_local->get_data( ).
  go_local->call_screen( ).
