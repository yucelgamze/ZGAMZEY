*&---------------------------------------------------------------------*
*& Include          ZGY_SATIS_LCL
*&---------------------------------------------------------------------*
CLASS lcl_class DEFINITION.
  PUBLIC SECTION.
    METHODS:
      get_data,
      insert,
      template_xls_button,
      upload_xls,
      download_xls,
      call_screen,
      pbo_0100,
      pai_0100 IMPORTING iv_ucomm TYPE sy-ucomm,
      set_fcat,
      set_layout,
      display_alv.
ENDCLASS.
CLASS lcl_class IMPLEMENTATION.
  METHOD get_data.
    SELECT
    ad,
    data
    FROM zgy_t_0019
    INTO CORRESPONDING FIELDS OF TABLE @gt_alv.
  ENDMETHOD.
  METHOD insert.
    IF gv_ad      IS NOT INITIAL AND
       gv_data    IS NOT INITIAL.

*      DATA:ls_0018 TYPE zgy_t_0018.
      DATA:ls_0019 TYPE zgy_t_0019.

      ls_0019 = VALUE #( ad    = gv_ad
                         data  = gv_data ).

*      INSERT zgy_t_0018 FROM ls_0018.
      INSERT zgy_t_0019 FROM ls_0019.

      IF sy-subrc EQ 0.
        COMMIT WORK.
        MESSAGE i002 DISPLAY LIKE 'S'.
      ENDIF.
    ELSE.
      ROLLBACK WORK.
      MESSAGE i003 DISPLAY LIKE 'W'.
    ENDIF.
  ENDMETHOD.
  METHOD template_xls_button.

    gs_sel_button-icon_id   = icon_xls.
    gs_sel_button-icon_text = 'Şablon Excel'.
    gs_sel_button-quickinfo = 'Şablon Excel'.
    sscrfields-functxt_01   = gs_sel_button.

  ENDMETHOD.

  METHOD upload_xls.

    DATA:lt_raw TYPE truxs_t_text_data.

    CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
      EXPORTING
        i_line_header        = abap_true
        i_tab_raw_data       = lt_raw
        i_filename           = p_file
      TABLES
        i_tab_converted_data = gt_list
      EXCEPTIONS
        conversion_failed    = 1
        OTHERS               = 2.

  ENDMETHOD.
  METHOD download_xls.

    CALL METHOD cl_gui_frontend_services=>directory_browse
      CHANGING
        selected_folder = gv_folder.  " Folder Selected By User

    CONCATENATE gv_folder
                '\'
                sy-uname
                '-'
                sy-datum
                '-'
                sy-uzeit
                '.xls'
    INTO gv_filename.

    CLEAR:gs_header.
    gs_header-line = 'AD'.
    APPEND gs_header TO gt_header.
    CLEAR:gs_header.
    gs_header-line = 'DATA'.
    APPEND gs_header TO gt_header.

    CALL FUNCTION 'GUI_DOWNLOAD'
      EXPORTING
        filename              = gv_filename
        filetype              = 'ASC'
        write_field_separator = 'X'
      TABLES
        data_tab              = gt_alv
        fieldnames            = gt_header. "başlıkları doldurulan itab

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
      WHEN '&F5'.
        go_alv_grid->refresh_table_display( ).
      WHEN '&F7'.
        go_local->download_xls( ).
      WHEN '&SAVE'.
        go_local->insert( ).
        go_local->get_data( ).
        go_alv_grid->refresh_table_display( ).
    ENDCASE.
  ENDMETHOD.

  METHOD set_fcat.
*    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
*      EXPORTING
*        i_structure_name = 'ZGY_S_SATIS'
*      CHANGING
*        ct_fieldcat      = gt_fcat.

    CLEAR gs_fcat.
    gs_fcat =  VALUE #( col_pos    = 1
                        ref_table  = 'ZGY_T_0018'
                        ref_field  = 'AD'
                        fieldname  = 'AD'
                        scrtext_s  = 'AD'
                        scrtext_m  = 'AD'
                        scrtext_l  = 'AD').
    APPEND gs_fcat TO gt_fcat.

    CLEAR gs_fcat.
    gs_fcat =  VALUE #( col_pos    = 2
                        ref_table  = 'ZGY_T_0018'
                        ref_field  = 'DATA'
                        fieldname  = 'DATA'
                        scrtext_s  = 'DATA'
                        scrtext_m  = 'DATA'
                        scrtext_l  = 'DATA').
    APPEND gs_fcat TO gt_fcat.

  ENDMETHOD.

  METHOD set_layout.
    gs_layout-zebra      = abap_true.
    gs_layout-cwidth_opt = abap_true.
    gs_layout-col_opt    = abap_true.
    gs_layout-sel_mode   = 'A'.
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

    IF go_alv_grid2 IS INITIAL.
      CREATE OBJECT go_container2
        EXPORTING
          container_name = 'CC_ALV_XLS_UPLOAD'.   " Name of the Screen CustCtrl Name to Link Container To
      CREATE OBJECT go_alv_grid2
        EXPORTING
*         i_parent = cl_gui_container=>screen0.
          i_parent = go_container2.   " Parent Container
      CALL METHOD go_alv_grid2->set_table_for_first_display
        EXPORTING
          is_layout       = gs_layout   " Layout
        CHANGING
          it_outtab       = gt_list " Output Table
          it_fieldcatalog = gt_fcat.  " Field Catalog

    ELSE.
      CALL METHOD go_alv_grid2->refresh_table_display.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
