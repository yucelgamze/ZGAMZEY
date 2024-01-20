*&---------------------------------------------------------------------*
*& Report ZGAMZEY_EASY_CASE_WHEN
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_easy_case_when.

SELECTION-SCREEN BEGIN OF BLOCK a WITH FRAME TITLE TEXT-000.
PARAMETERS:
  p_num1 TYPE i,
  p_num2 TYPE i,
  p_op   TYPE char1.
SELECTION-SCREEN END OF BLOCK a.

DATA:gv_result TYPE i.

CASE p_op.
  WHEN '+'.
    gv_result = p_num1 + p_num2.
    WRITE:'Toplama İşlemi Sonuç:',gv_result.
  WHEN '*'.
    gv_result = p_num1 * p_num2.
    WRITE:'Çarpma İşlemi Sonuç:',gv_result.
  WHEN '-'.
    gv_result = p_num1 - p_num2.
    WRITE:'Çıkarma İşlemi Sonuç:',gv_result.
  WHEN '/'.
    gv_result = p_num1 / p_num2.
    WRITE:'Bölme İşlemi Sonuç:',gv_result.
ENDCASE.
