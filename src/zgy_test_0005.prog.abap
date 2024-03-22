*&---------------------------------------------------------------------*
*& Report ZGY_TEST_0005
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_test_0005.

*SELECT
*vkont,
*gpart
*FROM fkkvkp
*INTO TABLE @DATA(lt_tab)
*GROUP BY vkont, gpart.


DATA(lv_test) = '1234567890'.
DATA(lv_x) = |KM{ lv_test } |.
BREAK gamzey.

TYPES:BEGIN OF gty_date,
        date TYPE char20,
      END OF gty_date.

DATA:gt_date TYPE TABLE OF gty_date.

gt_date = VALUE #( ( date = '2/11/2021' )
                    ( date =  '2/1/2021' )
                    (  date = '12/3/2021' )
                    (  date = '12/22/2023' ) ).

LOOP AT gt_date ASSIGNING FIELD-SYMBOL(<lfs_date>).

  TRANSLATE <lfs_date>-date USING '/.'.
  CONDENSE <lfs_date>-date NO-GAPS.
  DATA(index) = strlen( <lfs_date>-date ).

  IF index = 8.
    <lfs_date>-date = | { <lfs_date>-date+4(4) }0{ <lfs_date>-date+0(1) }0{ <lfs_date>-date+2(1) } |. "1/1/2024
  ELSEIF index = 9.
    IF  <lfs_date>-date+0(2) CS '.'.
      <lfs_date>-date = | { <lfs_date>-date+5(4) }0{ <lfs_date>-date+0(1) }{ <lfs_date>-date+2(2) } |. "1/30/2024
    ELSE.
      <lfs_date>-date = | { <lfs_date>-date+5(4) }{ <lfs_date>-date+0(2) }0{ <lfs_date>-date+3(1) } |. "10/4/2024
    ENDIF.
  ELSEIF index = 10.
    <lfs_date>-date = | { <lfs_date>-date+6(4) }{ <lfs_date>-date+0(2) }{ <lfs_date>-date+3(2) } |.    "10/14/2024
  ENDIF.


  BREAK gamzey.
ENDLOOP.
