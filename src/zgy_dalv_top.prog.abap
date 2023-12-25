*&---------------------------------------------------------------------*
*& Include          ZGY_DALV_TOP
*&---------------------------------------------------------------------*
TABLES: zgy_t_0001.

CLASS lcl_class DEFINITION DEFERRED.
DATA: go_local     TYPE REF TO lcl_class,
      go_alv_grid  TYPE REF TO cl_gui_alv_grid,
      go_container TYPE REF TO cl_gui_custom_container,
      gt_fcat      TYPE lvc_t_fcat,
      gs_fcat      TYPE lvc_s_fcat,
      gs_layout    TYPE lvc_s_layo.

DATA: gt_alv TYPE TABLE OF zgy_t_0001,
      gs_alv TYPE zgy_t_0001.

DATA: go_t_dynamic TYPE REF TO data,
      go_s_dynamic TYPE REF TO data.

FIELD-SYMBOLS: <dyn_table>   TYPE STANDARD TABLE,
               <gfs_s_table>,
               <gfs>.
