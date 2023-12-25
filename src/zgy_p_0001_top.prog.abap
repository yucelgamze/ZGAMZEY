*&---------------------------------------------------------------------*
*& Include          ZGY_P_0001_TOP
*&---------------------------------------------------------------------*
TABLES:vbak,vbap.
CLASS lcl_local DEFINITION DEFERRED.
DATA:go_local TYPE REF TO lcl_local.
DATA:go_alv_grid  TYPE REF TO cl_gui_alv_grid,
     go_container TYPE REF TO cl_gui_custom_container,
     gt_fcat      TYPE lvc_t_fcat,
     gs_fcat      TYPE lvc_s_fcat,
     gs_layout    TYPE lvc_s_layo.

DATA:gt_alv TYPE TABLE OF zgy_s_0014,
     gs_alv TYPE zgy_s_0014.

"ADOBE IMPORT PARAMETRELERİ
DATA:gs_header TYPE zgy_s_0014,
     gt_items  TYPE zgy_tt_0015.

"Adobe Tanımlamaları
DATA: fm_name         TYPE rs38l_fnam,
      fp_docparams    TYPE sfpdocparams,
      fp_outputparams TYPE sfpoutputparams.

SELECTION-SCREEN BEGIN OF BLOCK a WITH FRAME TITLE TEXT-000.
SELECT-OPTIONS:so_vbeln FOR vbak-vbeln.
SELECTION-SCREEN END OF BLOCK a.
