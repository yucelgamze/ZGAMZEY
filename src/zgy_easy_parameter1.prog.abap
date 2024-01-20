*&---------------------------------------------------------------------*
*& Report ZGAMZEY_EASY_PARAMETER1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_easy_parameter1.

SELECTION-SCREEN BEGIN OF BLOCK a WITH FRAME TITLE TEXT-000.
PARAMETERS: p_num TYPE i.
SELECTION-SCREEN END OF BLOCK a.

START-OF-SELECTION.
  IF p_num BETWEEN 0 AND 25.
    WRITE:'Girilen sayı:', p_num.
    WRITE:/,'Sayı 0 ile 25 arasındadır.'.
  ELSEIF p_num BETWEEN 25 AND 50.
    WRITE:'Girilen sayı:', p_num.
    WRITE:/,'Sayı 25 ile 50 arasındadır.'.
  ELSEIF  p_num BETWEEN 50 AND 75.
    WRITE:'Girilen sayı:', p_num.
    WRITE:/,'Sayı 50 ile 75 arasındadır.'.
  ELSEIF  p_num BETWEEN 75 AND 100.
    WRITE:'Girilen sayı:', p_num.
    WRITE:/,'Sayı 75 ile 100 arasındadır.'.
  ENDIF.
