*&---------------------------------------------------------------------*
*& Report ZGY_REUSEALV_001
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_reusealv_001.

INCLUDE:zgy_reusealv_001_top,
        zgy_reusealv_001_frm.


START-OF-SELECTION.

  PERFORM get_data.
  PERFORM set_fcat.
  PERFORM set_layout.
  PERFORM display_alv.
