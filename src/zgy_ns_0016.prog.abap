*&---------------------------------------------------------------------*
*& Report ZGY_NS_0016
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_ns_0016.

*DATA:gv_number TYPE i,
*     gv_result TYPE string.
*
*CASE gv_number.
*  WHEN 1.
*    gv_result = |Sayının değeri 1|.
*  WHEN 2.
*    gv_result = |Sayının değeri 2|.
*  WHEN 3.
*    gv_result = |Sayının değeri 3|.
*  WHEN 4.
*    gv_result = |Sayının değeri 4|.
*  WHEN 5.
*    gv_result = |Sayının değeri 5|.
*  WHEN OTHERS.
*    gv_result = |Sayının değeri idk|.
*ENDCASE.
*
*WRITE gv_result.

*--------------------------------------------------------------------*
DATA:gv_number TYPE i.

DATA(lv_result) = SWITCH string( gv_number
                                           WHEN 1 THEN |Sayının değeri 1|
                                           WHEN 2 THEN |Sayının değeri 2|
                                           WHEN 3 THEN |Sayının değeri 3|
                                           WHEN 4 THEN |Sayının değeri 4|
                                           WHEN 5 THEN |Sayının değeri 5|
                                           ELSE        |Sayının değeri idk| ).
WRITE lv_result.
