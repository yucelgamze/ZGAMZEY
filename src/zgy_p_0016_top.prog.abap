*&---------------------------------------------------------------------*
*& Include          ZGY_P_0016_TOP
*&---------------------------------------------------------------------*
TABLES:vbak,vbap,kna1,vbpa,makt,t001w,t001l.
CLASS lcl_class DEFINITION DEFERRED.
DATA:go_local     TYPE REF TO lcl_class,
     go_alv_grid  TYPE REF TO cl_gui_alv_grid,            "Başlık
     go_alv_grid2 TYPE REF TO cl_gui_alv_grid,            "Kalem
     go_container TYPE REF TO cl_gui_custom_container,
     gt_fcat      TYPE lvc_t_fcat,
     gt_fcat2     TYPE lvc_t_fcat,
     gs_fcat      TYPE lvc_s_fcat,
     gs_layout    TYPE lvc_s_layo.

DATA:go_splitter TYPE REF TO cl_gui_splitter_container,
     go_split1   TYPE REF TO cl_gui_container,
     go_split2   TYPE REF TO cl_gui_container.

TYPES:BEGIN OF gty_baslik,
        vbeln      TYPE vbak-vbeln,
        ernam      TYPE vbak-ernam,
        erdat      TYPE vbak-erdat,
        auart      TYPE vbak-auart,
        vkorg      TYPE vbak-vkorg,
        kunnr      TYPE vbak-kunnr,
        kunnr_name TYPE kna1-name1,
        kunwe      TYPE vbpa-kunnr,
        kunwe_name TYPE kna1-kunnr,
        netwr      TYPE vbak-netwr,
        waerk      TYPE vbak-waerk,
      END OF gty_baslik.

DATA:gt_baslik TYPE TABLE OF gty_baslik,
     gs_baslik TYPE gty_baslik.

TYPES:BEGIN OF gty_kalem,
        vbeln      TYPE vbap-vbeln,
        posnr      TYPE vbap-posnr,
        matnr      TYPE vbap-matnr,
        maktx      TYPE makt-maktx,
        werks      TYPE vbap-werks,
        werks_name TYPE t001w-name1,
        lgort      TYPE vbap-lgort,
        lgobe      TYPE t001l-lgobe,
        ntgew      TYPE vbap-ntgew,
        brgew      TYPE vbap-brgew,
        fark       TYPE zgy_de_0045,
        gewei      TYPE vbap-gewei,
        netwr      TYPE vbap-netwr,
        waerk      TYPE vbap-waerk,
      END OF gty_kalem.

DATA:gt_kalem TYPE TABLE OF gty_kalem,
     gs_kalem TYPE gty_kalem.


"ADOBE IMPORT PARAMETRELERİ / SMARTFORMS IMPORT PARAMETRELERİ
DATA:gs_header TYPE zgy_s_0032,
     gt_items  TYPE zgy_tt_0033,
     gs_items  TYPE zgy_s_0033.

"Adobe Tanımlamaları
DATA: fm_name         TYPE rs38l_fnam,
      fp_docparams    TYPE sfpdocparams,
      fp_outputparams TYPE sfpoutputparams.

"smartform verileri
DATA:gv_fm_name   TYPE rs38l_fnam,
     gs_controls  TYPE ssfctrlop,
     gs_output_op TYPE ssfcompop.

SELECTION-SCREEN BEGIN OF BLOCK a WITH FRAME TITLE TEXT-000.
SELECT-OPTIONS:so_vbeln FOR vbak-vbeln,
               so_ernam FOR vbak-ernam,
               so_auart FOR vbak-auart,
               so_kunnr FOR vbak-kunnr,
               so_werks FOR vbap-werks,
               so_lgort FOR vbap-lgort.
SELECTION-SCREEN END OF BLOCK a.
