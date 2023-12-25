*&---------------------------------------------------------------------*
*& Include          ZGAMZEY_STUDY2_TOP
*&---------------------------------------------------------------------*

TABLES:zgy_t_log, zgy_s_log, sscrfields.

CLASS lcl_class DEFINITION DEFERRED.
DATA:go_local TYPE REF TO lcl_class.
DATA:go_alv_grid  TYPE REF TO cl_gui_alv_grid,
     go_container TYPE REF TO cl_gui_custom_container,
     gt_fcat      TYPE lvc_t_fcat,
     gs_fcat      TYPE lvc_s_fcat,
     gs_layout    TYPE lvc_s_layo.

DATA:gt_alv TYPE TABLE OF zgy_t_log,
     gs_alv TYPE zgy_t_log.

"dynamically update data from excel to database table
DATA:gt_excel       TYPE TABLE OF alsmex_tabline,
     gt_dref        TYPE REF TO data,
     gs_dref        TYPE REF TO data,
     gv_col         TYPE i,
     gt_table_filds TYPE TABLE OF dfies.

"dynamic table
DATA:go_dynamic TYPE REF TO data,
     gs_dynamic TYPE REF TO data.

FIELD-SYMBOLS:<dyn_table>   TYPE STANDARD TABLE,
              <gfs_s_table> ,
              <gfs>.

"şablon indirme butonu
DATA:gs_sel_button TYPE smp_dyntxt.
SELECTION-SCREEN FUNCTION KEY 1.

"excel upload
TYPES:BEGIN OF gty_list,
        matnr TYPE matnr,
        erdat TYPE erdat,
        ernam TYPE ernam,
      END OF gty_list.

DATA:gt_list TYPE TABLE OF gty_list,
     gs_list TYPE gty_list.

SELECTION-SCREEN BEGIN OF BLOCK b WITH FRAME TITLE TEXT-000.
PARAMETERS:p_file  TYPE localfile OBLIGATORY,
           p_table TYPE dd02l-tabname OBLIGATORY,
           p_test  AS CHECKBOX DEFAULT abap_true.
SELECTION-SCREEN END OF BLOCK b.

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
      DATA : lv_table TYPE w3objid.
    WHEN 'FC01'.

      lv_table = p_table.

      PERFORM download_template_xls USING lv_table.
  ENDCASE.
