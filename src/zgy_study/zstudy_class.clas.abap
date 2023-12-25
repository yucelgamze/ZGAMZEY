class ZSTUDY_CLASS definition
  public
  final
  create public .

public section.

  interfaces ZSTUDY_INTERFACE .

  aliases MULT_NUMS
    for ZSTUDY_INTERFACE~MULT_NUMBERS .

  types NUMBER_TYPE type INT4 .

  constants CV_NUM type NUMBER_TYPE value 100 ##NO_TEXT.

  class-events DIV_NUMBERS
    exporting
      value(IV_N1) type INT4 optional
      value(IV_N2) type INT4 optional
      value(EV_RESULT) type INT4 optional .

  methods ADD_NUMBERS
    importing
      value(IV_N1) type INT4 optional
      value(IV_N2) type INT4 optional
    exporting
      value(EV_RESULT) type NUMBER_TYPE .
  class-methods MUL_NUMBERS
    importing
      value(IV_N1) type INT4 optional
      value(IV_N2) type INT4 optional
    exporting
      value(EV_RESULT) type INT4 .
  class-methods SUB_NUMBERS
    importing
      value(IV_N1) type NUMBER_TYPE optional
      value(IV_N2) type NUMBER_TYPE optional
    exporting
      !EV_RESULT type NUMBER_TYPE .
  class-methods DIV_NUMBERS2
    for event DIV_NUMBERS of ZSTUDY_CLASS
    importing
      !IV_N1
      !IV_N2
      !EV_RESULT .
protected section.
private section.
ENDCLASS.



CLASS ZSTUDY_CLASS IMPLEMENTATION.


  METHOD add_numbers.
    ev_result = iv_n1 + iv_n2 + cv_num.
  ENDMETHOD.


  METHOD div_numbers2.
    ev_result = iv_n1 / iv_n2.
  ENDMETHOD.


  method MUL_NUMBERS.
    ev_result = iv_n1 * iv_n2.
  endmethod.


  METHOD sub_numbers.
    zstudy_class2=>sub_numbers(
      EXPORTING
        iv_n1     =   iv_n1  " Doğal sayı
        iv_n2     =   iv_n2  " Doğal sayı
      IMPORTING
        ev_result =   ev_result  " Doğal sayı
    ).
  ENDMETHOD.
ENDCLASS.
