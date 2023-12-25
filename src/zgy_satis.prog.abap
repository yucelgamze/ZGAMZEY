*&---------------------------------------------------------------------*
*& Report ZGY_SATIS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_satis.

INCLUDE:zgy_satis_top,
        zgy_satis_lcl,
        zgy_satis_mdl.

START-OF-SELECTION.
  CREATE OBJECT go_local.
  go_local->call_screen( ).
