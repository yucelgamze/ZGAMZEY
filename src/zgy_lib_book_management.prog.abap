*&---------------------------------------------------------------------*
*& Report ZGY_LIB_BOOK_MANAGEMENT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_lib_book_management.

INCLUDE:zgy_lib_book_management_top,
        zgy_lib_book_management_lcl,
        zgy_lib_book_management_mdl.

START-OF-SELECTION.
CREATE OBJECT go_local.
go_local->call_screen( ).
