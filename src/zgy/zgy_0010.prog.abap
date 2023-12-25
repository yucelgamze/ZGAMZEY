*&---------------------------------------------------------------------*
*& Report ZGY_0010
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_0010.

PARAMETERS:p_num TYPE i.

START-OF-SELECTION.

  IF p_num BETWEEN 0 AND 25.
    WRITE:|Girilen sayı 0 ile 25 arasındadır!|.
  ELSEIF p_num BETWEEN 25 AND 50.
    WRITE:|Girilen sayı 25 ile 50 arasındadır!|.
  ELSEIF p_num BETWEEN 50 AND 75.
    WRITE:|Girilen sayı 50 ile 75 arasındadır!|.
  ELSEIF p_num BETWEEN 75 AND 100.
    WRITE:|Girilen sayı 75 ile 100 arasındadır!|.
  ELSE.
    WRITE:|Girilen sayı 100'den büyüktür!|.
  ENDIF.
