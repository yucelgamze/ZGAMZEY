*&---------------------------------------------------------------------*
*& Include          ZGAMZEY_MEDIUM_BAPI_TOP
*&---------------------------------------------------------------------*
CLASS local DEFINITION DEFERRED.
DATA:go_local TYPE REF TO local.

DATA:gv_matnr TYPE matnr.

*PARAMETERS:p_matnr TYPE matnr.
SELECT-OPTIONS:so_matnr FOR gv_matnr NO INTERVALS.

TABLES:zgamzey_medium_bapi_s.

DATA:gt_bapi TYPE TABLE OF zgamzey_medium_bapi_s,
     gs_bapi TYPE zgamzey_medium_bapi_s.

DATA:go_alv_grid  TYPE REF TO cl_gui_alv_grid,
     go_container TYPE REF TO cl_gui_custom_container,
     gt_fieldcat  TYPE lvc_t_fcat,
     gs_fieldcat  TYPE lvc_s_fcat,
     gs_layout    TYPE lvc_s_layo.
