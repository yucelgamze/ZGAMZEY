*&---------------------------------------------------------------------*
*& Include          ZGY_P_0018_TOP
*&---------------------------------------------------------------------*
TABLES:mara,makt.
CLASS lcl_class DEFINITION DEFERRED.
DATA:go_local     TYPE REF TO lcl_class,
     go_alv_grid  TYPE REF TO cl_gui_alv_grid,
     go_container TYPE REF TO cl_gui_custom_container,
     gt_fcat      TYPE lvc_t_fcat,
     gs_fcat      TYPE lvc_s_fcat,
     gs_layout    TYPE lvc_s_layo.

DATA:gt_alv TYPE TABLE OF zgy_s_0034,
     gs_alv TYPE zgy_s_0034.

"Adobe Tanımlamaları
DATA: fm_name         TYPE rs38l_fnam,
      fp_docparams    TYPE sfpdocparams,
      fp_outputparams TYPE sfpoutputparams.
DATA:gs_data TYPE zgy_s_0034.

SELECTION-SCREEN BEGIN OF BLOCK a WITH FRAME TITLE TEXT-000.
SELECT-OPTIONS:so_matnr FOR mara-matnr NO INTERVALS.
SELECTION-SCREEN END OF BLOCK a.
