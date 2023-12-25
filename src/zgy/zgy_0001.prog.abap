*&---------------------------------------------------------------------*
*& Report ZGY_0001
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_0001.
DATA:gv_result TYPE i.

PARAMETERS: p_var1 TYPE i,
            p_var2 TYPE i.

IF p_var1 GE p_var2.
  gv_result = p_var1 / p_var2.
  WRITE:|Sonuç:|, gv_result.
ELSE.
  gv_result = p_var2 / p_var1.
  WRITE:|Sonuç:|, gv_result.
ENDIF.
