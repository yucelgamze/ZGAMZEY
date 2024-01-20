*&---------------------------------------------------------------------*
*& Report ZGAMZEY_EASY_RANDOM
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_easy_random.

DATA:
  gv_result TYPE i.

CALL FUNCTION 'QF05_RANDOM_INTEGER'
  EXPORTING
    ran_int_max   = 150
    ran_int_min   = 0
  IMPORTING
    ran_int       = gv_result
  EXCEPTIONS
    invalid_input = 1
    OTHERS        = 2.

IF sy-subrc EQ 0.
  IF gv_result BETWEEN 0 AND 25.
    WRITE: gv_result.
    WRITE: /,'Üretilen sayı 0-25 arasındadır.'.
  ELSEIF gv_result BETWEEN 25 AND 50.
    WRITE: gv_result.
    WRITE: /,'Üretilen sayı 25-50 arasındadır.'.
  ELSEIF gv_result BETWEEN 50 AND 75.
    WRITE:gv_result.
    WRITE: /,'Üretilen sayı 50-75 arasındadır.'.
  ELSEIF gv_result BETWEEN 75 AND 100.
    WRITE:gv_result.
    WRITE: /,'Üretilen sayı 75-100 arasındadır.'.
  ELSEIF gv_result GE 100.
    WRITE:gv_result.
    WRITE: /,'Üretilen sayı 100''den büyüktür'.
  ENDIF.
ENDIF.
