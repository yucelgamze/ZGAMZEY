*&---------------------------------------------------------------------*
*& Report ZGY_WORK5
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_work8.

INCLUDE:zgy_work8_top,
        zgy_work8_lcl,
        zgy_work8_mdl.


START-OF-SELECTION.
  CREATE OBJECT go_local.
  go_local->call_screen( ).
