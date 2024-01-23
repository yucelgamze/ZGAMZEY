*&---------------------------------------------------------------------*
*& Include          ZGY_P_TOP
*&---------------------------------------------------------------------*
TYPE-POOLS:icon.
TABLES:t001w,mara,marc,t023,t023t.

CLASS lcl_class DEFINITION DEFERRED.
DATA: go_local TYPE REF TO lcl_class.
DATA: go_alv_grid  TYPE REF TO cl_gui_alv_grid,
      go_container TYPE REF TO cl_gui_custom_container,
      gt_fcat      TYPE lvc_t_fcat,
      gs_fcat      TYPE lvc_s_fcat,
      gs_layout    TYPE lvc_s_layo.

DATA:flag TYPE abap_bool.

TYPES:BEGIN OF gty_alv,
        matnr    TYPE mara-matnr,
        maktx    TYPE makt-maktx,
        matkl    TYPE mara-matkl,
        wgbez60  TYPE t023t-wgbez60,
        mtart    TYPE mara-mtart,
        stok     TYPE marc-mabst,
        meins    TYPE mara-meins,
        minstok  TYPE marc-mabst,
        meins2   TYPE mara-meins,
        azstok   TYPE marc-mabst,
        meins3   TYPE mara-meins,
        asat     TYPE marc-mabst,
        meins4   TYPE mara-meins,
        asas     TYPE marc-mabst,
        meins5   TYPE mara-meins,
        talep    TYPE marc-mabst,
        meins6   TYPE mara-meins,
        satol    TYPE xfeld,      "checkbox = abap_true
        satno    TYPE eban-banfn,
        satkalem TYPE eban-bnfpo,
        durum    TYPE icon_d,     " traffic light
      END OF gty_alv.

DATA:gt_alv TYPE TABLE OF gty_alv,
     gs_alv TYPE gty_alv.

SELECTION-SCREEN BEGIN OF BLOCK a WITH FRAME TITLE TEXT-000.
SELECT-OPTIONS:so_werks FOR t001w-werks  DEFAULT '1000' OBLIGATORY,
               so_matnr FOR mara-matnr,
               so_matkl FOR mara-matkl,
               so_mtart FOR mara-mtart.
*NO INTERVALS.
SELECTION-SCREEN END OF BLOCK a.

AT SELECTION-SCREEN.
  IF so_matnr IS INITIAL AND so_matkl IS INITIAL AND so_mtart IS INITIAL.
    flag = abap_false.
    ROLLBACK WORK.
    MESSAGE |Malzeme, Mal Grubu ya da Malzeme Türü alanlarından en az biri zorunludur!| TYPE 'I' DISPLAY LIKE 'E'.
  ELSE.
    flag = abap_true.
  ENDIF.




















*PARAMETERS: p_quart  RADIOBUTTON GROUP g1
*                    DEFAULT 'X' USER-COMMAND fil,
*            p_annual RADIOBUTTON GROUP g1.
*
*PARAMETERS: p_ch1 AS CHECKBOX  MODIF ID ses,
*            p_ch2 AS CHECKBOX  MODIF ID ses,
*            p_ch3 AS CHECKBOX  MODIF ID ses,
*            p_ch4 AS CHECKBOX  MODIF ID ses.
*
*AT SELECTION-SCREEN OUTPUT.
*
*  LOOP AT SCREEN.
*    IF screen-group1 = 'SES'.
*      IF p_annual EQ 'X'.
*        screen-input = 1.
*      ELSE.
*        screen-input = 0.
*      ENDIF.
*    ENDIF.
*    MODIFY SCREEN.
*  ENDLOOP.
