*&---------------------------------------------------------------------*
*& Include          ZGY_P_TOP
*&---------------------------------------------------------------------*
CLASS lcl_class DEFINITION DEFERRED.
DATA: go_local TYPE REF TO lcl_class.
DATA: go_alv_grid  TYPE REF TO cl_gui_alv_grid,
      go_container TYPE REF TO cl_gui_custom_container,
      gt_fcat      TYPE lvc_t_fcat,
      gs_fcat      TYPE lvc_s_fcat,
      gs_layout    TYPE lvc_s_layo.

DATA:gt_alv   TYPE TABLE OF mara,
     gs_alv   TYPE mara,
     gv_matnr TYPE matnr.

SELECT-OPTIONS:so_matnr FOR gv_matnr .
*NO INTERVALS.
