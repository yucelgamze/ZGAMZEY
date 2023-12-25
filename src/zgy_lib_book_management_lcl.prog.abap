*&---------------------------------------------------------------------*
*& Include          ZGY_LIB_BOOK_MANAGEMENT_LCL
*&---------------------------------------------------------------------*
CLASS lcl_class DEFINITION.
  PUBLIC SECTION.
    METHODS:
      get_data,
      check,
      save_book,
      delete_book,
      call_screen,
      call_pop_up_screen,
      pbo_0100,
      pbo_0200,
      pai_0100 IMPORTING iv_ucomm TYPE sy-ucomm,
      pai_0200 IMPORTING iv_ucomm TYPE sy-ucomm,
      set_fcat,
      set_layout,
      display_alv.
ENDCLASS.
CLASS lcl_class IMPLEMENTATION.
  METHOD get_data.
    SELECT
    book~book_id,
    book~book_name,
    book~book_writer
    FROM zgy_lib_book AS book
    INTO CORRESPONDING FIELDS OF TABLE @gt_alv.
  ENDMETHOD.

  METHOD check.
    SELECT SINGLE book_id
      FROM zgy_lib_book
      WHERE book_id EQ @gv_book_id
      INTO @DATA(lv_book_id).

    IF sy-subrc EQ 0.
      gv_found = 'X'.
      MESSAGE |Girilen BOOK ID adına kayıt vardır! Kayıt yapılamaz!|  TYPE 'I' DISPLAY LIKE 'W'.
    ELSE.
      gv_found = ' '.
      MESSAGE  |YENİ BOOK ID! Kayıt için uygundur!| TYPE 'I' DISPLAY LIKE 'I'.
    ENDIF.
  ENDMETHOD.

  METHOD save_book.

    DATA:ls_book TYPE zgy_lib_book.

    go_local->check( ).

    IF gv_found EQ abap_false.

      IF gv_book_id IS NOT INITIAL AND
         gv_book_name IS NOT INITIAL AND
         gv_book_writer IS NOT INITIAL.

        ls_book-book_id     = gv_book_id.
        ls_book-book_name   = gv_book_name.
        ls_book-book_writer = gv_book_writer.

        INSERT zgy_lib_book FROM ls_book.
        MESSAGE |Girilen veriler başarılı bir şekilde kaydedilmiştir!| TYPE 'I' DISPLAY LIKE 'S'.
      ENDIF.

    ELSE.
      MESSAGE |KAYIT SIRASINDA HATA! LÜTFEN BİLGİLERİ KONTROL EDİN!| TYPE 'I' DISPLAY LIKE 'W'.
    ENDIF.

  ENDMETHOD.

  METHOD delete_book.
    DATA:lt_index_rows TYPE lvc_t_row.

    CALL METHOD go_alv_grid->get_selected_rows
      IMPORTING
        et_index_rows = lt_index_rows.  " Indexes of Selected Rows

    IF lt_index_rows IS INITIAL.

      gv_flag = abap_false.
      MESSAGE |Lütfen silme işlemi için satır verisi seçin!| TYPE 'I' DISPLAY LIKE 'W'.

    ELSE.
      gv_flag = abap_true.

      LOOP AT lt_index_rows INTO DATA(ls_index_rows).
        READ TABLE gt_alv INTO gs_alv INDEX ls_index_rows-index.
      ENDLOOP.

      DELETE FROM zgy_lib_book WHERE book_id = gs_alv-book_id.

      IF sy-subrc EQ 0 .
        COMMIT WORK.
        MESSAGE |Silme işlemi başarılı bir şekilde gerçekleştirilmiştir!| TYPE 'I' DISPLAY LIKE 'S'.
      ELSE.
        ROLLBACK WORK.
        MESSAGE |Silme sırasında hata!| TYPE 'I' DISPLAY LIKE 'W'.
      ENDIF.

    ENDIF.
  ENDMETHOD.

  METHOD call_screen.
    CALL SCREEN 0100.
  ENDMETHOD.

  METHOD call_pop_up_screen.
    CALL SCREEN 0200 STARTING AT  60 70
                     ENDING AT    120 80.
  ENDMETHOD.

  METHOD pbo_0100.
    SET PF-STATUS '0100'.
    SET TITLEBAR '0100'.
  ENDMETHOD.

  METHOD pai_0100.
    CASE iv_ucomm.
      WHEN '&BACK'.
        SET SCREEN 0.
      WHEN '&ADD'.
        go_local->call_pop_up_screen( ).
      WHEN '&DELETE'.
        go_local->delete_book( ).
        IF gv_flag = abap_true.
          go_local->get_data( ).
          CALL METHOD go_alv_grid->refresh_table_display.
        ENDIF.
    ENDCASE.
  ENDMETHOD.

  METHOD set_fcat.
    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name = 'ZGY_LIB_BOOK'
      CHANGING
        ct_fieldcat      = gt_fcat.

  ENDMETHOD.

  METHOD pbo_0200.
    SET PF-STATUS '0200'.
    SET TITLEBAR '0200'.

  ENDMETHOD.

  METHOD pai_0200.
    CASE iv_ucomm.
      WHEN '&CANCEL'.
        SET SCREEN 0.
      WHEN '&OK'.
        SET SCREEN 0.
      WHEN '&SAVE'.
        go_local->save_book( ).
        go_local->get_data( ).
        go_alv_grid->refresh_table_display( ).
    ENDCASE.
  ENDMETHOD.

  METHOD set_layout.
    gs_layout-zebra = abap_true.
    gs_layout-cwidth_opt = abap_true.
    gs_layout-col_opt = abap_true.
  ENDMETHOD.

  METHOD display_alv.
    IF go_alv_grid IS INITIAL.
      CREATE OBJECT go_container
        EXPORTING
          container_name = 'CC_ALV'.   " Name of the Screen CustCtrl Name to Link Container To
      CREATE OBJECT go_alv_grid
        EXPORTING
*         i_parent = cl_gui_container=>screen0.
          i_parent = go_container.   " Parent Container
      CALL METHOD go_alv_grid->set_table_for_first_display
        EXPORTING
          is_layout       = gs_layout   " Layout
        CHANGING
          it_outtab       = gt_alv " Output Table
          it_fieldcatalog = gt_fcat.  " Field Catalog

    ELSE.
      CALL METHOD go_alv_grid->refresh_table_display.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
