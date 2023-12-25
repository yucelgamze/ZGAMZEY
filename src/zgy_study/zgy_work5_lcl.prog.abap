*&---------------------------------------------------------------------*
*& Include          ZGY_WORK5_LCL
*&---------------------------------------------------------------------*
CLASS lcl_class DEFINITION.
  PUBLIC SECTION.
    METHODS:
      get_data,
      call_screen,
      pbo_0100,
      pai_0100 IMPORTING iv_ucomm TYPE sy-ucomm,
      set_fcat,
      set_layout,
      display_alv,
      get_sum.
ENDCLASS.

CLASS lcl_class IMPLEMENTATION.
  METHOD get_data.
    SELECT
      db_t~carrid,
      db_t~carrname,
      db_t~currcode,
      db_t~url,
       '@11@' AS durum
      FROM scarr AS db_t
      INTO  CORRESPONDING FIELDS OF TABLE @gt_alv.

    LOOP AT gt_alv ASSIGNING <gfs_alv>.
      CASE <gfs_alv>-currcode.
        WHEN 'USD'.
          <gfs_alv>-line_color = 'C710'.
        WHEN 'JPY'.
          <gfs_alv>-line_color = 'C100'.
        WHEN 'EUR'.
          CLEAR:gs_cell_color.
          gs_cell_color-fname = 'URL'.
          gs_cell_color-color-col = '3'.
          gs_cell_color-color-int = '0'.
          gs_cell_color-color-inv = '0'.
          APPEND gs_cell_color TO <gfs_alv>-cell_color.

          CLEAR:gs_cell_color.
          gs_cell_color-fname = 'CARRNAME'.
          gs_cell_color-color-col = '5'.
          gs_cell_color-color-int = '1'.
          gs_cell_color-color-inv = '0'.
          APPEND gs_cell_color TO <gfs_alv>-cell_color.
        WHEN 'ZAR'.
          CLEAR:gs_cell_color.
          gs_cell_color-fname = 'URL'.
          gs_cell_color-color-col = '6'.
          gs_cell_color-color-int = '0'.
          gs_cell_color-color-inv = '0'.
          APPEND gs_cell_color TO <gfs_alv>-cell_color.
        WHEN 'CHF'.
          CLEAR:gs_cell_color.
          gs_cell_color-fname = 'URL'.
          gs_cell_color-color-col = '6'.
          gs_cell_color-color-int = '0'.
          gs_cell_color-color-inv = '1'.
          APPEND gs_cell_color TO <gfs_alv>-cell_color.

      ENDCASE.
    ENDLOOP.
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
      WHEN '&SAVE'.
        go_local->get_sum( ).
    ENDCASE.
  ENDMETHOD.

  METHOD set_fcat.

    CLEAR:gs_fcat.
    gs_fcat-fieldname = 'DURUM'.
    gs_fcat-scrtext_s = 'Durum'.
    gs_fcat-scrtext_m = 'Durum'.
    gs_fcat-scrtext_l = 'Durum'.
    APPEND gs_fcat TO gt_fcat.

    CLEAR:gs_fcat.
    gs_fcat-fieldname = 'CARRID'.
    gs_fcat-scrtext_s = 'Havayolu tanımı'.
    gs_fcat-scrtext_m = 'Havayolu kısa tanımı'.
    gs_fcat-scrtext_l = 'Havayolu şirketinin kısa tanımı'.
    APPEND gs_fcat TO gt_fcat.

    CLEAR:gs_fcat.
    gs_fcat-fieldname = 'CARRNAME'.
    gs_fcat-scrtext_s = 'Havayolu adı'.
    gs_fcat-scrtext_m = 'Havayolu şirketinin adı'.
    gs_fcat-scrtext_l = 'Havayolu şirketinin adı'.
    APPEND gs_fcat TO gt_fcat.


    CLEAR:gs_fcat.
    gs_fcat-fieldname = 'CURRCODE'.
    gs_fcat-scrtext_s = 'PB'.
    gs_fcat-scrtext_m = 'Havayolu şirketinin ulusal para birimi'.
    gs_fcat-scrtext_l = 'Havayolu şirketinin ulusal para birimi'.
    APPEND gs_fcat TO gt_fcat.


    CLEAR:gs_fcat.
    gs_fcat-fieldname = 'URL'.
    gs_fcat-scrtext_s = 'URL'.
    gs_fcat-scrtext_m = 'Havayolu şirketinin URL'.
    gs_fcat-scrtext_l = 'Havayolu şirketinin URL'.
    APPEND gs_fcat TO gt_fcat.

    CLEAR:gs_fcat.
    gs_fcat-fieldname = 'COST'.
    gs_fcat-scrtext_s = 'COST'.
    gs_fcat-scrtext_m = 'COST'.
    gs_fcat-scrtext_l = 'COST'.
    APPEND gs_fcat TO gt_fcat.

    READ TABLE gt_fcat ASSIGNING <gfs_fcat> WITH KEY fieldname = 'COST'.
    IF sy-subrc EQ 0.
      <gfs_fcat>-edit = abap_true.
    ENDIF.

  ENDMETHOD.
  METHOD set_layout.
    CLEAR:gs_layout.
    gs_layout-col_opt    = abap_true.
    gs_layout-cwidth_opt = abap_true.
    " gs_layout-zebra      = abap_true.
    gs_layout-info_fname = 'LINE_COLOR'.
    gs_layout-ctab_fname = 'CELL_COLOR'.
  ENDMETHOD.

  METHOD display_alv.
    IF go_alv_grid IS INITIAL.
      CREATE OBJECT go_container
        EXPORTING
          container_name = 'CC_ALV'.
      CREATE OBJECT go_alv_grid
        EXPORTING
          i_parent = go_container.    " Parent Container
      CALL METHOD go_alv_grid->set_table_for_first_display
        EXPORTING
          is_layout       = gs_layout   " Layout
        CHANGING
          it_outtab       = gt_alv  " Output Table
          it_fieldcatalog = gt_fcat. " Field Catalog

      CALL METHOD go_alv_grid->register_edit_event
        EXPORTING
          i_event_id = cl_gui_alv_grid=>mc_evt_modified.
    ELSE.
      CALL METHOD go_alv_grid->refresh_table_display.
    ENDIF.
  ENDMETHOD.
  METHOD get_sum.
  ENDMETHOD.
ENDCLASS.
