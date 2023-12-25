*&---------------------------------------------------------------------*
*& Report ZGY_CALCULATOR
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_calculator.

PARAMETERS:p_var1 TYPE int2,
           p_var2 TYPE int2.

DATA: lv_out  TYPE int2,
      lv_sign TYPE c,
      flag    TYPE int1 VALUE 0.

SELECTION-SCREEN : BEGIN OF SCREEN 100 TITLE TEXT-001,
  PUSHBUTTON 10(10) add  USER-COMMAND add,
  PUSHBUTTON 25(10)  sub USER-COMMAND sub,
  PUSHBUTTON 40(10)  mul USER-COMMAND multiply,
  PUSHBUTTON 55(10)  div USER-COMMAND divide,
  END OF SCREEN 100.

INITIALIZATION.
  add = 'Add'.
  sub = 'Subtract'.
  mul = 'Multiply'.
  div = 'Division'.


AT SELECTION-SCREEN.
  CASE sy-ucomm.
    WHEN 'ADD'.
      flag = 1.
      lv_out = p_var1 + p_var2.
    WHEN 'SUB'.
      flag = 1.
      lv_out = p_var1 - p_var2.
    WHEN 'DIVIDE'.
      IF ( p_var2 <> 0 ).
        flag = 1.
        lv_out = p_var1 / p_var2.
      ENDIF.
    WHEN 'MULTIPLY'.
      flag = 1.
      lv_out = p_var1 * p_var2.
  ENDCASE.

START-OF-SELECTION.

  IF p_var1 IS NOT INITIAL OR p_var2 IS NOT INITIAL .

    CALL SELECTION-SCREEN '100' STARTING AT 10 10 .

    IF flag = 1 .
      WRITE:lv_out.
    ELSEIF flag = 2.
      WRITE:'NUmber cannot be divided by 0'.
    ELSEIF flag = 0.
      MESSAGE 'Press any button to perform any operation!' TYPE 'I'.
    ENDIF.

  ELSE.
    MESSAGE 'Please give both input to proceed!' TYPE 'I'.

  ENDIF.
