*&---------------------------------------------------------------------*
*& Report ZGY_0029
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_0029.
INCLUDE:
zgy_0029_top,
zgy_0029_lcl,
zgy_0029_mdl.

START-OF-SELECTION.

  go_local = NEW lcl_class( ).
  go_local->get_data( ).
  go_local->call_screen( ).