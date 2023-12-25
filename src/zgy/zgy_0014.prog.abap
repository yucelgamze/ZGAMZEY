*&---------------------------------------------------------------------*
*& Report ZGY_0014
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_0014.

PARAMETERS:p_num1 TYPE i,
           p_num2 TYPE i,
           p_op   TYPE c.

DATA:gv_result TYPE i.

START-OF-SELECTION.

  CASE p_op.
    WHEN '+'.
      gv_result = p_num1 + p_num2.
      WRITE:|Sonuç:|,gv_result.
    WHEN '-'.
      gv_result = p_num1 - p_num2.
      WRITE:|Sonuç:|,gv_result.
    WHEN '*'.
      gv_result = p_num1 * p_num2.
      WRITE:|Sonuç:|,gv_result.
    WHEN '/'.
      gv_result = p_num1 / p_num2.
      WRITE:|Sonuç:|,gv_result.
  ENDCASE.
