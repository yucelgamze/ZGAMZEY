*&---------------------------------------------------------------------*
*& Report ZGAMZEY_EASY_FORM1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_easy_form1.

SELECTION-SCREEN BEGIN OF BLOCK a WITH FRAME TITLE TEXT-000.
PARAMETERS:
  p_num1 TYPE i,
  p_num2 TYPE i.
SELECTION-SCREEN END OF BLOCK a.
DATA: gv_result TYPE p DECIMALS 2.

INCLUDE ZGY_EASY_FORM1_IKI_SAYIF01.
*INCLUDE zgamzey_easy_form1_iki_sayif01.
