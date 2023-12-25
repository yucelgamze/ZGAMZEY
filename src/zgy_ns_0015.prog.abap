*&---------------------------------------------------------------------*
*& Report ZGY_NS_0015
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_ns_0015.

*DATA:gv_not  TYPE i,
*     gv_harf TYPE char2.

*gv_not = 30.
*
*IF gv_not => 85.
*  gv_harf = 'AA'.
*ELSEIF gv_not => 70.
*  gv_harf = 'BB'.
*ELSEIF gv_not => 60.
*  gv_harf = 'CC'.
*ELSEIF gv_not => 50.
*  gv_harf = 'DD'.
*ELSE.
*  gv_harf = 'FF'.
*ENDIF.

*--------------------------------------------------------------------*

DATA:gv_not TYPE i.
gv_not = 90.

DATA(lv_letter) = COND string( WHEN gv_not => 80 THEN 'AA'
                               WHEN gv_not => 70 THEN 'BB'
                               WHEN gv_not => 60 THEN 'CC'
                               WHEN gv_not => 50 THEN 'DD'
                               ELSE 'FF').

WRITE:|Harf notu:|,lv_letter.
