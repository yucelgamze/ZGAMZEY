*&---------------------------------------------------------------------*
*& Include          ZGAMZEY_HARD_1_TOP
*&---------------------------------------------------------------------*
CLASS local DEFINITION DEFERRED.
DATA:go_local TYPE REF TO local.

DATA:go_alv_grid  TYPE REF TO cl_gui_alv_grid,
     go_container TYPE REF TO cl_gui_custom_container,
     gt_fieldcat  TYPE lvc_t_fcat,
     gs_fieldcat  TYPE lvc_s_fcat,
     gs_layout    TYPE lvc_s_layo.

TABLES:zgamzey_student, zders_detay.

DATA:gv_ogrenci_id    TYPE zogr_id_de,
     gv_ogrenci_ad    TYPE zogr_ad_de,
     gv_ogrenci_soyad TYPE zogr_soyad_de,
     gv_ders_id       TYPE zders_id_de,
     gv_puan          TYPE zpuan_de.

DATA:gt_ogr TYPE TABLE OF zogr_alv_s,
     gs_ogr TYPE zogr_alv_s.

SELECTION-SCREEN BEGIN OF BLOCK a WITH FRAME TITLE TEXT-000.
PARAMETERS: p_rad1 RADIOBUTTON GROUP gr1,
            p_rad2 RADIOBUTTON GROUP gr1,
            p_rad3 RADIOBUTTON GROUP gr1,
            p_rad4 RADIOBUTTON GROUP gr1.
SELECTION-SCREEN END OF BLOCK a.
