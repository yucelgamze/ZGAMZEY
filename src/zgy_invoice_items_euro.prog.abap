*&---------------------------------------------------------------------*
*& Report zgy_invoice_items_euro
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_invoice_items_euro.

CLASS lcl_main DEFINITION CREATE PRIVATE.

  PUBLIC SECTION.
    CLASS-METHODS create
      RETURNING
        VALUE(go_local) TYPE REF TO lcl_main.
    METHODS run.
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_main IMPLEMENTATION.

  METHOD create.

    CREATE OBJECT go_local.

  ENDMETHOD.

  METHOD run.

    DATA:go_invoices TYPE REF TO zcl_invoice_retrieval.

    go_invoices = NEW zcl_invoice_retrieval( ).

    DATA(invoice_items) = go_invoices->get_items_from_db(  ).

    cl_salv_table=>factory(
      IMPORTING
        r_salv_table   =  DATA(alv_table)   " Basis Class Simple ALV Tables
      CHANGING
        t_table        = invoice_items ).

    alv_table->display( ).

  ENDMETHOD.

ENDCLASS.

START-OF-SELECTION.

  lcl_main=>create( )->run( ).
