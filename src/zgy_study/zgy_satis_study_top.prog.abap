*&---------------------------------------------------------------------*
*& Include          ZGY_SATIS_TOP
*&---------------------------------------------------------------------*
CLASS lcl_class DEFINITION DEFERRED.
DATA:go_local TYPE REF TO lcl_class.
DATA:go_alv_grid  TYPE REF TO cl_gui_alv_grid,
     go_container TYPE REF TO cl_gui_custom_container,
     gt_fcat      TYPE lvc_t_fcat,
     gs_fcat      TYPE lvc_s_fcat,
     gs_layout    TYPE lvc_s_layo.

TABLES:vbak, vbap.

DATA:gt_alv TYPE TABLE OF zgy_s_satis,
     gs_alv TYPE zgy_s_satis.

"ADOBE IMPORT PARAMETRELERİ
DATA:gt_items  TYPE zgy_tt_satis_item,
     gs_header TYPE zgy_s_satis.

"Adobe Tanımlamaları
DATA: fm_name         TYPE rs38l_fnam,
      fp_docparams    TYPE sfpdocparams,
      fp_outputparams TYPE sfpoutputparams.

SELECTION-SCREEN BEGIN OF BLOCK a WITH FRAME TITLE TEXT-000.
SELECT-OPTIONS:so_vbeln FOR vbak-vbeln.
SELECTION-SCREEN END OF BLOCK a.
