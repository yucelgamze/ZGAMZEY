*&---------------------------------------------------------------------*
*& Include          ZGY_WORK3_TOP
*&---------------------------------------------------------------------*
CLASS lcl_class DEFINITION DEFERRED.
DATA:go_local TYPE REF TO lcl_class.
DATA:go_alv_grid  TYPE REF TO cl_gui_alv_grid,
     go_container TYPE REF TO cl_gui_custom_container,
     gt_fcat      TYPE lvc_t_fcat,
     gs_fcat      TYPE lvc_s_fcat,
     gs_layout    TYPE lvc_s_layo.

TABLES:zstok_t, zstok_s.

*DATA:gt_alv TYPE TABLE OF zstok_t. "dbt
*DATA:gt_alv TYPE TABLE OF zstok_s.  "structure dbt

"global type
TYPES:BEGIN OF gty_list,
        matnr       TYPE matnr,
        maktx       TYPE maktx,
        labst       TYPE labst,
        demirbas_mi TYPE zdemirbas_mi_de,
        maas        TYPE int4,
        line_color  TYPE char4,
        cell_color  TYPE lvc_t_scol,
      END OF gty_list.
DATA:gt_alv TYPE TABLE OF gty_list.

FIELD-SYMBOLS:<gfs_fcat> TYPE lvc_s_fcat. "fieldcatalog tipinde structure field symbol pointer
FIELD-SYMBOLS:<gfs_alv> TYPE gty_list.
DATA:gs_cell_color TYPE lvc_s_scol.

*"burada bir  headerline'lı itab gibi direkt  --> gt_alv[]
*DATA:BEGIN OF gt_alv OCCURS 0,
*       matnr       TYPE  zstok_t-matnr,
*       maktx       TYPE  zstok_t-maktx,
*       labst       TYPE  zstok_t-labst,
*       demirbas_mi TYPE  zstok_t-demirbas_mi,
*     END OF gt_alv.
