*&---------------------------------------------------------------------*
*& Report ZGY_REUSEALV_001
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_reusealv_002.

INCLUDE zgy_reusealv_002_top.
INCLUDE zgy_reusealv_002_frm.


START-OF-SELECTION.

  PERFORM get_data.
  PERFORM set_fcat.
  PERFORM set_layout.
  PERFORM display_alv.
