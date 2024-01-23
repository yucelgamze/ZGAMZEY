*&---------------------------------------------------------------------*
*& Report ZGY_ALV_TEMPLATE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_sd_va05.

INCLUDE:
zgy_sd_va05_top,
zgy_sd_va05_lcl,
zgy_sd_va05_mdl.

START-OF-SELECTION.
*  CREATE OBJECT go_local.
  go_local = NEW lcl_class( ).
  go_local->call_screen( ).
