*&---------------------------------------------------------------------*
*& Report ZGY_WORK5
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_work6.

INCLUDE:
zgy_work6_top,
zgy_work6_lcl,
zgy_work6_moduls.


START-OF-SELECTION.
  CREATE OBJECT go_local.
  go_local->call_screen( ).
