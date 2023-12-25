*&---------------------------------------------------------------------*
*& Report ZGY_WORK5
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_work7.

INCLUDE:
zgy_work7_top,
zgy_work7_lcl,
zgy_work7_mdl.

START-OF-SELECTION.
  CREATE OBJECT go_local.
  go_local->call_screen( ).
