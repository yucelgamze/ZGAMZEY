*&---------------------------------------------------------------------*
*& Report ZGAMZEY_STUDY2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_log MESSAGE-ID zgy_mc_0002.

INCLUDE:
zgy_log_top,
zgy_log_lcl,
zgy_log_frm,
zgy_log_mdl.

INITIALIZATION.
*  CREATE OBJECT go_local.
  go_local = NEW lcl_class( ) . ""NEW SYNTAX !!!!!
  go_local->template_xls_button( ).

START-OF-SELECTION.
*  CREATE OBJECT go_local.
  go_local = NEW lcl_class( ).
  go_local->get_data( ).
*  go_local->log_excel( ).
*  go_local->call_screen( ).
