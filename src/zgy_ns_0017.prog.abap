*&---------------------------------------------------------------------*
*& Report ZGY_NS_0017
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_ns_0017.

TYPES:BEGIN OF gty_type1,
        col1 TYPE char1,
        col2 TYPE char1,
      END OF gty_type1.

TYPES:BEGIN OF gty_type2,
        col1 TYPE char1,
        col2 TYPE char1,
        col3 TYPE char1,
      END OF gty_type2.

DATA:gt_table1 TYPE TABLE OF gty_type1,
     gs_table1 TYPE gty_type1,
     gt_table2 TYPE TABLE OF gty_type2,
     gs_table2 TYPE gty_type2.

gt_table1 = VALUE #( ( col1 = 'A' col2 = '1'  )
                     ( col1 = 'B' col2 = '2'  )
                     ( col1 = 'C' col2 = '3'  )
                     ( col1 = 'D' col2 = '4'  ) ).



*LOOP AT gt_table1 INTO gs_table1.
*  MOVE-CORRESPONDING gs_table1 TO gs_table2.
*  APPEND gs_table2 TO gt_table2.
*ENDLOOP.

"corresponding structure aktarma:

*LOOP AT gt_table1 INTO gs_table1.
**  MOVE-CORRESPONDING gs_table1 TO gs_table2.
*  gs_table2 = CORRESPONDING #( gs_table1 ).
*  APPEND gs_table2 TO gt_table2.
*ENDLOOP.

"corresponding table aktarma:

*gt_table2 = CORRESPONDING #( gt_table1 ).

*gt_table2 = CORRESPONDING #( gt_table1 EXCEPT col1 ).

*gt_table2 = CORRESPONDING #( gt_table1 MAPPING col3 = col1 ).

gt_table2 = CORRESPONDING #( gt_table1 MAPPING col3 = col1 EXCEPT col1 ).

cl_demo_output=>write_data( value = gt_table1 ).
cl_demo_output=>write_data( value = gt_table2 ).
cl_demo_output=>display( ).
