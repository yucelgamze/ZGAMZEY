*&---------------------------------------------------------------------*
*& Report ZGAMZEY_ADVANCED2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgamzey_advanced2.

INCLUDE:zgamzey_advanced2_top,
        zgamzey_advanced2_lcl,
        zgamzey_advanced2_moduls.


START-OF-SELECTION.
CREATE OBJECT go_local.
go_local->call_screen( ).
