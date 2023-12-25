*&---------------------------------------------------------------------*
*& Report ZGY_0015
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_0015.

PARAMETERS:p_num1 TYPE i,
           p_num2 TYPE i.

DATA:gv_result TYPE p DECIMALS 2.

START-OF-SELECTION.
  gv_result = p_num1 / p_num2.
  WRITE:p_num1,|/|,p_num2,|=|,gv_result.
