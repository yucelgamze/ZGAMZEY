*&---------------------------------------------------------------------*
*& Report ZGY_VBAK
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_vbak.

INCLUDE:zgy_vbak_top,
        zgy_vbak_lcl,
        zgy_vbak_mdl.

START-OF-SELECTION.
  CREATE OBJECT go_local.
  go_local->call_screen( ).
