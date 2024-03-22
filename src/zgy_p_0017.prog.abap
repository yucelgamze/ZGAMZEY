*&---------------------------------------------------------------------*
*& Report ZGY_P_0017
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_p_0017.

INCLUDE:zgy_p_0017_top,
        zgy_p_0017_lcl,
        zgy_p_0017_mdl.

START-OF-SELECTION.
  go_local = NEW lcl_class( ).

  go_local->upload_xls( ).

*  go_local->max_rows = 11368.
*  go_local->header_rows_count = 1.
*  go_local->upload(
*    CHANGING
*      ct_data = gt_xls
*  ).

  go_local->call_func( ).
  go_local->call_screen( ).
