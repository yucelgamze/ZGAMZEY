*&---------------------------------------------------------------------*
*& Include          ZGAMZEY_HARD9_TOP
*&---------------------------------------------------------------------*
CLASS local DEFINITION DEFERRED.
DATA:go_local TYPE REF TO local.

DATA:go_alv_grid  TYPE REF TO cl_gui_alv_grid,
     go_container TYPE REF TO cl_gui_custom_container,
     gt_fieldcat  TYPE lvc_t_fcat,
     gs_fieldcat  TYPE lvc_s_fcat,
     gs_layout    TYPE lvc_s_layo.

DATA:gt_alv TYPE TABLE OF zgamzey_urun_agac_s,
     gs_alv TYPE zgamzey_urun_agac_s.

TABLES:zgamzey_urun_t, zgamzey_stok_t.
