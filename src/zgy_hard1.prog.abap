*&---------------------------------------------------------------------*
*& Report ZGAMZEY_HARD_1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_hard1.


INCLUDE zgy_hard1_top.
* zgamzey_hard_1_top,
INCLUDE zgy_hard1_lcl.
* zgamzey_hard_1_lcl,
INCLUDE zgy_hard1_mdl.
* zgamzey_hard_1_moduls.

START-OF-SELECTION.
  CREATE OBJECT go_local.
  go_local->get_data( ).
  go_local->call_screen( ).
