*&---------------------------------------------------------------------*
*& Report ZGY_SALV
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_salv.

DATA:gt_sbook TYPE TABLE OF sbook,
     go_salv  TYPE REF TO cl_salv_table.

START-OF-SELECTION.

  SELECT *
    FROM sbook
    UP TO 20 ROWS
    INTO TABLE gt_sbook.

  cl_salv_table=>factory(
    IMPORTING
      r_salv_table   = go_salv   " Basis Class Simple ALV Tables
    CHANGING
      t_table        = gt_sbook
  ).

  go_salv->display( ).
