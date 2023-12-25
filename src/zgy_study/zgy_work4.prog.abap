*&---------------------------------------------------------------------*
*& Report ZGY_WORK3
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_work4.


INCLUDE:
zgy_work4_top,
zgy_work4_lcl,
zgy_work4_moduls.


START-OF-SELECTION.
  CREATE OBJECT go_local.
  go_local->call_screen( ).
