*&---------------------------------------------------------------------*
*& Include          ZGAMZEY_WORK1_TOP
*&---------------------------------------------------------------------*

CLASS local DEFINITION DEFERRED.
DATA:go_local TYPE REF TO local.

DATA:go_alv_grid  TYPE REF TO cl_gui_alv_grid,
     go_container TYPE REF TO cl_gui_custom_container,
     gt_fieldcat  TYPE lvc_t_fcat,
     gs_fieldcat  TYPE lvc_s_fcat,
     gs_layout    TYPE lvc_s_layo.

TABLES:zpersonal_t,zdepartman_t.

DATA:gv_personal_id    TYPE zpers_id_de,
     gv_personal_ad    TYPE zpers_ad_de,
     gv_personal_soyad TYPE zpers_soyad_de,
     gv_departman_id   TYPE zpers_departman_de,
     gv_maas           TYPE zpers_maas_de.

DATA:gt_pers TYPE TABLE OF zpersonal_departman_s,
     gs_pers TYPE zpersonal_departman_s.

DATA: gv_found      TYPE char1,
      gv_total_maas TYPE zpers_maas_de.

SELECTION-SCREEN BEGIN OF BLOCK a WITH FRAME TITLE TEXT-000.
PARAMETERS:pselect RADIOBUTTON GROUP a,
           pinsert RADIOBUTTON GROUP a,
           pupdate RADIOBUTTON GROUP a,
           pdelete RADIOBUTTON GROUP a.
SELECTION-SCREEN END OF BLOCK a.

CONTROLS tb_id TYPE TABSTRIP.
