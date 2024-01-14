*&---------------------------------------------------------------------*
*& Include          ZGY_0029_TOP
*&---------------------------------------------------------------------*
CLASS lcl_class DEFINITION DEFERRED.
DATA:go_local     TYPE REF TO lcl_class,
     go_alv_grid  TYPE REF TO cl_gui_alv_grid,
     go_container TYPE REF TO cl_gui_custom_container,
     gt_fcat      TYPE lvc_t_fcat,
     gs_fcat      TYPE lvc_s_fcat,
     gs_layout    TYPE lvc_s_layo.

TABLES:zgy_t_0016, zders_detay, zgy_s_0019.

DATA:gv_ogr_id    TYPE  zgy_de_0027,
     gv_ogr_ad    TYPE  zgy_de_0028,
     gv_ogr_soyad TYPE  zgy_de_0029,
     gv_ders_id   TYPE  zgy_de_0030,
     gv_puan      TYPE  zgy_de_0031.

DATA:gt_alv TYPE TABLE OF zgy_s_0019,
     gs_alv TYPE zgy_s_0019.

SELECTION-SCREEN BEGIN OF BLOCK a WITH FRAME TITLE TEXT-000.
PARAMETERS:p_select RADIOBUTTON GROUP x,
           p_insert RADIOBUTTON GROUP x,
           p_update RADIOBUTTON GROUP x,
           p_delete RADIOBUTTON GROUP x.
SELECTION-SCREEN END OF BLOCK a.
