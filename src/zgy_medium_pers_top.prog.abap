*&---------------------------------------------------------------------*
*& Include          ZGAMZEY_MEDIUM_PERS_TOP
*&---------------------------------------------------------------------*
CLASS local DEFINITION DEFERRED.
DATA:go_local TYPE REF TO local.

DATA:go_alv_grid  TYPE REF TO cl_gui_alv_grid,
     go_container TYPE REF TO cl_gui_custom_container,
     gt_fieldcat  TYPE lvc_t_fcat,
     gs_fieldcat  TYPE lvc_s_fcat,
     gs_layout    TYPE lvc_s_layo.

TABLES:zgamzey_worker_t.

DATA:gt_worker TYPE TABLE OF zgamzey_worker_s,
     gs_worker TYPE zgamzey_worker_s.
