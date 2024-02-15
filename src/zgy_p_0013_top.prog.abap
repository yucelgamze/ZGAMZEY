*&---------------------------------------------------------------------*
*& Include          ZGY_SATIS_TOP
*&---------------------------------------------------------------------*

*--------------------------------------------------------------------*
TABLES:sscrfields.
*--------------------------------------------------------------------*
CLASS lcl_class DEFINITION DEFERRED.
DATA:go_local TYPE REF TO lcl_class.
DATA:go_alv_grid  TYPE REF TO cl_gui_alv_grid,
     go_container TYPE REF TO cl_gui_custom_container,
     gt_fcat      TYPE lvc_t_fcat,
     gs_fcat      TYPE lvc_s_fcat,
     gs_layout    TYPE lvc_s_layo.

DATA:gt_alv TYPE TABLE OF zgy_t_0019,
     gs_alv TYPE zgy_t_0019.

DATA:gv_ad   TYPE sy-uname,
     gv_data TYPE zgy_de_0039.
*--------------------------------------------------------------------*
"excel download için header
TYPES:BEGIN OF gty_header,
        line TYPE char30,
      END OF gty_header.

DATA:gt_header TYPE TABLE OF gty_header,
     gs_header TYPE gty_header.

DATA:gv_filename TYPE string,
     gv_folder   TYPE string.

"excel upload
TYPES:BEGIN OF gty_list,
        ad   TYPE sy-uname,
        data TYPE zgy_de_0038,
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
      PERFORM download_template_xls USING 'ZGY_DEMO'.
  ENDCASE.
