*&---------------------------------------------------------------------*
*& Include          ZGAMZEY_HARD4_TOP
*&---------------------------------------------------------------------*
CLASS local DEFINITION DEFERRED.
DATA:go_local TYPE REF TO local.

DATA:go_alv_grid  TYPE REF TO cl_gui_alv_grid,
     go_container TYPE REF TO cl_gui_custom_container,
     gt_fieldcat  TYPE lvc_t_fcat,
     gs_fieldcat  TYPE lvc_s_fcat,
     gs_layout    TYPE lvc_s_layo.

TABLES:zenvanter_t, zenvanter_l_t,zenvanterlist_s.

DATA:gt_env TYPE TABLE OF zenvanterlist_s,
     gs_env TYPE zenvanterlist_s.

"excel to itab
TYPES:BEGIN OF gty_itab,
        envanter_id TYPE zenvanter_id,
        adet        TYPE zadet,
      END OF gty_itab.

DATA:gt_itab     TYPE TABLE OF gty_itab,
     gs_itab     TYPE gty_itab,
     gt_raw_data TYPE  truxs_t_text_data.

PARAMETERS:p_file TYPE rlgrap-filename.

"itab to excel
SELECTION-SCREEN:
PUSHBUTTON /2(20) button USER-COMMAND but1.

TABLES: sscrfields.

DATA:gv_filename TYPE string,
     gv_folder   TYPE string.

TYPES:BEGIN OF gty_header,
        line TYPE char30,
      END OF gty_header.
DATA:gt_header TYPE TABLE OF gty_header,
     gs_header TYPE gty_header.
