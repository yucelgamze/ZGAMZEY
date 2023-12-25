*&---------------------------------------------------------------------*
*& Report ZGY_VALUEOPERATOR
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_valueoperator.

TYPES: BEGIN OF gty_scarr,
         carrid   TYPE s_carrid,
         carrname TYPE s_carrname,
       END OF gty_scarr.

DATA: lt_scarr TYPE STANDARD TABLE OF gty_scarr.

DATA(ls_scarr) = VALUE gty_scarr( carrid = 'AA' carrname = 'American Airlines' ).

cl_demo_output=>write(
  EXPORTING
    data =  ls_scarr   " Text or Data
*    name =
).

lt_scarr = VALUE #(
                  ( carrid = 'AA' carrname = 'American Airlines')
                  ( carrid = 'TA' carrname = 'Turkish Airlines' )
                  ( carrid = 'BA' carrname = 'British Airlines' )
).

cl_demo_output=>display(
  EXPORTING
    data =  lt_scarr   " Text or Data
*    name =
).
