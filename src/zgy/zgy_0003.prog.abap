*&---------------------------------------------------------------------*
*& Report ZGY_0003
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_0003.

PARAMETERS:p_num1 TYPE i,
           p_num2 TYPE i,
           p_num3 TYPE i.

IF p_num1 GE p_num2 AND p_num1 GE p_num3.
  IF p_num2 GE p_num3.
    WRITE: p_num1, p_num2, p_num3.
  ELSE.
    WRITE:p_num1, p_num3, p_num2.
  ENDIF.
ELSEIF p_num2 GE p_num1 AND p_num2 GE p_num3.
  IF p_num1 GE p_num3.
    WRITE: p_num2, p_num1, p_num3.
  ELSE.
    WRITE: p_num2, p_num3, p_num1.
  ENDIF.
ELSE.
  IF p_num1 GE p_num2.
    WRITE: p_num3, p_num1, p_num3.
  ELSE.
    WRITE: p_num3, p_num2, p_num1.
  ENDIF.
ENDIF.
