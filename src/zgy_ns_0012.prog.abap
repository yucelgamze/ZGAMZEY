*&---------------------------------------------------------------------*
*& Report ZGY_NS_0012
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_ns_0012.

*TYPES:BEGIN OF gty_struct,
*        col1 TYPE i,
*        col2 TYPE i,
*        col3 TYPE i,
*      END OF gty_struct.

*DATA:gs_struct TYPE gty_struct.

*gs_struct-col1 = 10.
*gs_struct-col2 = 10.
*gs_struct-col3 = 10.

*gs_struct = VALUE gty_struct( col1 = 10
*                              col2 = 20
*                              col3 = 30 ).

*gs_struct = VALUE #( col1 = 10
*                     col2 = 20
*                     col3 = 30 ).

*DATA(ls_struct) = VALUE gty_struct( col1 = 10
*                                     col2 = 20
*                                     col3 = 30 ).

*******************************************************************************************
TYPES:BEGIN OF gty_struct,
        col1 TYPE i,
        col2 TYPE i,
        col3 TYPE i,
      END OF gty_struct.

DATA:gt_struct TYPE TABLE OF gty_struct,
     gs_struct TYPE gty_struct.

*gs_struct-col1 = 10.
*gs_struct-col2 = 30.
*gs_struct-col3 = 90.
*APPEND gs_struct TO gt_struct.
*
*gs_struct-col1 = 10.
*gs_struct-col2 = 300.
*gs_struct-col3 = 900.
*APPEND gs_struct TO gt_struct.
*
*gs_struct-col1 = 1.
*gs_struct-col2 = 3.
*gs_struct-col3 = 9.
*APPEND gs_struct TO gt_struct.

*gt_struct = VALUE #( ( col1 = 10  col2 = 30  col3 = 90  )
*                     ( col1 = 100 col2 = 300 col3 = 900 )
*                     ( col1 = 1   col2 = 3   col3 = 9   ) ).

*BREAK gamzey.

*******************************************************************************************

DATA:gt_range TYPE RANGE OF i,
     gs_range LIKE LINE OF gt_range.

*gs_range-sign   = 'I'.
*gs_range-option = 'EQ'.
*gs_range-low    = 10.
*APPEND gs_range TO gt_range.
*
*gs_range-sign   = 'I'.
*gs_range-option = 'BT'.
*gs_range-low    = 10.
*gs_range-high   = 90.
*APPEND gs_range TO gt_range.
*
*gs_range-sign   = 'I'.
*gs_range-option = 'BT'.
*gs_range-low    = 100.
*gs_range-high   = 900.
*APPEND gs_range TO gt_range.

*gt_range = VALUE #( ( sign = 'I' option = 'EQ' low = 10 )
*                    ( sign = 'I' option = 'EQ' low = 10 high = 90 )
*                    ( sign = 'I' option = 'EQ' low = 100 high = 900 ) ).

gt_range = VALUE #(  sign = 'I' ( option = 'EQ' low = 10 )
                                ( option = 'EQ' low = 10 high = 90 )
                                ( option = 'EQ' low = 100 high = 900 ) ).

BREAK gamzey.
