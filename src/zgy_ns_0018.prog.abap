*&---------------------------------------------------------------------*
*& Report ZGY_NS_0018
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_ns_0018.

TABLES:scarr.

TYPES:BEGIN OF gty_filter,
        currcode TYPE	s_currcode,
      END OF gty_filter.

DATA:gt_filter TYPE SORTED TABLE OF gty_filter WITH UNIQUE KEY currcode.

gt_filter = VALUE #( ( currcode = 'EUR')
                     ( currcode = 'USD') ).

SELECT * FROM scarr INTO TABLE @DATA(lt_scarr).

DATA(lt_filter) = FILTER #( lt_scarr IN gt_filter WHERE currcode EQ currcode ).

cl_demo_output=>write_data( value = gt_filter ).
cl_demo_output=>write_data( value = lt_scarr ).
cl_demo_output=>write_data( value = lt_filter ).

cl_demo_output=>display( ).
