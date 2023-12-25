*&---------------------------------------------------------------------*
*& Include          ZGAMZEY_STUDY1_TOP
*&---------------------------------------------------------------------*
TABLES:zgy_per_t.

CLASS lcl_class DEFINITION DEFERRED.
DATA:go_local TYPE REF TO lcl_class.
DATA:go_alv_grid  TYPE REF TO cl_gui_alv_grid,
     go_container TYPE REF TO cl_gui_custom_container,
     gt_fcat      TYPE lvc_t_fcat,
     gs_fcat      TYPE lvc_s_fcat,
     gs_layout    TYPE lvc_s_layo.

DATA:gt_alv TYPE TABLE OF zgy_per_t.

DATA:gv_found  TYPE xfeld,
     gv_found2 TYPE xfeld,
     gv_flag   TYPE xfeld,
     gv_flag2  TYPE xfeld.

DATA:gv_tc     TYPE zgy_tc_de,
     gv_ad     TYPE zgy_ad_de,
     gv_soyad  TYPE zgy_soyad_de,
     gv_acıkla TYPE char200.

SELECTION-SCREEN BEGIN OF BLOCK a WITH FRAME TITLE TEXT-000.
PARAMETERS:rb_kayit RADIOBUTTON GROUP a DEFAULT 'X' USER-COMMAND user,
           rb_rand  RADIOBUTTON GROUP a.
SELECTION-SCREEN END OF BLOCK a.

SELECTION-SCREEN BEGIN OF BLOCK b WITH FRAME TITLE TEXT-001.
PARAMETERS:p_tc     TYPE zgy_tc_de    MODIF ID x,
           p_ad     TYPE zgy_ad_de    MODIF ID x,
           p_soyad  TYPE zgy_soyad_de MODIF ID x,
           p_acıkla TYPE char200      MODIF ID x.
SELECTION-SCREEN END OF BLOCK b.

SELECTION-SCREEN BEGIN OF BLOCK c WITH FRAME TITLE TEXT-002.
PARAMETERS:p_winner TYPE int4 MODIF ID y.
SELECTION-SCREEN END OF BLOCK c.

AT SELECTION-SCREEN OUTPUT.
  CASE abap_true.
    WHEN rb_kayit.
      LOOP AT SCREEN.
        IF screen-group1 EQ 'X'.
          screen-active = 1.
          MODIFY SCREEN.
        ELSEIF screen-group1 EQ 'Y'.
          screen-active = 0.
          MODIFY SCREEN.
        ENDIF.
        gv_flag2 = abap_true.
      ENDLOOP.

    WHEN rb_rand.
      LOOP AT SCREEN.
        IF screen-group1 EQ 'Y'.
          screen-active = 1.
          MODIFY SCREEN.
        ELSEIF screen-group1 EQ 'X'.
          screen-active = 0.
          MODIFY SCREEN.
        ENDIF.
      ENDLOOP.
  ENDCASE.
