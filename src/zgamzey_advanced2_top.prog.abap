*&---------------------------------------------------------------------*
*& Include          ZGAMZEY_ADVANCED2_TOP
*&---------------------------------------------------------------------*
CLASS lcl_class DEFINITION DEFERRED.
DATA:go_local TYPE REF TO lcl_class.

DATA:go_alv_grid  TYPE REF TO cl_gui_alv_grid,
     go_container TYPE REF TO cl_gui_custom_container,
     gt_fcat      TYPE lvc_t_fcat,
     gs_fcat      TYPE lvc_s_fcat,
     gs_layout    TYPE lvc_s_layo.

DATA:go_alv_grid_2  TYPE REF TO cl_gui_alv_grid,
     go_container_2 TYPE REF TO cl_gui_custom_container,
     gt_fcat_2      TYPE lvc_t_fcat,
     gs_fcat_2      TYPE lvc_s_fcat.

TABLES: zstok_t.
"zstok_t tablosunun structure db_t'ı gibi types ile oluşturuldu.
TYPES:BEGIN OF gty_list,
        matnr       TYPE matnr,
        maktx       TYPE maktx,
        labst       TYPE labst,
        demirbas_mi TYPE zdemirbas_mi_de,
      END OF gty_list.

"oluşturulan bu types structure'ından alv ye basılacak olan internal table oluşturulur.
DATA:gt_alv   TYPE TABLE OF gty_list,
     gt_alv_2 TYPE TABLE OF gty_list.

*FIELD-SYMBOLS:<gfs_fcat> TYPE lvc_s_fcat.
*FIELD-SYMBOLS:<gfs_fcat2> TYPE lvc_s_fcat.
