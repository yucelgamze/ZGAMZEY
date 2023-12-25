*&---------------------------------------------------------------------*
*& Include          ZGY_LIB_MEMBER_MANAGEMENT_LCL
*&---------------------------------------------------------------------*
CLASS lcl_class DEFINITION.
  PUBLIC SECTION.
    METHODS:
      get_data,
      get_data2,
      get_data3,
      check,
      save_member,
      delete_member,
      pasive_member,
      borrow_book,
      return_book,
      call_screen,
      call_pop_up_screen,
      call_pop_up_screen2,
      call_pop_up_screen3,
      pbo_0100,
      pbo_0200,
      pbo_0300,
      pbo_0400,
      pai_0100 IMPORTING iv_ucomm TYPE sy-ucomm,
      pai_0200 IMPORTING iv_ucomm TYPE sy-ucomm,
      pai_0300 IMPORTING iv_ucomm TYPE sy-ucomm,
      pai_0400 IMPORTING iv_ucomm TYPE sy-ucomm,
      set_fcat,
      set_fcat2,
      set_fcat3,
      set_layout,
      set_layout2,
      set_layout3,
      display_alv,
      display_alv2,
      display_alv3.
ENDCLASS.
CLASS lcl_class IMPLEMENTATION.
  METHOD get_data.

    SELECT
    member~member_id,
    member~member_name,
    member~member_surname,
    member~pasive
    FROM zgy_lib_member AS member
    INTO CORRESPONDING FIELDS OF TABLE @gt_alv.

  ENDMETHOD.

  METHOD get_data2.
    SELECT
      borrow~member_id,
      book~book_id,
      book~book_name,
      book~book_writer,
      borrow~borrow_date
      FROM zgy_lib_book AS book
      LEFT OUTER JOIN zgy_lib_borrow AS borrow
      ON book~book_id EQ  borrow~book_id
*      WHERE borrow~borrow_date EQ @space
      INTO CORRESPONDING FIELDS OF TABLE @gt_alv2.

  ENDMETHOD.

  METHOD get_data3.
    SELECT
    member~member_id,
    borrow~book_id,
    borrow~borrow_date,
    borrow~return_date
    FROM zgy_lib_borrow AS borrow
    LEFT JOIN zgy_lib_member AS member
    ON borrow~member_id EQ member~member_id
*    WHERE borrow~return_date IS NULL
    INTO CORRESPONDING FIELDS OF TABLE @gt_alv3.
  ENDMETHOD.

  METHOD check.

    SELECT SINGLE member_id
      FROM zgy_lib_member
      WHERE member_id EQ @gv_member_id
      INTO @DATA(lv_member_id).

    IF sy-subrc EQ 0.
      gv_found = 'X'.
      MESSAGE |Girilen MEMBER ID kaydı mevcuttur!!! Kayıt yapılamaz!!!| TYPE 'I' DISPLAY LIKE 'W'.
    ELSE.
      gv_found = ' '.
      MESSAGE  |YENİ MEMBER ID! Kayıt için uygundur!| TYPE 'I' DISPLAY LIKE 'S'.
    ENDIF.
  ENDMETHOD.

  METHOD save_member.

    DATA:ls_member TYPE zgy_lib_member.

    go_local->check( ).

    IF gv_found EQ abap_false.

      IF gv_member_id IS NOT INITIAL AND
         gv_member_name IS NOT INITIAL AND
         gv_member_surname IS NOT INITIAL.

        ls_member-member_id        = gv_member_id.
        ls_member-member_name      = gv_member_name.
        ls_member-member_surname   = gv_member_surname.
        ls_member-pasive           = gv_pasive.

        INSERT zgy_lib_member FROM ls_member.
        MESSAGE |Girilen veriler başarılı bir şekilde kaydedilmiştir!| TYPE 'I' DISPLAY LIKE 'S'.
      ENDIF.
    ELSE.
      MESSAGE |KAYIT SIRASINDA HATA! LÜTFEN BİLGİLERİ KONTROL EDİN!| TYPE 'I' DISPLAY LIKE 'W'.
    ENDIF.

  ENDMETHOD.

  METHOD delete_member.

    DATA:lt_index_rows TYPE lvc_t_row.

    CALL METHOD go_alv_grid->get_selected_rows
      IMPORTING
        et_index_rows = lt_index_rows.  " Indexes of Selected Rows

    IF lt_index_rows IS INITIAL.
      gv_flag = ' '.
      MESSAGE |Lütfen silme işlemi için bir satır seçin!!!| TYPE 'I' DISPLAY LIKE 'W'.
    ELSE.
      gv_flag = 'X'.

      LOOP AT lt_index_rows INTO DATA(ls_index_rows).

        READ TABLE gt_alv INTO gs_alv INDEX ls_index_rows-index.

      ENDLOOP.

      DELETE FROM zgy_lib_member WHERE member_id = gs_alv-member_id.

      IF sy-subrc EQ 0.
        COMMIT WORK.
        MESSAGE |Başarılı bir şekilde silinmiştir!| TYPE 'I' DISPLAY LIKE 'S'.
      ELSE.
        ROLLBACK WORK.
        MESSAGE |Silme sırasında hata!| TYPE 'I' DISPLAY LIKE 'W'.
      ENDIF.
    ENDIF.

  ENDMETHOD.

  METHOD pasive_member.
    DATA:lt_index_rows TYPE lvc_t_row.
    CALL METHOD go_alv_grid->get_selected_rows
      IMPORTING
        et_index_rows = lt_index_rows.  " Indexes of Selected Rows

    IF lt_index_rows IS INITIAL.
      gv_flag2 = ' '.
      MESSAGE |Lütfen pasifleştirme işlemi için satır seçin!| TYPE 'I' DISPLAY LIKE 'W'.
    ELSE.
      gv_flag2 = 'X'.

      LOOP AT lt_index_rows INTO DATA(ls_index_rows).
        READ TABLE gt_alv INTO gs_alv INDEX ls_index_rows-index.
      ENDLOOP.

      IF gs_alv-pasive EQ abap_false.
        UPDATE zgy_lib_member SET
*      pasive = 'X'
         pasive = abap_true
        WHERE member_id = gs_alv-member_id.

      ELSE.
        UPDATE zgy_lib_member SET
*      pasive = ' '
       pasive = abap_false
      WHERE member_id = gs_alv-member_id.
      ENDIF.


    ENDIF.

  ENDMETHOD.

  METHOD borrow_book.

    DATA:lt_index_rows2 TYPE lvc_t_row.
    DATA:lt_index_rows TYPE lvc_t_row.
    DATA:ls_borrow TYPE zgy_lib_borrow.

    CALL METHOD go_alv_grid->get_selected_rows
      IMPORTING
        et_index_rows = lt_index_rows2.  " Indexes of Selected Rows

    IF lt_index_rows2 IS INITIAL.
      MESSAGE |Lütfen BORROW işlemi için bir member ID satır seçin!| TYPE 'I' DISPLAY LIKE 'W'.

    ELSE.

      LOOP AT lt_index_rows2 INTO DATA(ls_index_rows2).
        READ TABLE gt_alv INTO gs_alv INDEX ls_index_rows2-index.
      ENDLOOP.

      CALL METHOD go_alv_grid2->get_selected_rows
        IMPORTING
          et_index_rows = lt_index_rows.  " Indexes of Selected Rows
      IF lt_index_rows IS INITIAL.
        MESSAGE |Lütfen BORROW işlemi için bir satır seçin!| TYPE 'I' DISPLAY LIKE 'W'.
      ELSE.
        LOOP AT lt_index_rows INTO DATA(ls_index_rows).
          READ TABLE gt_alv2 INTO gs_alv2 INDEX ls_index_rows-index.
        ENDLOOP.

        ls_borrow-member_id   = gs_alv-member_id.
        ls_borrow-book_id     = gs_alv2-book_id.
        ls_borrow-borrow_date = sy-datum.

        INSERT zgy_lib_borrow FROM ls_borrow.
        MESSAGE |Seçilen kitap için BORROW işlemi başarılı bir şekilde gerçekleştirilmiştir!| TYPE 'I' DISPLAY LIKE 'S'.
      ENDIF.
    ENDIF.


  ENDMETHOD.

  METHOD return_book.

    DATA:lt_index_rows TYPE lvc_t_row.
    DATA:ls_borrow TYPE zgy_lib_borrow.

    CALL METHOD go_alv_grid3->get_selected_rows
      IMPORTING
        et_index_rows = lt_index_rows.  " Indexes of Selected Rows
    IF lt_index_rows IS INITIAL.
      MESSAGE |Lütfen RETURN işlemi için bir satır seçin!| TYPE 'I' DISPLAY LIKE 'W'.
    ELSE.
      LOOP AT lt_index_rows INTO DATA(ls_index_rows).
        READ TABLE gt_alv3 INTO gs_alv3 INDEX ls_index_rows-index.
      ENDLOOP.

*      ls_borrow-borrow_date = sy-datum.

      UPDATE zgy_lib_borrow SET return_date = sy-datum
      WHERE member_id   = gs_alv3-member_id AND
            book_id     = gs_alv3-book_id.

      IF sy-subrc EQ 0.
        COMMIT WORK.
        MESSAGE |Seçilen kitap için RETURN işlemi başarılı bir şekilde gerçekleştirilmiştir!| TYPE 'I' DISPLAY LIKE 'S'.
      ENDIF.

    ENDIF.

  ENDMETHOD.
  METHOD call_screen.
    CALL SCREEN 0100.
  ENDMETHOD.

  METHOD call_pop_up_screen.
    CALL SCREEN 0200 STARTING AT 1  10
                     ENDING AT   60 20.
  ENDMETHOD.

  METHOD call_pop_up_screen2.
    CALL SCREEN 0300 STARTING AT  60 60
                     ENDING AT    120 80.
  ENDMETHOD.

  METHOD call_pop_up_screen3.
    CALL SCREEN 0400 STARTING AT  60 60
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
        go_local->delete_member( ).
        IF gv_flag EQ abap_true.
          go_local->get_data( ).
          go_alv_grid->refresh_table_display( ).
        ENDIF.
      WHEN '&PASIVE'.
        go_local->pasive_member( ).
      WHEN '&BORROW'.
        go_local->call_pop_up_screen2( ).
      WHEN '&RETURN'.
        go_local->call_pop_up_screen3( ).
    ENDCASE.
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
        go_local->save_member( ).
        go_local->get_data( ).
        go_alv_grid->refresh_table_display( ).
    ENDCASE.
  ENDMETHOD.

  METHOD pbo_0300.
    SET PF-STATUS '0300'.
    SET TITLEBAR '0300'.
  ENDMETHOD.

  METHOD pai_0300.
    CASE iv_ucomm.
      WHEN '&CANCEL'.
        SET SCREEN 0.
      WHEN '&OK'.
        SET SCREEN 0.
      WHEN '&BORROW'.
        go_local->borrow_book( ).
        go_local->get_data2( ).
        go_alv_grid2->refresh_table_display( ).
    ENDCASE.
  ENDMETHOD.

  METHOD pbo_0400.
    SET PF-STATUS '0400'.
    SET TITLEBAR '0400'.
  ENDMETHOD.


  METHOD pai_0400.
    CASE iv_ucomm.
      WHEN '&CANCEL'.
        SET SCREEN 0.
      WHEN '&OK'.
        SET SCREEN 0.
      WHEN '&RETURN'.
        go_local->return_book( ).
        go_local->get_data3( ).
        go_alv_grid3->refresh_table_display( ).
    ENDCASE.
  ENDMETHOD.

  METHOD set_fcat.
    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name = 'ZGY_LIB_MEMBER'
      CHANGING
        ct_fieldcat      = gt_fcat.

  ENDMETHOD.

  METHOD set_fcat2.
    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name = 'ZGY_LIB_BOOK_MEMBER'
      CHANGING
        ct_fieldcat      = gt_fcat2.


  ENDMETHOD.

  METHOD set_fcat3.
    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name = 'ZGY_LIB_RETURN'
      CHANGING
        ct_fieldcat      = gt_fcat3.

  ENDMETHOD.

  METHOD set_layout.
    gs_layout-zebra      = abap_true.
    gs_layout-cwidth_opt = abap_true.
    gs_layout-col_opt    = abap_true.
  ENDMETHOD.

  METHOD set_layout2.
    gs_layout2-zebra      = abap_true.
    gs_layout2-cwidth_opt = abap_true.
    gs_layout2-col_opt    = abap_true.
    gs_layout2-sel_mode   = 'A'.
  ENDMETHOD.

  METHOD set_layout3.
    gs_layout3-zebra      = abap_true.
    gs_layout3-cwidth_opt = abap_true.
    gs_layout3-col_opt    = abap_true.
    gs_layout3-sel_mode   = 'A'.
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

  METHOD display_alv2.
    IF go_alv_grid2 IS INITIAL.
      CREATE OBJECT go_container2
        EXPORTING
          container_name = 'CC_ALV_BORROW'.   " Name of the Screen CustCtrl Name to Link Container To
      CREATE OBJECT go_alv_grid2
        EXPORTING
*         i_parent = cl_gui_container=>screen0.
          i_parent = go_container2.   " Parent Container
      CALL METHOD go_alv_grid2->set_table_for_first_display
        EXPORTING
          is_layout       = gs_layout2   " Layout
        CHANGING
          it_outtab       = gt_alv2 " Output Table
          it_fieldcatalog = gt_fcat2.  " Field Catalog

    ELSE.
      CALL METHOD go_alv_grid2->refresh_table_display.
    ENDIF.
  ENDMETHOD.

  METHOD display_alv3.
    IF go_alv_grid3 IS INITIAL.
      CREATE OBJECT go_container3
        EXPORTING
          container_name = 'CC_ALV_RETURN'.   " Name of the Screen CustCtrl Name to Link Container To
      CREATE OBJECT go_alv_grid3
        EXPORTING
*         i_parent = cl_gui_container=>screen0.
          i_parent = go_container3.   " Parent Container
      CALL METHOD go_alv_grid3->set_table_for_first_display
        EXPORTING
          is_layout       = gs_layout3   " Layout
        CHANGING
          it_outtab       = gt_alv3 " Output Table
          it_fieldcatalog = gt_fcat3.  " Field Catalog

    ELSE.
      CALL METHOD go_alv_grid3->refresh_table_display.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
