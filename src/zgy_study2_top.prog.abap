*&---------------------------------------------------------------------*
*& Include          ZGAMZEY_STUDY2_TOP
*&---------------------------------------------------------------------*
CLASS lcl_class DEFINITION DEFERRED.
DATA:go_local TYPE REF TO lcl_class.
DATA:go_alv_grid  TYPE REF TO cl_gui_alv_grid,
     go_container TYPE REF TO cl_gui_custom_container,
     gt_fcat      TYPE lvc_t_fcat,
     gs_fcat      TYPE lvc_s_fcat,
     gs_layout    TYPE lvc_s_layo.

TABLES:bkpf, bseg, kna1, lfa1.

SELECTION-SCREEN BEGIN OF BLOCK a WITH FRAME TITLE TEXT-000.

PARAMETERS:p_burks TYPE bkpf-bukrs OBLIGATORY. "şirket kodu

SELECT-OPTIONS:so_belnr FOR bkpf-belnr , "belge no
               so_pswsl FOR bseg-pswsl . "para birimi

SELECTION-SCREEN END OF BLOCK a.

TYPES:BEGIN OF gty_alv,
        bukrs TYPE bukrs,
        belnr TYPE belnr_d,
        gjahr TYPE gjahr,
        kunnr TYPE char10,
*        lifnr   TYPE lifnr,
        name1 TYPE char70,
*        name2   TYPE name1_gp,
        pswsl TYPE pswsl,
        wrbtr TYPE wrbtr,
        h_bldat TYPE bldat,
*        koart   TYPE koart,
      END OF gty_alv.

DATA:gt_alv TYPE TABLE OF gty_alv,
     gs_alv TYPE gty_alv.
