*&---------------------------------------------------------------------*
*& Report ZGY_WORK5
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_work5.

INCLUDE:zgy_work5_top,
        zgy_work5_lcl,
        zgy_work5_moduls.

START-OF-SELECTION.
  CREATE OBJECT go_local.
  go_local->call_screen( ).
