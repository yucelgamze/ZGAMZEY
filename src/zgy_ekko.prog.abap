*&---------------------------------------------------------------------*
*& Report ZGY_EKKO
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_ekko.

INCLUDE:zgy_ekko_top,
        zgy_ekko_lcl,
        zgy_ekko_mdl.

START-OF-SELECTION.
  CREATE OBJECT go_local.
  go_local->call_screen( ).
