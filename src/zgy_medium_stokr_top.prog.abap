*&---------------------------------------------------------------------*
*& Include          ZGAMZEY_MEDIUM_STOKR_TOP
*&---------------------------------------------------------------------*
CLASS local DEFINITION DEFERRED.
DATA:go_local TYPE REF TO local.

DATA:go_alv_grid  TYPE REF TO cl_gui_alv_grid,
     go_container TYPE REF TO cl_gui_custom_container,
     gt_fieldcat  TYPE lvc_t_fcat,
     gs_fieldcat  TYPE lvc_s_fcat,
     gs_layout    TYPE lvc_s_layo.

TABLES:mara,makt,mard,t001l,t001w.

DATA:gt_stok TYPE TABLE OF zgamzey_stok_s,
     gs_stok TYPE zgamzey_stok_s.

DATA:gv_matnr TYPE matnr.
PARAMETERS:p_spras TYPE spras.

SELECT-OPTIONS:so_matnr FOR gv_matnr NO INTERVALS.
