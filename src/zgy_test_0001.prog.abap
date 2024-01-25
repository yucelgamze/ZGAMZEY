*&---------------------------------------------------------------------*
*& Report ZGY_TEST_0001
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_test_0001.
TABLES:t001w,mara.

DATA:flag TYPE abap_bool.

*SELECTION-SCREEN BEGIN OF BLOCK a WITH FRAME TITLE TEXT-000.
*SELECT-OPTIONS:so_werks FOR t001w-werks  DEFAULT '1000' OBLIGATORY,
*               so_matnr FOR mara-matnr,
*               so_matkl FOR mara-matkl,
*               so_mtart FOR mara-mtart.
**NO INTERVALS.
*SELECTION-SCREEN END OF BLOCK a.
*
*
*PARAMETERS: p_quart  RADIOBUTTON GROUP g1
*                    DEFAULT 'X' USER-COMMAND fil,
*            p_annual RADIOBUTTON GROUP g1.
*
*PARAMETERS: p_ch1 AS CHECKBOX  MODIF ID ses,
*            p_ch2 AS CHECKBOX  MODIF ID ses,
*            p_ch3 AS CHECKBOX  MODIF ID ses,
*            p_ch4 AS CHECKBOX  MODIF ID ses.
*
*AT SELECTION-SCREEN.
*  IF so_matnr IS INITIAL AND so_matkl IS INITIAL AND so_mtart IS INITIAL.
*    flag = abap_false.
*    ROLLBACK WORK.
*    MESSAGE |Malzeme, Mal Grubu ya da Malzeme Türü alanlarından en az biri zorunludur!| TYPE 'I' DISPLAY LIKE 'E'.
*  ELSE.
*    flag = abap_true.
*  ENDIF.
*
*AT SELECTION-SCREEN OUTPUT.
*
*  LOOP AT SCREEN.
*    IF screen-group1 = 'SES'.
*      IF p_annual EQ 'X' AND flag = abap_true.
*        screen-input = 1.
*      ELSE.
*        screen-input = 0.
*      ENDIF.
*    ENDIF.
*    MODIFY SCREEN.
*  ENDLOOP.

*--------------------------------------------------------------------*

DATA lv_integer TYPE i VALUE 123.
DATA lv_string TYPE string.

" Convert integer to string
lv_string = CONV #( lv_integer ).
WRITE: / 'Integer:', lv_integer, / 'String:', lv_string.
