*&---------------------------------------------------------------------*
*& Include          ZGAMZEY_HARD6_TOP
*&---------------------------------------------------------------------*
CLASS local DEFINITION DEFERRED.
DATA:go_local TYPE REF TO local.

DATA:go_alv_grid  TYPE REF TO cl_gui_alv_grid,
     go_container TYPE REF TO cl_gui_custom_container,
     gt_fieldcat  TYPE lvc_t_fcat,
     gs_fieldcat  TYPE lvc_s_fcat,
     gs_layout    TYPE lvc_s_layo.

DATA:
     gs_sip     TYPE zgamzey_sipari_t,
     gt_siparis TYPE TABLE OF zgamzey_siparis_s,
     gs_siparis TYPE zgamzey_siparis_s.

DATA:gv_vbeln TYPE vbeln_va,
     gv_matnr TYPE matnr,
     gv_labst TYPE labst.
