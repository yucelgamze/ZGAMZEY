*&---------------------------------------------------------------------*
*& Report ZGAMZEY_STUDY2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgamzey_alv.

INCLUDE zgamzey_alv_top.
INCLUDE zgamzey_alv_lcl.
INCLUDE zgamzey_alv_moduls.


START-OF-SELECTION.
  CREATE OBJECT go_local.
  go_local->call_screen( ).
