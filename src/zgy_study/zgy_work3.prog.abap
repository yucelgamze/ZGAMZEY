*&---------------------------------------------------------------------*
*& Report ZGY_WORK3
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_work3.


INCLUDE:zgy_work3_top,
        zgy_work3_lcl,
        zgy_work3_moduls.

START-OF-SELECTION.
  CREATE OBJECT go_local.
  go_local->call_screen( ).
