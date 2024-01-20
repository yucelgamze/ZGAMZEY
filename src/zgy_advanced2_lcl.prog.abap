*&---------------------------------------------------------------------*
*& Include          ZGAMZEY_ADVANCED2_LCL
*&---------------------------------------------------------------------*
CLASS lcl_class DEFINITION.
  PUBLIC SECTION.
    METHODS:
      get_data,
      call_screen,
      pbo_0100,
      pai_0100 IMPORTING iv_ucomm TYPE sy-ucomm,
      set_fcat,
      set_fcat_2,
      set_layout,
      display_alv,
      handle_button_click
                    FOR EVENT button_click OF cl_gui_alv_grid
        IMPORTING es_col_id
                    es_row_no,
      handle_button_click_2
                    FOR EVENT button_click OF cl_gui_alv_grid
        IMPORTING es_col_id
                    es_row_no.
ENDCLASS.
CLASS lcl_class IMPLEMENTATION.
  METHOD get_data.
    SELECT
    db_t~matnr,
    db_t~maktx,
    db_t~labst,
    db_t~demirbas_mi
    FROM zstok_t AS db_t
    WHERE demirbas_mi EQ 'S'
    INTO CORRESPONDING FIELDS OF TABLE @gt_alv.

    SELECT
    db_t~matnr,
    db_t~maktx,
    db_t~labst,
    db_t~demirbas_mi
    FROM zstok_t AS db_t
    WHERE demirbas_mi EQ 'D'
    INTO CORRESPONDING FIELDS OF TABLE @gt_alv_2.

  ENDMETHOD.

  METHOD call_screen.
    CALL SCREEN 0100.
  ENDMETHOD.

  METHOD pbo_0100.
    SET PF-STATUS '0100'.
    SET TITLEBAR '0100'.
  ENDMETHOD.

  METHOD pai_0100.
    CASE iv_ucomm.
      WHEN '&BACK'.
        SET SCREEN 0.
    ENDCASE.
  ENDMETHOD.

  METHOD set_fcat.

    CLEAR:gs_fcat.
    gs_fcat-ref_table = 'ZSTOK_T'.
    gs_fcat-ref_field = 'MATNR'.
    gs_fcat-fieldname = 'MATNR'.
    gs_fcat-scrtext_s = 'Malzeme num'.
    gs_fcat-scrtext_m = 'Malzeme numarası'.
    gs_fcat-scrtext_l = 'Malzeme numarası'.
    APPEND gs_fcat TO gt_fcat.

    CLEAR:gs_fcat.
    gs_fcat-ref_table = 'ZSTOK_T'.
    gs_fcat-ref_field = 'MAKTX'.
    gs_fcat-fieldname = 'MAKTX'.
    gs_fcat-scrtext_s = 'M.tanım'.
    gs_fcat-scrtext_m = 'Malzeme Tanımı'.
    gs_fcat-scrtext_l = 'Malzeme Tanımı'.
    APPEND gs_fcat TO gt_fcat.

    CLEAR:gs_fcat.
    gs_fcat-ref_table = 'ZSTOK_T'.
    gs_fcat-ref_field = 'LABST'.
    gs_fcat-fieldname = 'LABST'.
    gs_fcat-scrtext_s = 'Stok'.
    gs_fcat-scrtext_m = 'Stok Miktarı'.
    gs_fcat-scrtext_l = 'Stok Miktarı'.
    APPEND gs_fcat TO gt_fcat.

    CLEAR:gs_fcat.
    gs_fcat-ref_table = 'ZSTOK_T'.
    gs_fcat-ref_field = 'DEMIRBAS_MI'.
    gs_fcat-fieldname = 'DEMIRBAS_MI'.
    gs_fcat-scrtext_s = 'D Ekle'.
    gs_fcat-scrtext_m = 'Demirbaşlara Ekle'.
    gs_fcat-scrtext_l = 'Demirbaşlara Ekle'.
    gs_fcat-style = cl_gui_alv_grid=>mc_style_button.
    APPEND gs_fcat TO gt_fcat.
  ENDMETHOD.
  METHOD set_fcat_2.

    CLEAR:gs_fcat_2.
    gs_fcat_2-ref_table = 'ZSTOK_T'.
    gs_fcat_2-ref_field = 'MATNR'.
    gs_fcat_2-fieldname = 'MATNR'.
    gs_fcat_2-scrtext_s = 'Malzeme num'.
    gs_fcat_2-scrtext_m = 'Malzeme numarası'.
    gs_fcat_2-scrtext_l = 'Malzeme numarası'.
    APPEND gs_fcat_2 TO gt_fcat_2.

    CLEAR:gs_fcat_2.
    gs_fcat_2-ref_table = 'ZSTOK_T'.
    gs_fcat_2-ref_field = 'MAKTX'.
    gs_fcat_2-fieldname = 'MAKTX'.
    gs_fcat_2-scrtext_s = 'M.tanım'.
    gs_fcat_2-scrtext_m = 'Malzeme Tanımı'.
    gs_fcat_2-scrtext_l = 'Malzeme Tanımı'.
    APPEND gs_fcat_2 TO gt_fcat_2.

    CLEAR:gs_fcat_2.
    gs_fcat_2-ref_table = 'ZSTOK_T'.
    gs_fcat_2-ref_field = 'LABST'.
    gs_fcat_2-fieldname = 'LABST'.
    gs_fcat_2-scrtext_s = 'Stok'.
    gs_fcat_2-scrtext_m = 'Stok Miktarı'.
    gs_fcat_2-scrtext_l = 'Stok Miktarı'.
    APPEND gs_fcat_2 TO gt_fcat_2.

    CLEAR:gs_fcat_2.
    gs_fcat_2-ref_table = 'ZSTOK_T'.
    gs_fcat_2-ref_field = 'DEMIRBAS_MI'.
    gs_fcat_2-fieldname = 'DEMIRBAS_MI'.
    gs_fcat_2-scrtext_s = 'S Ekle'.
    gs_fcat_2-scrtext_m = 'Serbest Ekle'.
    gs_fcat_2-scrtext_l = 'Serbest Stoklara Ekle'.
    gs_fcat_2-style = cl_gui_alv_grid=>mc_style_button.
    APPEND gs_fcat_2 TO gt_fcat_2.
  ENDMETHOD.
  METHOD set_layout.
    gs_layout-zebra = abap_true.
    gs_layout-cwidth_opt = abap_true.
    gs_layout-col_opt = abap_true.
  ENDMETHOD.

  METHOD handle_button_click.
    READ TABLE gt_alv INTO DATA(ls_alv) INDEX es_row_no-row_id.
    DATA:ls_stok TYPE zstok_t.
    ls_stok-matnr       = ls_alv-matnr.
    ls_stok-maktx       = ls_alv-maktx.
    ls_stok-labst       = ls_alv-labst.
    ls_stok-demirbas_mi = 'D'.
    UPDATE zstok_t FROM ls_stok.
    go_local->get_data( ).
    CALL METHOD go_alv_grid->refresh_table_display.
    CALL METHOD go_alv_grid_2->refresh_table_display.
    CLEAR:ls_stok,ls_alv.
  ENDMETHOD.
  METHOD handle_button_click_2.
    READ TABLE gt_alv_2 INTO DATA(ls_alv_2) INDEX es_row_no-row_id.
    DATA:ls_stok TYPE zstok_t.
    ls_stok-matnr       = ls_alv_2-matnr.
    ls_stok-maktx       = ls_alv_2-maktx.
    ls_stok-labst       = ls_alv_2-labst.
    ls_stok-demirbas_mi = 'S'.
    UPDATE zstok_t FROM ls_stok.
    go_local->get_data( ).
    CALL METHOD go_alv_grid->refresh_table_display.
    CALL METHOD go_alv_grid_2->refresh_table_display.
    CLEAR:ls_stok,ls_alv_2.
  ENDMETHOD.

  METHOD display_alv.
    IF go_alv_grid IS INITIAL AND go_alv_grid_2 IS INITIAL.
      CREATE OBJECT go_container
        EXPORTING
          container_name = 'CC_ALV_SERBEST'.
      CREATE OBJECT go_alv_grid
        EXPORTING
          i_parent = go_container.
      SET HANDLER go_local->handle_button_click FOR go_alv_grid.
      CALL METHOD go_alv_grid->set_table_for_first_display
        EXPORTING
          is_layout       = gs_layout   " Layout
        CHANGING
          it_outtab       = gt_alv " Output Table
          it_fieldcatalog = gt_fcat.  " Field Catalog

      CREATE OBJECT go_container_2
        EXPORTING
          container_name = 'CC_ALV_DEMIRBAS'.
      CREATE OBJECT go_alv_grid_2
        EXPORTING
          i_parent = go_container_2.   " Parent Container
      SET HANDLER go_local->handle_button_click_2 FOR go_alv_grid_2.
      CALL METHOD go_alv_grid_2->set_table_for_first_display
        EXPORTING
          is_layout       = gs_layout   " Layout
        CHANGING
          it_outtab       = gt_alv_2 " Output Table
          it_fieldcatalog = gt_fcat_2.  " Field Catalog

    ELSE.
      CALL METHOD go_alv_grid->refresh_table_display.
      CALL METHOD go_alv_grid_2->refresh_table_display.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
