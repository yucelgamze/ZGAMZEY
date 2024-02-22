*&---------------------------------------------------------------------*
*& Include          ZGY_P_0009_TOP
*&---------------------------------------------------------------------*
TABLES:usr02,agr_users.

CLASS lcl_class DEFINITION DEFERRED.
DATA:go_local     TYPE REF TO lcl_class,
     go_alv_grid  TYPE REF TO cl_gui_alv_grid,
     go_container TYPE REF TO cl_gui_custom_container,
     gt_fcat      TYPE lvc_t_fcat,
     gs_fcat      TYPE lvc_s_fcat,
     gs_layout    TYPE lvc_s_layo.

TYPES:BEGIN OF gty_alv,
        bname    TYPE usr02-bname,
        agr_name TYPE agr_users-agr_name,
        from_dat TYPE datum,
        to_dat   TYPE datum,
      END OF gty_alv.
DATA: gt_alv TYPE TABLE OF gty_alv,
      gs_alv TYPE gty_alv.

SELECTION-SCREEN BEGIN OF BLOCK a WITH FRAME TITLE TEXT-000.
SELECT-OPTIONS:so_bname FOR usr02-bname NO INTERVALS.
PARAMETERS:p_start TYPE datum OBLIGATORY,
           p_fin   TYPE datum DEFAULT '99991231' OBLIGATORY.
SELECTION-SCREEN END OF BLOCK a.
