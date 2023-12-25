*&---------------------------------------------------------------------*
*& Report ZGY_LIB_MEMBER_MANAGEMENT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_lib_member_management.

INCLUDE:zgy_lib_member_management_top,
        zgy_lib_member_management_lcl,
        zgy_lib_member_management_mdl.

START-OF-SELECTION.
CREATE OBJECT go_local.
go_local->call_screen( ).
