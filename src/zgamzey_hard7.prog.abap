*&---------------------------------------------------------------------*
*& Report ZGAMZEY_HARD7
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgamzey_hard7.

INCLUDE:zgamzey_hard7_top,
        zgamzey_hard7_lcl,
        zgamzey_hard7_moduls.

START-OF-SELECTION.
CREATE OBJECT go_local.
go_local->get_data( ).
go_local->call_screen( ).
