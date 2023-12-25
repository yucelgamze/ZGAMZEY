*&---------------------------------------------------------------------*
*& Report ZGY_COLLECT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_collect.

TYPES:BEGIN OF gty_type,
        col1 TYPE char1,
        col2 TYPE i,
      END OF gty_type.

DATA:gt_table   TYPE TABLE OF gty_type,
     gt_collect TYPE TABLE OF gty_type,
     gs_table   TYPE gty_type.

gs_table-col1 = 'A'.
gs_table-col2 = 10.
APPEND gs_table TO gt_table.

gs_table-col1 = 'B'.
gs_table-col2 = 20.
APPEND gs_table TO gt_table.

gs_table-col1 = 'A'.
gs_table-col2 = 30.
APPEND gs_table TO gt_table.

gs_table-col1 = 'B'.
gs_table-col2 = 40.
APPEND gs_table TO gt_table.

gs_table-col1 = 'C'.
gs_table-col2 = 50.
APPEND gs_table TO gt_table.

gs_table-col1 = 'A'.
gs_table-col2 = 60.
APPEND gs_table TO gt_table.


gs_table-col1 = 'A'.
gs_table-col2 = 10.
COLLECT gs_table INTO gt_collect.

gs_table-col1 = 'B'.
gs_table-col2 = 20.
COLLECT gs_table INTO gt_collect.

gs_table-col1 = 'A'.
gs_table-col2 = 30.
COLLECT gs_table INTO gt_collect.

gs_table-col1 = 'B'.
gs_table-col2 = 40.
COLLECT gs_table INTO gt_collect.

gs_table-col1 = 'C'.
gs_table-col2 = 50.
COLLECT gs_table INTO gt_collect.

gs_table-col1 = 'A'.
gs_table-col2 = 60.
COLLECT gs_table INTO gt_collect.


cl_demo_output=>write_data(
  EXPORTING
    value = gt_table ).

cl_demo_output=>write_data( gt_collect ).

cl_demo_output=>display( ).
