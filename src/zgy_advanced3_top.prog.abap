*&---------------------------------------------------------------------*
*& Include          ZGAMZEY_ADVANCED3_TOP
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
     gs_fcat_2      TYPE lvc_s_fcat,
     gs_layout_2    TYPE lvc_s_layo.

TABLES:zper_t, zdep_t, ztitle_t.

TYPES:BEGIN OF gty_edit,
        personel_id	          TYPE  zpers_id,
        personel_ad	          TYPE  zpers_ad,
        personel_soyad        TYPE  zpers_soyad,
        personel_departman_id	TYPE zpers_departman_id,
        personel_title_id     TYPE  zpers_title_id,
        toplam_tecrube        TYPE  zpers_tecrube,
        line_color            TYPE char4,
        celltab               TYPE lvc_t_styl, "field used for editing the particular cell
      END OF gty_edit.

TYPES:BEGIN OF gty_list,
        personel_id	          TYPE  zpers_id,
        personel_ad	          TYPE  zpers_ad,
        personel_soyad        TYPE  zpers_soyad,
        personel_departman_ad TYPE  zpers_departman_ad,
        personel_title_ad     TYPE  zpers_title_ad,
        toplam_tecrube        TYPE  zpers_tecrube,
        maas                  TYPE  int4,
        yillik_izin           TYPE  char15,
      END OF gty_list.

DATA:gt_alvedit TYPE TABLE OF gty_edit,
     gs_alvedit TYPE gty_edit,
     gt_alvlist TYPE TABLE OF gty_list,
     gs_alvlist TYPE gty_list.

DATA:gv_flag    TYPE xfeld,
     gv_found_t TYPE char1,
     gv_found_d TYPE char1.

DATA:gv_perad  TYPE zpers_id,
     gv_persoy TYPE zpers_soyad,
     gv_dep    TYPE  zpers_departman_ad,
     gv_title  TYPE zpers_title_ad.
SELECTION-SCREEN BEGIN OF BLOCK a WITH FRAME TITLE TEXT-000.
PARAMETERS:rb_yeni RADIOBUTTON GROUP a DEFAULT 'X' USER-COMMAND usr1,
           rb_list RADIOBUTTON GROUP a.
SELECTION-SCREEN END OF BLOCK a.
SELECTION-SCREEN BEGIN OF BLOCK b WITH FRAME TITLE TEXT-001 NO INTERVALS.
SELECT-OPTIONS:so_ad    FOR gv_perad  MODIF ID x,
               so_soyad FOR gv_persoy MODIF ID x,
               so_dep   FOR gv_dep    MODIF ID x,
               so_title FOR gv_title  MODIF ID x.
SELECTION-SCREEN END OF BLOCK b.

AT SELECTION-SCREEN OUTPUT.
  CASE abap_true.
    WHEN rb_yeni.
      LOOP AT SCREEN.
        IF screen-group1 EQ 'X'.
          screen-active = 0.
          MODIFY SCREEN.
        ENDIF.
      ENDLOOP.

    WHEN rb_list.
      LOOP AT SCREEN.
        IF screen-group1 EQ 'X'.
          screen-active = 1.
          MODIFY SCREEN.
        ENDIF.
        gv_flag = abap_true.
      ENDLOOP.
  ENDCASE.
