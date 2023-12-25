*&---------------------------------------------------------------------*
*& Report ZGY_COLLECT_EKPO
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_collect_ekpo.

TYPES:BEGIN OF gty_total,
        ebeln TYPE ebeln,
        matnr TYPE matnr,
        menge TYPE menge_d,
        meins TYPE meins,
      END OF gty_total.

DATA:gt_total TYPE TABLE OF gty_total,
     gs_total TYPE gty_total,
     gt_ekpo  TYPE TABLE OF ekpo,
     gs_ekpo  TYPE ekpo.


SELECT *
  FROM ekpo
  INTO TABLE gt_ekpo
  WHERE ebeln IN ( '4500000071', '4500000081', '4500000083', '4500000084', '4500000168' ).

LOOP AT gt_ekpo INTO gs_ekpo.
  CLEAR:gs_total.
  MOVE-CORRESPONDING gs_ekpo TO gs_total.
  COLLECT gs_total INTO gt_total.
ENDLOOP.

cl_demo_output=>write_data( gt_ekpo ).
cl_demo_output=>write_data( gt_total ).
cl_demo_output=>display( ).
