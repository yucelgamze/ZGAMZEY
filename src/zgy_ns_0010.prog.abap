*&---------------------------------------------------------------------*
*& Report ZGY_NS_0010
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_ns_0010.

SELECT * FROM scarr INTO TABLE @DATA(lt_scarr).

READ TABLE lt_scarr INTO DATA(ls_scarr) WITH KEY carrid = 'ZZ'.

TRY.
    DATA(ls_scarr2) = lt_scarr[ carrid = 'ZZ' ].
  CATCH cx_sy_itab_line_not_found.
ENDTRY.

DATA(ls_scarr3) = VALUE #( lt_scarr[ carrid = 'ZZ' ] OPTIONAL ).

BREAK-POINT.
