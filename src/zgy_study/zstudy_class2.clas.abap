class ZSTUDY_CLASS2 definition
  public
  final
  create public

  global friends ZSTUDY_CLASS .

public section.
protected section.
private section.

  class-methods SUB_NUMBERS
    importing
      value(IV_N1) type INT4 optional
      value(IV_N2) type INT4 optional
    exporting
      !EV_RESULT type INT4 .
ENDCLASS.



CLASS ZSTUDY_CLASS2 IMPLEMENTATION.


  method SUB_NUMBERS.
    ev_result = iv_n1 - iv_n2.
  endmethod.
ENDCLASS.
