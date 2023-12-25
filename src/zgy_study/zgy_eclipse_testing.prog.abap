*&---------------------------------------------------------------------*
*& Report zgy_eclipse_testing
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_eclipse_testing.

START-OF-SELECTION.

*  MESSAGE 'Hello World!' TYPE 'I' DISPLAY LIKE 'S'.

  SELECT * FROM scarr
  INTO TABLE @DATA(lt_table).

  cl_demo_output=>display( lt_table ).
