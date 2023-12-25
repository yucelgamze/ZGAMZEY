*&---------------------------------------------------------------------*
*& Include          ZGY_SATIS_TOP
*&---------------------------------------------------------------------*

TABLES:vbak, vbap, sscrfields.

CLASS lcl_class DEFINITION DEFERRED.
DATA:go_local TYPE REF TO lcl_class.
DATA:go_alv_grid  TYPE REF TO cl_gui_alv_grid,
     go_container TYPE REF TO cl_gui_custom_container,
     gt_fcat      TYPE lvc_t_fcat,
     gs_fcat      TYPE lvc_s_fcat,
     gs_layout    TYPE lvc_s_layo.

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

"excel upload
TYPES:BEGIN OF gty_list,
        vbeln TYPE  vbeln_va,
        erdat TYPE  erdat,
        ernam TYPE  ernam,
        audat TYPE  audat,
        auart TYPE  auart,
        vkorg TYPE  vkorg,
        vtweg TYPE  vtweg,
      END OF gty_list.

DATA:gt_list TYPE TABLE OF gty_list,
     gs_list TYPE gty_list.

DATA:go_alv_grid2  TYPE REF TO cl_gui_alv_grid,
     go_container2 TYPE REF TO cl_gui_custom_container.

SELECTION-SCREEN BEGIN OF BLOCK b WITH FRAME TITLE TEXT-001.
PARAMETERS:p_file TYPE localfile.
SELECTION-SCREEN END OF BLOCK b.

"şablon indirme butonu
DATA:gs_sel_button TYPE smp_dyntxt.
SELECTION-SCREEN FUNCTION KEY 1.

"search help for p_file

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      program_name  = syst-cprog
      dynpro_number = syst-dynnr
      field_name    = 'P_FILE'
    IMPORTING
      file_name     = p_file.

  "Şablon indirme butonu için smw0 daki obje bağlantısı

AT SELECTION-SCREEN.
  CASE sscrfields-ucomm.
    WHEN 'FC01'.
      PERFORM download_template_xls USING 'ZGY_EXCEL_UPLOAD'.
  ENDCASE.
