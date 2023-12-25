*&---------------------------------------------------------------------*
*& Include          ZGY_EKKO_TOP
*&---------------------------------------------------------------------*
CLASS lcl_class DEFINITION DEFERRED.
DATA:go_local TYPE REF TO lcl_class.
DATA:go_alv_grid  TYPE REF TO cl_gui_alv_grid,
     go_container TYPE REF TO cl_gui_custom_container,
     gt_fcat      TYPE lvc_t_fcat,
     gs_fcat      TYPE lvc_s_fcat,
     gs_layout    TYPE lvc_s_layo.

TABLES:zgy_t_ekko,ekko.

TYPES:BEGIN OF gty_alv,
        ebeln      TYPE ebeln,
        bukrs      TYPE bukrs,
        bstyp      TYPE ebstyp,
        bsart      TYPE esart,
        loekz      TYPE eloek,
        statu      TYPE estak,
        aedat      TYPE erdat,
        ernam      TYPE ernam,
        lifnr      TYPE elifn,
        spras      TYPE spras,
        zterm      TYPE dzterm,
        ekorg      TYPE ekorg,
        ekgrp      TYPE bkgrp,
        waers      TYPE waers,
        line_color TYPE char4,
      END OF gty_alv.

DATA:gt_alv TYPE TABLE OF gty_alv,
     gs_alv TYPE gty_alv.

SELECTION-SCREEN BEGIN OF BLOCK a WITH FRAME TITLE TEXT-000.
SELECT-OPTIONS:so_bukrs FOR ekko-bukrs NO INTERVALS,
               so_bstyp FOR ekko-bstyp NO INTERVALS,
               so_bsart FOR ekko-bsart NO INTERVALS.
SELECTION-SCREEN END OF BLOCK a.
