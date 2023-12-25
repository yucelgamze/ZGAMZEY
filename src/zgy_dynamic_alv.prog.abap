*&---------------------------------------------------------------------*
*& Report ZGY_WORK10
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_dynamic_alv.

INCLUDE zgy_dynamic_alv_top.
*INCLUDE:zgy_work10_top,
INCLUDE zgy_dynamic_alv_lcl.
*        zgy_work10_lcl,
INCLUDE zgy_dynamic_alv_mdl.
*        zgy_work10_mdl.

START-OF-SELECTION.
  CREATE OBJECT go_local.
  go_local->call_screen( ).
