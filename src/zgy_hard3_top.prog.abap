*&---------------------------------------------------------------------*
*& Include          ZGAMZEY_HARD3_TOP
*&---------------------------------------------------------------------*
CLASS local DEFINITION DEFERRED.
DATA:go_local TYPE REF TO local.

DATA:go_alv_grid  TYPE REF TO cl_gui_alv_grid,
     go_container TYPE REF TO cl_gui_custom_container,
     gt_fieldcat  TYPE lvc_t_fcat,
     gs_fieldcat  TYPE lvc_s_fcat,
     gs_layout    TYPE lvc_s_layo.

TABLES:zrezervestok_t, makt, zrezerve_s.

DATA:gt_rezerve TYPE TABLE OF zrezerve_s,
     gs_rezerve type zrezerve_s,
     gs_stok    TYPE zrezervestok_t.

DATA:gv_matnr        TYPE matnr,
     gv_rezerve_stok TYPE labst.
