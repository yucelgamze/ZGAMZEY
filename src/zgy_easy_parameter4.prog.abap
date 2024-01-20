*&---------------------------------------------------------------------*
*& Report ZGAMZEY_EASY_PARAMETER4
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_easy_parameter4.

SELECTION-SCREEN BEGIN OF BLOCK a WITH FRAME TITLE TEXT-000.
PARAMETERS:
  p_num1 TYPE i,
  p_num2 TYPE i,
  p_num3 TYPE i.
SELECTION-SCREEN END OF BLOCK a.

DATA: gv_highest TYPE  i,
      gv_middle  TYPE  i,
      gv_lowest  TYPE  i.

START-OF-SELECTION.
  IF p_num1 LE p_num2 AND p_num1 LE p_num3.
    gv_lowest = p_num1.
    IF p_num2 LE p_num3.
      gv_middle = p_num2.
      gv_highest = p_num3.
      WRITE:'İkinci sayı diğer iki sayının ortasındadır.'.
    ELSE.
      gv_middle = p_num3.
      gv_highest = p_num2.
      WRITE:'Üçüncü sayı diğer iki sayının ortasındadır.'.
    endif.

    ELSEIF p_num2 LE p_num1 AND p_num2 LE p_num3.
      gv_lowest = p_num2.
      IF p_num1 LE p_num3.
        gv_middle = p_num1.
        gv_highest = p_num3.
        WRITE:'Birinci sayı diğer iki sayının ortasındadır.'.
      ELSE.
        gv_middle = p_num3.
        gv_highest = p_num1.
        WRITE:'Üçüncü sayı diğer iki sayının ortasındadır.'.
      ENDIF.

    ELSE.
      gv_lowest = p_num3.
      IF p_num1 LE p_num2.
        gv_middle = p_num1.
        gv_highest = p_num2.
        WRITE:'Birinci sayı diğer iki sayının ortasındadır.'.
      ELSE.
        gv_middle = p_num2.
        gv_highest = p_num1.
        WRITE:'İkinci sayı diğer iki sayının ortasındadır.'.
      ENDIF.

    ENDIF.
