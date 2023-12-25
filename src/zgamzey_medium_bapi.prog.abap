*&---------------------------------------------------------------------*
*& Report ZGAMZEY_MEDIUM_BAPI
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgamzey_medium_bapi.

INCLUDE:
zgamzey_medium_bapi_top,
zgamzey_medium_bapi_class,
zgamzey_medium_bapi_moduls.

START-OF-SELECTION.
CREATE OBJECT go_local.
go_local->get_data( ) .
go_local->call_screen( ).
