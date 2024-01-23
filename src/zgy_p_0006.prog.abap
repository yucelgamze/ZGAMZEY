*&---------------------------------------------------------------------*
*& Report ZGY_ALV_TEMPLATE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_p_0006.

INCLUDE:
zgy_p_0006_top,
zgy_p_0006_lcl,
zgy_p_0006_mdl.


START-OF-SELECTION.
  IF flag EQ abap_true.

*  CREATE OBJECT go_local.
    go_local = NEW lcl_class( ).
    go_local->call_screen( ).

  ENDIF.
