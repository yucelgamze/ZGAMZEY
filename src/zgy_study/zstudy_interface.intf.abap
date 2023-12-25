interface ZSTUDY_INTERFACE
  public .


  class-methods MULT_NUMBERS
    importing
      value(IV_N1) type INT4 optional
      value(IV_N2) type INT4 optional
    exporting
      !EV_RESULT type INT4 .
endinterface.
