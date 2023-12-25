*&---------------------------------------------------------------------*
*& Report ZGAMZEY_HARD5
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgamzey_hard5 MESSAGE-ID zgamzey_mc_hard5.

INCLUDE:zgamzey_hard5_top,
        zgamzey_hard5_lcl,
        zgamzey_hard5_moduls.

START-OF-SELECTION.
  CREATE OBJECT go_local.
  CREATE OBJECT go_personal.
  go_local->call_screen( ).
