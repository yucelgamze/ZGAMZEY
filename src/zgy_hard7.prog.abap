*&---------------------------------------------------------------------*
*& Report ZGAMZEY_HARD7
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_hard7.

INCLUDE ZGY_HARD7_TOP.
*INCLUDE:zgamzey_hard7_top,
INCLUDE ZGY_HARD7_LCL.
*        zgamzey_hard7_lcl,
INCLUDE ZGY_HARD7_MDL.
*        zgamzey_hard7_moduls.

START-OF-SELECTION.
CREATE OBJECT go_local.
go_local->get_data( ).
go_local->call_screen( ).
