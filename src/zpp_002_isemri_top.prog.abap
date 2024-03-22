*&---------------------------------------------------------------------*
*& Include          ZGY_P_TOP
*&---------------------------------------------------------------------*
TABLES:caufv,resb,mara.
CLASS lcl_class DEFINITION DEFERRED.
DATA:go_local     TYPE REF TO lcl_class,
     go_alv_grid  TYPE REF TO cl_gui_alv_grid,            "Başlık
     go_alv_grid2 TYPE REF TO cl_gui_alv_grid,            "Kalem
     go_container TYPE REF TO cl_gui_custom_container,
     gt_fcat      TYPE lvc_t_fcat,
     gt_fcat2     TYPE lvc_t_fcat,
     gs_fcat      TYPE lvc_s_fcat,
     gs_layout    TYPE lvc_s_layo.

"ADOBE IMPORT PARAMETRELERİ
DATA:gs_data  TYPE zpp_002_s_isemri_h,
     gt_data  TYPE zpp_002_tt_isemri_h,
     gt_table TYPE TABLE OF zpp_002_s_isemri,
     gs_table TYPE zpp_002_s_isemri.

"Adobe Tanımlamaları
DATA: fm_name         TYPE rs38l_fnam,
      fp_docparams    TYPE sfpdocparams,
      fp_outputparams TYPE sfpoutputparams.

SELECTION-SCREEN BEGIN OF BLOCK a WITH FRAME TITLE TEXT-000.
  PARAMETERS:p_aufnr TYPE aufnr.
SELECTION-SCREEN END OF BLOCK a.
