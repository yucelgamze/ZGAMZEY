*&---------------------------------------------------------------------*
*& Report ZGAMZEY_MEDIUM_BAPI
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_medium_bapi.


INCLUDE zgy_medium_bapi_top.
*zgamzey_medium_bapi_top,
INCLUDE zgy_medium_bapi_lcl.
*zgamzey_medium_bapi_class,
INCLUDE zgy_medium_bapi_mdl.
*zgamzey_medium_bapi_moduls.

START-OF-SELECTION.
  CREATE OBJECT go_local.
  go_local->get_data( ) .
  go_local->call_screen( ).
