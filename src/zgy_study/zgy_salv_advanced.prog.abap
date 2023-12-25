*&---------------------------------------------------------------------*
*& Report ZGY_SALV_ADVANCED
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_salv_advanced.

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

  "zebra deseni ve başlık ekleme
  DATA:lo_display TYPE REF TO cl_salv_display_settings.

  lo_display = go_salv->get_display_settings( ).
  lo_display->set_list_header( value = 'SALV HEADER' ).
  lo_display->set_striped_pattern( value = abap_true ).


  " kolon genişliği ayarlama
  DATA:lo_columns TYPE REF TO cl_salv_columns.

  lo_columns = go_salv->get_columns( ).
  lo_columns->set_optimize( value = abap_true ).


  DATA:lo_column TYPE REF TO cl_salv_column.

  TRY.
      "kolon adını değiştirme
      lo_column = lo_columns->get_column( columnname = 'INVOICE' ).
      lo_column->set_long_text( value = 'YENİ Fatura Düzenleyici' ).
      lo_column->set_medium_text( value = 'YENİ Fatura D.' ).
      lo_column->set_short_text( value = 'YENİ Fat.' ).
    CATCH cx_salv_not_found.

  ENDTRY.

  TRY.
      "kolonun görünürlüğünü kapatır
      lo_column = lo_columns->get_column( columnname = 'MANDT' ).
      lo_column->set_visible(
          value = if_salv_c_bool_sap=>false
      ).
    CATCH cx_salv_not_found.

  ENDTRY.

  "toolbar ekleme
  DATA:lo_func TYPE REF TO cl_salv_functions.

  lo_func = go_salv->get_functions( ).
  lo_func->set_all( abap_true ).

  "top of page ekleme
  DATA:lo_header  TYPE REF TO cl_salv_form_layout_grid,
       lo_h_label TYPE REF TO cl_salv_form_label,
       lo_h_flow  TYPE REF TO cl_salv_form_layout_flow.

  CREATE OBJECT lo_header.

  lo_h_label = lo_header->create_label( row  = 1 column   = 1 ).
  lo_h_label->set_text( value = 'Başlık ilk satır' ).

  lo_h_flow  = lo_header->create_flow( row  = 2 column   = 1 ).
  lo_h_flow->create_text( text = 'Başlık ikinci satır' ).

  go_salv->set_top_of_list( value = lo_header ).


"popup screen olarak gösterme
  go_salv->set_screen_popup(
    EXPORTING
      start_column = 10
      end_column   = 75
      start_line   = 5
      end_line     = 25
  ).

  go_salv->display( ).
