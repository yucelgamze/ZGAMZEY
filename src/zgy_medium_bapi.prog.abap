*&---------------------------------------------------------------------*
*& Report ZGAMZEY_MEDIUM_BAPI
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_medium_bapi.

INCLUDE:
INCLUDE ZGY_MEDIUM_BAPI_TOP.
*zgamzey_medium_bapi_top,
INCLUDE ZGY_MEDIUM_BAPI_LCL.
*zgamzey_medium_bapi_class,
INCLUDE ZGY_MEDIUM_BAPI_MDL.
*zgamzey_medium_bapi_moduls.

START-OF-SELECTION.
CREATE OBJECT go_local.
go_local->get_data( ) .
go_local->call_screen( ).
