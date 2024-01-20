*&---------------------------------------------------------------------*
*& Include          ZGAMZEY_HARD7_TOP
*&---------------------------------------------------------------------*
CLASS local DEFINITION DEFERRED.
DATA:go_local TYPE REF TO local.

DATA:go_alv_grid  TYPE REF TO cl_gui_alv_grid,
     go_container TYPE REF TO cl_gui_custom_container,
     gt_fieldcat  TYPE lvc_t_fcat,
     gs_fieldcat  TYPE lvc_s_fcat,
     gs_layout    TYPE lvc_s_layo.

DATA:go_alv_grid_2  TYPE REF TO cl_gui_alv_grid,
     go_container_2 TYPE REF TO cl_gui_custom_container,
     gt_fieldcat_2  TYPE lvc_t_fcat,
     gs_fieldcat_2  TYPE lvc_s_fcat,
     gs_layout_2    TYPE lvc_s_layo.

DATA:gt_user_l TYPE TABLE OF zgamzey_user_l_s,
     gt_profil TYPE TABLE OF zgamzey_profil_l_s.

DATA:gv_flag TYPE xfeld.
