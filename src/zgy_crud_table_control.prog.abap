*&---------------------------------------------------------------------*
*& Report ZGY_CRUD_TABLE_CONTROL
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_crud_table_control.

INCLUDE:
zgy_crud_table_control_top,
zgy_crud_table_control_lcl,
zgy_crud_table_control_mdl.


START-OF-SELECTION.
CREATE OBJECT go_local.
 go_local->call_screen( ).
