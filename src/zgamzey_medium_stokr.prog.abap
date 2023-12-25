*&---------------------------------------------------------------------*
*& Report ZGAMZEY_MEDIUM_STOKR
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgamzey_medium_stokr.

INCLUDE:zgamzey_medium_stokr_top,
        zgamzey_medium_stokr_class,
        zgamzey_medium_stokr_moduls.

START-OF-SELECTION.
CREATE OBJECT go_local.
go_local->get_data( ).
go_local->call_screen( ).
