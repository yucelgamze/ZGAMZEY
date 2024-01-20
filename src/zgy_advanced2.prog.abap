*&---------------------------------------------------------------------*
*& Report ZGAMZEY_ADVANCED2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_advanced2.

INCLUDE ZGY_ADVANCED2_TOP.
*INCLUDE:zgamzey_advanced2_top,
INCLUDE ZGY_ADVANCED2_LCL.
*        zgamzey_advanced2_lcl,
INCLUDE ZGY_ADVANCED2_MDL.
*        zgamzey_advanced2_moduls.


START-OF-SELECTION.
CREATE OBJECT go_local.
go_local->call_screen( ).
