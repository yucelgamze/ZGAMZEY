*&---------------------------------------------------------------------*
*& Include          ZGY_SATIS_LCL
*&---------------------------------------------------------------------*
CLASS lcl_class DEFINITION.
  PUBLIC SECTION.
    METHODS:
      get_data,
      print_adobe,
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
    vbeln ,
    erdat ,
    ernam ,
    audat ,
    auart ,
    vkorg ,
    vtweg
    FROM vbak
    WHERE vbeln IN @so_vbeln
    INTO CORRESPONDING FIELDS OF TABLE @gt_alv.
  ENDMETHOD.
  METHOD print_adobe.

    DATA:lt_index_rows TYPE lvc_t_row.

    CALL METHOD go_alv_grid->get_selected_rows
      IMPORTING
        et_index_rows = lt_index_rows.  " Indexes of Selected Rows

    IF lt_index_rows IS INITIAL.
      MESSAGE |Lütfen PRINT ADOBE işlemi için bir satır seçin!!!| TYPE 'I' DISPLAY LIKE 'W'.
    ELSE.

      LOOP AT lt_index_rows INTO DATA(ls_index_rows).

        READ TABLE gt_alv ASSIGNING FIELD-SYMBOL(<lfs_s_alv>) INDEX ls_index_rows-index.

        IF sy-subrc EQ 0.
          DATA(lv_vbeln) = <lfs_s_alv>-vbeln.
        ENDIF.

      ENDLOOP.
    ENDIF.

    SELECT SINGLE
    vbeln,
    erdat,
    ernam,
    audat,
    auart,
    vkorg,
    vtweg
    FROM vbak
    INTO @gs_header
    WHERE vbak~vbeln EQ @lv_vbeln.

    IF sy-subrc EQ 0.

      SELECT
      vbeln,
      posnr,
      matnr,
      charg,
      netwr,
      waerk,
      werks
      FROM vbap
      INTO TABLE @gt_items
      WHERE vbap~vbeln EQ @gs_header-vbeln.

    ENDIF.

    fp_outputparams-device      = 'PRINTER'.
    fp_outputparams-nodialog    = 'X'.
    fp_outputparams-preview     = 'X'.
*    fp_outputparams-nopreview     = 'X'.
    fp_outputparams-dest        = 'LP01'.

    CALL FUNCTION 'FP_JOB_OPEN'
      CHANGING
        ie_outputparams = fp_outputparams
      EXCEPTIONS
        cancel          = 1
        usage_error     = 2
        system_error    = 3
        internal_error  = 4
        OTHERS          = 5.

    CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
      EXPORTING
        i_name     = 'ZGY_AF_0001'
      IMPORTING
        e_funcname = fm_name.

    CALL FUNCTION fm_name
      EXPORTING
        /1bcdwb/docparams = fp_docparams
        is_header         = gs_header
        it_items          = gt_items
*   IMPORTING
*       /1BCDWB/FORMOUTPUT       =
      EXCEPTIONS
        usage_error       = 1
        system_error      = 2
        internal_error    = 3.

    CALL FUNCTION 'FP_JOB_CLOSE'
*   IMPORTING
*     E_RESULT             =
      EXCEPTIONS
        usage_error    = 1
        system_error   = 2
        internal_error = 3
        OTHERS         = 4.

  ENDMETHOD.

  METHOD template_xls_button.

    gs_sel_button-icon_id   = icon_xls.
    gs_sel_button-icon_text = 'Template EXCEL'.
    gs_sel_button-quickinfo = 'Download Template EXCEL'.
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
      WHEN '&F6'.
        go_local->print_adobe( ).
      WHEN '&F7'.
        go_local->download_xls( ).
    ENDCASE.
  ENDMETHOD.

  METHOD set_fcat.
    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name = 'ZGY_S_SATIS'
      CHANGING
        ct_fieldcat      = gt_fcat.

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
