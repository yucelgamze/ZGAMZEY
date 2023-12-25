*&---------------------------------------------------------------------*
*& Report ZGY_NS_0025
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_ns_0025.

*TYPES:BEGIN OF gty_source,
*        col1 TYPE char1,
*        col2 TYPE char2,
*      END OF gty_source.
*
*TYPES:BEGIN OF gty_target,
*        col2 TYPE char1,
*        col3 TYPE char1,
*      END OF gty_target.
*
*DATA:gs_source  TYPE gty_source,
*     gs_target  TYPE gty_target,
*     gs_target2 TYPE gty_target.
*
*gs_source = VALUE #( col1 = '1'
*                     col2 = '2' ).
*
*gs_target = VALUE #( col2 = 'a'
*                     col3 = 'b' ).
*
*gs_target2 = VALUE #( col2 = 'a'
*                      col3 = 'b' ).
*
*cl_demo_output=>write_data( gs_source ).
*cl_demo_output=>write_data( gs_target2 ).
*gs_target2 = CORRESPONDING #( BASE ( gs_target2 )  gs_source ).
*
*cl_demo_output=>write_data( gs_target2 ).
*cl_demo_output=>write_data( gs_target ).
*cl_demo_output=>display( ).

*--------------------------------------------------------------------*
TYPES:BEGIN OF gty_type,
        col1 TYPE char2,
        col2 TYPE char2,
        col3 TYPE char2,
      END OF gty_type.

DATA:
  gt_target1 TYPE TABLE OF gty_type,
  gt_target2 TYPE TABLE OF gty_type.

*gt_source = VALUE #( ( col1 = 'x1' col2 = 'y1' col3 = 'z1' )
*                     ( col1 = 'x2' col2 = 'y2' col3 = 'z2' )
*                     ( col1 = 'x3' col2 = 'y3' col3 = 'z3' ) ).

gt_target1 = VALUE #( ( col1 = 'A1' col2 = 'B1' col3 = 'C1' )
                      ( col1 = 'A2' col2 = 'B2' col3 = 'C2' ) ).

gt_target2 = VALUE #( ( col1 = 'A1' col2 = 'B1' col3 = 'C1' )
                      ( col1 = 'A2' col2 = 'B2' col3 = 'C2' ) ).

gt_target1 = VALUE #( ( col1 = 'x1' col2 = 'y1' col3 = 'z1' )
                      ( col1 = 'x2' col2 = 'y2' col3 = 'z2' )
                      ( col1 = 'x3' col2 = 'y3' col3 = 'z3' ) ).

gt_target2 = VALUE #( BASE  gt_target2
                      ( col1 = 'x1' col2 = 'y1' col3 = 'z1' )
                      ( col1 = 'x2' col2 = 'y2' col3 = 'z2' )
                      ( col1 = 'x3' col2 = 'y3' col3 = 'z3' ) ).

cl_demo_output=>write_data( gt_target1 ).
cl_demo_output=>write_data( gt_target2 ).
cl_demo_output=>display( ).

"base eski dataları korur.
