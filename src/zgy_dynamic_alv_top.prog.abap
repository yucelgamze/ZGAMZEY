*&---------------------------------------------------------------------*
*& Include          ZGY_WORK10_TOP
*&---------------------------------------------------------------------*
TABLES:zgy_dbt_dynamic.

CLASS lcl_class DEFINITION DEFERRED.
DATA:go_local TYPE REF TO lcl_class.
DATA:go_alv_grid  TYPE REF TO cl_gui_alv_grid,
     go_container TYPE REF TO cl_gui_custom_container,
     gt_fcat      TYPE lvc_t_fcat,
     gs_fcat      TYPE lvc_s_fcat,
     gs_layout    TYPE lvc_s_layo.



DATA:gt_alv     TYPE TABLE OF zgy_dbt_dynamic,
     gs_alv     TYPE zgy_dbt_dynamic,
     gt_ilkodu  TYPE TABLE OF zgy_dbt_dynamic,
     gt_malzeme TYPE TABLE OF zgy_dbt_dynamic.

"dynamic table

DATA:go_dynamic TYPE REF TO data,
     gs_dynamic TYPE REF TO data.

FIELD-SYMBOLS:<dyn_table>   TYPE STANDARD TABLE,
              <gfs_s_table> ,
              <gfs>.
