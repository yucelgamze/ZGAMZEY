*&---------------------------------------------------------------------*
*& Report ZGY_FOROPERATIONS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_foroperations.

TYPES: BEGIN OF gty_scarr,
         carrid   TYPE s_carrid,
         carrname TYPE s_carrname,
         currcode TYPE s_currcode,
         url      TYPE s_carrurl,
       END OF gty_scarr.

DATA: lt_scarr_op TYPE STANDARD TABLE OF gty_scarr.

SELECT
  FROM scarr FIELDS *
  INTO TABLE @DATA(lt_scarr).

IF sy-subrc IS INITIAL.
  lt_scarr_op = VALUE #( FOR ls_scarr IN lt_scarr WHERE ( currcode = 'USD' AND carrid = 'AA' )
                        ( carrid   = ls_scarr-carrid
                          carrname = ls_scarr-carrname
                          currcode = ls_scarr-currcode
                          url      = ls_scarr-url
                         )
   ).

ENDIF.

cl_demo_output=>display(
  EXPORTING
    data =  lt_scarr_op   " Text or Data
*    name =
).
