*&---------------------------------------------------------------------*
*& Report ZGY_DALV
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_dalv.

INCLUDE: zgy_dalv_top,
         zgy_dalv_lcl,
         zgy_dalv_mdl.

START-OF-SELECTION.
*  CREATE OBJECT go_local.
  go_local = NEW lcl_class( ).
  go_local->call_screen( ).
