*&---------------------------------------------------------------------*
*& Include          ZGY_P_TOP
*&---------------------------------------------------------------------*
TABLES:vbak,vbap.
CLASS lcl_class DEFINITION DEFERRED.
DATA: go_local TYPE REF TO lcl_class.
DATA: go_alv_grid  TYPE REF TO cl_gui_alv_grid,
      go_container TYPE REF TO cl_gui_custom_container,
      gt_fcat      TYPE lvc_t_fcat,
      gs_fcat      TYPE lvc_s_fcat,
      gs_layout    TYPE lvc_s_layo.

DATA:gt_alv TYPE TABLE OF zgy_s_0027,
     gs_alv TYPE zgy_s_0027.

"smartform
DATA:gs_header TYPE zgy_s_0027,
     gt_items  TYPE zgy_tt_0028.

"smartform verileri
DATA:gv_fm_name   TYPE rs38l_fnam,
     gs_controls  TYPE ssfctrlop,
     gs_output_op TYPE ssfcompop.

SELECTION-SCREEN BEGIN OF BLOCK a WITH FRAME TITLE TEXT-000.
SELECT-OPTIONS:so_vbeln FOR vbak-vbeln.
*NO INTERVALS.
SELECTION-SCREEN END OF BLOCK a.
