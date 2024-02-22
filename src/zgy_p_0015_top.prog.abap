*&---------------------------------------------------------------------*
*& Include          ZGY_P_TOP
*&---------------------------------------------------------------------*
TABLES:mvke,zgy_t_0024,zgy_s_0031,zgy_t_0025.
CLASS lcl_class DEFINITION DEFERRED.
DATA: go_local TYPE REF TO lcl_class.
DATA: go_alv_grid  TYPE REF TO cl_gui_alv_grid,
      go_container TYPE REF TO cl_gui_custom_container,
      gt_fcat      TYPE lvc_t_fcat,
      gs_fcat      TYPE lvc_s_fcat,
      gs_layout    TYPE lvc_s_layo.

DATA: go_alv_grid2 TYPE REF TO cl_gui_alv_grid,
      gt_fcat2     TYPE lvc_t_fcat.

TYPES:BEGIN OF gty_alv,
        durum  TYPE icon_d,
        matnr  TYPE matnr,
        vkorg  TYPE vkorg,
        vtweg  TYPE vtweg,
        miktar TYPE int4,
        vbeln  TYPE vbeln_va,
        color  TYPE char4,
        style  TYPE lvc_t_styl,
      END OF gty_alv.

DATA:gt_alv TYPE TABLE OF gty_alv,
     gs_alv TYPE gty_alv.

FIELD-SYMBOLS:<gfs_alv> TYPE gty_alv.

DATA:gv_matnr  TYPE matnr,
     gv_vkorg  TYPE vkorg,
     gv_vtweg  TYPE vtweg,
     gv_miktar TYPE int4,
     gv_vbeln  TYPE vbeln_va.

DATA:gt_bapi TYPE TABLE OF zgy_t_0025,
     gs_bapi TYPE zgy_t_0025.

DATA:gv_exist1 TYPE char1,
     gv_exist2 TYPE char1,
     gv_exist3 TYPE char1.
