*&---------------------------------------------------------------------*
*& Report ZGY_CORRESPONDINGMAPPINGEXCEPT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_correspondingmappingexcept.

SELECT * FROM scarr INTO TABLE @DATA(lt_scarr).

cl_demo_output=>write(
  EXPORTING
    data =  lt_scarr   " Text or Data
*      name =
).

******************************************************************

DATA: lt_scarr2 TYPE TABLE OF scarr.

lt_scarr2 = CORRESPONDING #( lt_scarr ).

cl_demo_output=>write(
  EXPORTING
    data =  lt_scarr2   " Text or Data
*    name =
).

******************************************************************

DATA: lt_scarr3 TYPE TABLE OF scarr.

lt_scarr3 = CORRESPONDING #( lt_scarr EXCEPT carrname url ).

cl_demo_output=>write(
  EXPORTING
    data =  lt_scarr3   " Text or Data
*    name =
).

******************************************************************

TYPES: BEGIN OF gty_scarr,
         carrid   TYPE s_carr_id,
         carrname TYPE s_carrname,
         currcode TYPE s_currcode,
         url      TYPE s_carrurl,
         name     TYPE s_carrname,
         weburl   TYPE s_carrurl,
       END OF gty_scarr.

DATA: lt_scarr_new TYPE TABLE OF gty_scarr.

lt_scarr_new = CORRESPONDING #( lt_scarr MAPPING name   = carrname
                                                 weburl = url
                                         EXCEPT  carrname url ).

cl_demo_output=>display(
  EXPORTING
    data =  lt_scarr_new   " Text or Data
*    name =
).
