*&---------------------------------------------------------------------*
*& Report ZGAMZEY_WORK1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_personal_tab MESSAGE-ID zpers_mc.

INCLUDE:
zgy_personal_tab_top,
zgy_personal_tab_lcl,
zgy_personal_tab_mdl.


START-OF-SELECTION.

  CREATE OBJECT go_local.
  go_local->get_data( ).
  go_local->call_screen( ).
