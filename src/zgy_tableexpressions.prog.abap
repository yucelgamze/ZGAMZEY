*&---------------------------------------------------------------------*
*& Report ZGY_TABLEEXPRESSIONS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_tableexpressions.

"collect records

SELECT *
  FROM scarr
  INTO TABLE @DATA(lt_scarr).

cl_demo_output=>write(
  EXPORTING
    data =  lt_scarr   " Text or Data
*      name =
).

DATA(ls_scarr) = lt_scarr[ carrid = 'AA' ].

cl_demo_output=>write(
  EXPORTING
    data =  ls_scarr   " Text or Data
*    name =
).

************************************************************

DATA(ls_scarr_1) = lt_scarr[ 2 ].
cl_demo_output=>display(
  EXPORTING
    data = ls_scarr_1    " Text or Data
*    name =
).
************************************************************

DATA(lv_carrname) = lt_scarr[ carrid = 'BA' ]-carrname.
WRITE:lv_carrname.
