*&---------------------------------------------------------------------*
*& Include          ZGY_DYNAMIC_TOP
*&---------------------------------------------------------------------*

TYPE-POOLS:icon.
TABLES:zgy_t_il, zgy_t_ilce, zgy_t_ililce, zgy_s_ililce,
       ekko, ekpo,zgy_s_satinalma, zgy_s_satinalma_items, sscrfields, vbak, zgy_t_satis.

CLASS lcl_class DEFINITION DEFERRED.
DATA:go_local TYPE REF TO lcl_class.
DATA:go_alv_grid  TYPE REF TO cl_gui_alv_grid,
     go_container TYPE REF TO cl_gui_custom_container,
     gt_fcat      TYPE lvc_t_fcat,
     gs_fcat      TYPE lvc_s_fcat,
     gs_layout    TYPE lvc_s_layo.

DATA:gt_alv       TYPE TABLE OF zgy_s_ililce,
     gs_alv       TYPE zgy_s_ililce,
     gt_ilcetanım TYPE TABLE OF zgy_s_ililce.

"dynamic table
DATA:go_dynamic TYPE REF TO data,
     gs_dynamic TYPE REF TO data.

FIELD-SYMBOLS:<dyn_table>   TYPE STANDARD TABLE,
              <gfs_s_table>,
              <gfs>.

DATA:go_alv_grid2  TYPE REF TO cl_gui_alv_grid,
     go_container2 TYPE REF TO cl_gui_custom_container,
     gt_fcat2      TYPE lvc_t_fcat,
     gs_fcat2      TYPE lvc_s_fcat.

DATA:gt_al TYPE TABLE OF zgy_s_satinalma,
     gs_al TYPE zgy_s_satinalma.

"adobe form imports
DATA:gs_header TYPE zgy_s_satinalma,
     gt_items  TYPE zgy_tt_satinalma_items.

"Adobe Tanımlamaları
DATA: fm_name         TYPE rs38l_fnam,
      fp_docparams    TYPE sfpdocparams,
      fp_outputparams TYPE sfpoutputparams.

SELECTION-SCREEN BEGIN OF BLOCK a WITH FRAME TITLE TEXT-000.
SELECT-OPTIONS:so_ebeln FOR ekko-ebeln.
SELECTION-SCREEN END OF BLOCK a.

"process pushbutton lı alvler
TYPES:BEGIN OF gty_islem,
        vbeln   TYPE vbeln_va,
        ernam   TYPE ernam,
        audat   TYPE audat,
        zprocess  TYPE zgy_de_process,
      END OF gty_islem.

DATA:gt_del TYPE TABLE OF gty_islem,
     gt_add TYPE TABLE OF gty_islem.

DATA:go_alv_grid_del  TYPE REF TO cl_gui_alv_grid,
     go_container_del TYPE REF TO cl_gui_custom_container,
     gt_fcat_del      TYPE lvc_t_fcat,
     gs_fcat_del      TYPE lvc_s_fcat.

DATA:go_alv_grid_add  TYPE REF TO cl_gui_alv_grid,
     go_container_add TYPE REF TO cl_gui_custom_container,
     gt_fcat_add      TYPE lvc_t_fcat,
     gs_fcat_add      TYPE lvc_s_fcat.

"excel upload
TYPES:BEGIN OF gty_list,
        ebeln TYPE  ebeln,
        bukrs TYPE  bukrs,
        bstyp TYPE  ebstyp,
        bsart TYPE  esart,
        statu TYPE  estak,
        aedat TYPE  erdat,
        ernam TYPE  ernam,
      END OF gty_list.

DATA:gt_list TYPE TABLE OF gty_list,
     gs_list TYPE gty_list.

DATA:go_alv_grid3  TYPE REF TO cl_gui_alv_grid,
     go_container3 TYPE REF TO cl_gui_custom_container.

SELECTION-SCREEN BEGIN OF BLOCK b WITH FRAME TITLE TEXT-001.
PARAMETERS:p_file TYPE localfile.
SELECTION-SCREEN END OF BLOCK b.

"şablon indirme butonu
DATA:gs_sel_button TYPE smp_dyntxt.
SELECTION-SCREEN FUNCTION KEY 1.

"p_file için search help

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      program_name  = syst-cprog
      dynpro_number = syst-dynnr
      field_name    = 'P_FILE'
    IMPORTING
      file_name     = p_file.

  "swm0 objesi ile buton bağlantısı

AT SELECTION-SCREEN.
  CASE sscrfields-ucomm.
    WHEN 'FC01'.
      PERFORM download_template_xls USING 'ZGY_SATINALMA_TEMPLATE'.
  ENDCASE.
