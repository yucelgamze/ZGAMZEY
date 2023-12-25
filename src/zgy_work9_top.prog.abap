*&---------------------------------------------------------------------*
*& Include          ZGY_WORK5_TOP
*&---------------------------------------------------------------------*
TYPE-POOLS:icon.
TABLES:scarr.

CLASS lcl_class DEFINITION DEFERRED.
DATA:go_local TYPE REF TO lcl_class.
DATA:go_alv_grid  TYPE REF TO cl_gui_alv_grid,
     go_container TYPE REF TO cl_gui_custom_container,
     gt_fcat      TYPE lvc_t_fcat,
     gs_fcat      TYPE lvc_s_fcat,
     gs_layout    TYPE lvc_s_layo.

TYPES:BEGIN OF gty_scarr,
        delete     TYPE  char10,
        durum      TYPE icon_d,
        carrid     TYPE s_carr_id,
        carrname   TYPE s_carrname,
        currcode   TYPE s_currcode,
        url        TYPE s_carrurl,
        cost       TYPE int4,
        location   TYPE char20,
        seatl      TYPE char1,
        seatp      TYPE char10,
        dd_handle  TYPE int4,
        line_color TYPE char4,
        cell_color TYPE lvc_t_scol,
        cellstyle  TYPE lvc_t_styl, "field used for editing the particular cell
        styleval   TYPE char8,
      END OF gty_scarr.
DATA:gt_alv TYPE TABLE OF gty_scarr,
     gs_alv TYPE gty_scarr.

FIELD-SYMBOLS:<gfs_fcat> TYPE lvc_s_fcat. "fieldcatalog tipinde structure field symbol pointer
FIELD-SYMBOLS:<gfs_alv> TYPE gty_scarr. "global type tipinde internal structure alv
DATA:gs_cell_color TYPE lvc_s_scol.


"events

DATA:go_splitter TYPE REF TO cl_gui_splitter_container,
     go_sub1     TYPE REF TO cl_gui_container,
     go_sub2     TYPE REF TO cl_gui_container,

     go_docu     TYPE REF TO cl_dd_document.

"EXCLUDING SORT FILTER
DATA:gt_excluding TYPE ui_functions,
     gv_excluding TYPE ui_func,
     gt_sort      TYPE lvc_t_sort,
     gs_sort      TYPE lvc_s_sort,
     gt_filter    TYPE lvc_t_filt,
     gs_filter    TYPE lvc_s_filt.

"SAVE,VARIANT & DEFAULT
DATA:gs_variant     TYPE disvariant,
     gs_variant_tmp TYPE disvariant.
PARAMETERS:p_vari TYPE disvariant-variant.
