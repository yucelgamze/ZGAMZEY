*&---------------------------------------------------------------------*
*& Report ZGY_TEST_0001
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_test_0001.
*TABLES:t001w,mara.
*SELECTION-SCREEN BEGIN OF BLOCK a WITH FRAME TITLE TEXT-000.
*SELECT-OPTIONS:so_werks FOR t001w-werks  DEFAULT '1000' OBLIGATORY,
*               so_matnr FOR mara-matnr OBLIGATORY,
*               so_matkl FOR mara-matkl,
*               so_mtart FOR mara-mtart.
**NO INTERVALS.
*SELECTION-SCREEN END OF BLOCK a.
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

SELECT * FROM tspa INTO TABLE @DATA(lt_tspa).
BREAK-POINT.
