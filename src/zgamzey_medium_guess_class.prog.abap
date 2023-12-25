*&---------------------------------------------------------------------*
*& Include          ZGAMZEY_MEDIUM_GUESS_CLASS
*&---------------------------------------------------------------------*
CLASS local DEFINITION.
  PUBLIC SECTION.
    METHODS:
      get_data,
      call_screen,
      pbo_0100,
      pai_0100 IMPORTING iv_ucomm TYPE sy-ucomm,
      random_num,
      guess,
      add_guess,
      clear_guesses.
ENDCLASS.
CLASS local IMPLEMENTATION.
  METHOD get_data.
    go_local->random_num( ).
  ENDMETHOD.

  METHOD call_screen.
    CALL SCREEN 0100.
  ENDMETHOD.

  METHOD pbo_0100.
    SET PF-STATUS '0100'.
    SET TITLEBAR '0100'.
  ENDMETHOD.

  METHOD pai_0100.
    CASE iv_ucomm.
      WHEN '&BACK'.
        SET SCREEN 0.
      WHEN '&GUESS'.
        go_local->get_data( ).
        go_local->guess( ).
    ENDCASE.
  ENDMETHOD.

  METHOD random_num.
    CALL FUNCTION 'QF05_RANDOM_INTEGER'
      EXPORTING
        ran_int_max   = 100
        ran_int_min   = 0
      IMPORTING
        ran_int       = gv_random
      EXCEPTIONS
        invalid_input = 1
        OTHERS        = 2.
  ENDMETHOD.

  METHOD guess.
    IF gv_random EQ gv_num.
      MESSAGE 'Tebrikler doğru sayıyı buldunuz' TYPE 'I' DISPLAY LIKE 'S'.
      go_local->clear_guesses( ).
    ELSE.
      IF gv_random GE gv_num .
        MESSAGE 'Daha büyük sayı girin' TYPE 'I' DISPLAY LIKE 'W'.
        go_local->add_guess( ).
      ELSEIF gv_random LE gv_num.
        MESSAGE 'Daha küçük sayı girin' TYPE 'I' DISPLAY LIKE 'W'.
        go_local->add_guess( ).
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD add_guess.
    DATA:lv_numc TYPE char3,
         lv_nums TYPE string.
    lv_numc = gv_num.
    lv_nums = |{ lv_numc }| && |{ gv_numl }|.
    gv_numl = lv_nums.
  ENDMETHOD.

  METHOD clear_guesses.
    CLEAR:gv_numl.
  ENDMETHOD.
ENDCLASS.
