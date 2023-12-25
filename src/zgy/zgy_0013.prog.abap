*&---------------------------------------------------------------------*
*& Report ZGY_0013
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_0013.

PARAMETERS:
  p_num1 TYPE i,
  p_num2 TYPE i,
  p_num3 TYPE i.

START-OF-SELECTION.
  IF p_num1 GE p_num2 AND p_num1 GE p_num3.
    IF p_num2 GE p_num3.
      WRITE:|İkinci sayı diğer iki sayının ortasındadır.|.
    ELSE.
      WRITE:|Üçüncü sayı diğer iki sayının ortasındadır.|.
    ENDIF.
  ELSEIF p_num2 GE p_num1 AND p_num2 GE p_num3.
    IF p_num1 GE p_num3.
      WRITE:|Birinci sayı diğer iki sayının ortasındadır.|.
    ELSE.
      WRITE:|Üçüncü sayı diğer iki sayının ortasındadır.|.
    ENDIF.
  ELSEIF p_num3 GE p_num1 AND p_num3 GE p_num2.
    IF p_num1 GE p_num2.
      WRITE:|Birinci sayı diğer iki sayının ortasındadır.|.
    ELSE.
      WRITE:|İkinci sayı diğer iki sayının ortasındadır.|.
    ENDIF.
  ENDIF.
