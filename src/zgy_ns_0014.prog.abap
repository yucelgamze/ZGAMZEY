*&---------------------------------------------------------------------*
*& Report ZGY_NS_0014
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_ns_0014.

TYPES:BEGIN OF gty_itab,
        col1 TYPE char10,
        col2 TYPE i,
      END OF gty_itab.

DATA:gt_itab TYPE TABLE OF gty_itab,
     gs_itab TYPE gty_itab.

DATA:gv_lines  TYPE i,
     gv_toplam TYPE i.

gt_itab = VALUE #( ( col1 = 'AAA' col2 = 10 )
                   ( col1 = 'BBB' col2 = 20 )
                   ( col1 = 'CCC' col2 = 30 )
                   ( col1 = 'CCC' col2 = 39 )
                   ( col1 = 'CCC' col2 = 50 )
                   ( col1 = 'DDD' col2 = 40 ) ).

LOOP AT gt_itab INTO gs_itab WHERE col1 EQ 'AAA'.
  gv_lines = gv_lines + 1.
ENDLOOP.
WRITE:|Toplam AAA sayısı:|, gv_lines.

DATA(lv_lines) = REDUCE i( INIT x = 0 FOR ls_itab IN gt_itab NEXT x = x + 1 ).
WRITE:/ |Toplam sayı:|, lv_lines.

DATA(lv_lines_ccc) = REDUCE i( INIT x = 0 FOR ls_itab IN gt_itab WHERE ( col1 EQ 'CCC' )  NEXT x = x + 1 ).
WRITE:/ |Toplam CCC sayısı:|, lv_lines_ccc.

*--------------------------------------------------------------------*

LOOP AT gt_itab INTO gs_itab.
  gv_toplam = gv_toplam + gs_itab-col2.
ENDLOOP.
WRITE:/ |Toplam:|,gv_toplam.

DATA(lv_toplam) = REDUCE i( INIT x = 0 FOR ls_itab IN gt_itab NEXT x = x + ls_itab-col2 ).
WRITE:/ |Toplam:|,lv_toplam.

DATA(lv_toplam_c) = REDUCE i( INIT x = 0 FOR ls_itab IN gt_itab WHERE ( col1 EQ 'CCC' ) NEXT x = x + ls_itab-col2 ).
WRITE:/ |Toplam:|,lv_toplam_c.
