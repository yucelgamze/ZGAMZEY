*&---------------------------------------------------------------------*
*& Include          ZGAMZEY_ADVANCED1_TOP
*&---------------------------------------------------------------------*
CLASS lcl_class DEFINITION DEFERRED.
DATA:go_local TYPE REF TO lcl_class.

DATA:go_alv_grid  TYPE REF TO cl_gui_alv_grid,
     go_container TYPE REF TO cl_gui_custom_container,
     gt_fieldcat  TYPE lvc_t_fcat,
     gs_fieldcat  TYPE lvc_s_fcat,
     gs_layout    TYPE lvc_s_layo.

TABLES:zil_listesi_t, zilce_listesi_t,zil_ilce_esi_t.

"dinamik tablo
FIELD-SYMBOLS: <dyn_table> TYPE STANDARD TABLE, "table
               <dyn_wa>,                         "structure
               <fs>.                             "field symbol






"!!!!!
*TYPES:BEGIN OF gty_dynamic,
*        il_kodu    TYPE zil_kodu,
*        il_tanım   TYPE zil_tanım,
*        ilce_tanım TYPE zilce_tanim,
*      END OF gty_dynamic.

*DATA:gt_dynamic TYPE STANDARD TABLE OF gty_dynamic.
*FIELD-SYMBOLS:<gfs_dynamic>  TYPE gty_dynamic.
