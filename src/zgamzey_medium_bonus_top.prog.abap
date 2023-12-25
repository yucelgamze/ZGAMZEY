*&---------------------------------------------------------------------*
*& Include          ZGAMZEY_BONUS_TOP
*&---------------------------------------------------------------------*
CLASS local DEFINITION DEFERRED.
DATA:go_local TYPE REF TO local.

DATA:go_alv_grid  TYPE REF TO cl_gui_alv_grid,
     go_container TYPE REF TO cl_gui_custom_container,
     gt_fieldcat  TYPE lvc_t_fcat,
     gs_fieldcat  TYPE lvc_s_fcat,
     gs_layout    TYPE lvc_s_layo.

TABLES:zgamzey_pers_t, zgamzey_bonus_t.

DATA:gt_persb TYPE TABLE OF zgamzey_pers_bonus_s,
     gs_persb TYPE zgamzey_pers_bonus_s.

PARAMETERS:p_tbutce TYPE int4.
