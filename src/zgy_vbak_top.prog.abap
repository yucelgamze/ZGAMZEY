*&---------------------------------------------------------------------*
*& Include          ZGY_VBAK_TOP
*&---------------------------------------------------------------------*
CLASS lcl_class DEFINITION DEFERRED.
DATA:go_local TYPE REF TO lcl_class.
DATA:go_alv_grid  TYPE REF TO cl_gui_alv_grid,
     go_container TYPE REF TO cl_gui_custom_container,
     gt_fcat      TYPE lvc_t_fcat,
     gs_fcat      TYPE lvc_s_fcat,
     gs_layout    TYPE lvc_s_layo.

TABLES:zgy_t_vbak,vbak.

DATA:gt_alv     TYPE TABLE OF zgy_t_vbak,
     gs_alv     TYPE zgy_t_vbak.

SELECTION-SCREEN BEGIN OF BLOCK a WITH FRAME TITLE TEXT-000.
SELECT-OPTIONS:so_audat FOR vbak-audat NO INTERVALS,
               so_vbtyp FOR vbak-vbtyp NO INTERVALS,
               so_auart FOR vbak-auart NO INTERVALS.
SELECTION-SCREEN END OF BLOCK a.
