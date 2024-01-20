*&---------------------------------------------------------------------*
*& Report ZGAMZEY_MEDIUM_STOKR
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_medium_stokr.

INCLUDE ZGY_MEDIUM_STOKR_TOP.
*INCLUDE:zgamzey_medium_stokr_top,
INCLUDE ZGY_MEDIUM_STOKR_LCL.
*        zgamzey_medium_stokr_class,
INCLUDE ZGY_MEDIUM_STOKR_MDL.
*        zgamzey_medium_stokr_moduls.

START-OF-SELECTION.
CREATE OBJECT go_local.
go_local->get_data( ).
go_local->call_screen( ).
