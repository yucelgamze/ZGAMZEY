*&---------------------------------------------------------------------*
*& Report ZGY_ALV_TEMPLATE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_alv_template.

INCLUDE:
zgy_p_top,
zgy_p_lcl,
zgy_p_mdl.

START-OF-SELECTION.
*  CREATE OBJECT go_local.
  go_local = NEW lcl_class( ).
  go_local->call_screen( ).
