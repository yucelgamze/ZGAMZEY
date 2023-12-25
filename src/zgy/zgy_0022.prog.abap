*&---------------------------------------------------------------------*
*& Report ZGY_0022
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_0022.

*DATA:gv_random TYPE i.

START-OF-SELECTION.

*  CALL FUNCTION 'QF05_RANDOM_INTEGER'
*    EXPORTING
*      ran_int_max   = 150
*      ran_int_min   = 0
*    IMPORTING
*      ran_int       = gv_random
*    EXCEPTIONS
*      invalid_input = 1
*      OTHERS        = 2.

  DATA(lv_random) = cl_abap_random_int=>create(
                        seed           = cl_abap_random=>seed( )
                        min            = 0
                        max            = 150
                    )->get_next( ).
  IF sy-subrc EQ 0.
    IF lv_random BETWEEN 0 AND 25.
      WRITE:|0 ile 25 arasındadır!|.
    ELSEIF lv_random BETWEEN 25 AND 50.
      WRITE:|25 ile 50 arasındadır!|.
    ELSEIF lv_random BETWEEN 50 AND 75.
      WRITE:|50 ile 75 arasındadır!|.
    ELSEIF lv_random BETWEEN 75 AND 100.
      WRITE:|75 ile 100 arasındadır!|.
    ELSEIF lv_random GE 100.
      WRITE:|100 den büyüktür! |.
    ENDIF.
  ENDIF.
