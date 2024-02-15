*&---------------------------------------------------------------------*
*& Include          ZGY_P_LCL
*&---------------------------------------------------------------------*
CLASS lcl_class DEFINITION.
  PUBLIC SECTION.
    METHODS:
      get_data,
      print_smartform,
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
    vbeln,
    erdat,
    ernam,
    audat,
    auart,
    vkorg,
    vtweg
    FROM vbak
    WHERE vbeln IN @so_vbeln
    INTO CORRESPONDING FIELDS OF TABLE @gt_alv.

  ENDMETHOD.
  METHOD print_smartform.

    DATA:lt_index_rows TYPE lvc_t_row.

    CALL METHOD go_alv_grid->get_selected_rows
      IMPORTING
        et_index_rows = lt_index_rows.   " Indexes of Selected Rows

    IF lt_index_rows IS INITIAL.
      MESSAGE i001 DISPLAY LIKE 'E'.
    ELSE.
      LOOP AT lt_index_rows INTO DATA(ls_index_row).
        READ TABLE gt_alv ASSIGNING FIELD-SYMBOL(<lfs_alv>) INDEX ls_index_row-index.
        IF sy-subrc IS INITIAL.
          DATA(lv_vbeln) = <lfs_alv>-vbeln.
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
    WHERE vbeln EQ @lv_vbeln
    INTO @gs_header.

    IF gs_header IS NOT INITIAL.
      SELECT
      vbeln,
      posnr,
      matnr,
      netwr,
      waerk,
      werks
      FROM vbap                                       "internal table olsaydı -> for all entries in
      WHERE vbeln EQ @gs_header-vbeln
      INTO CORRESPONDING FIELDS OF TABLE @gt_items.
    ENDIF.

    gs_controls-no_dialog = abap_true.
    gs_controls-preview   = abap_true.
    gs_output_op-tddest   = 'LP01'.

    CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
      EXPORTING
        formname           = 'ZGY_SF_0007'
      IMPORTING
        fm_name            = gv_fm_name
      EXCEPTIONS
        no_form            = 1
        no_function_module = 2
        OTHERS             = 3.

    CALL FUNCTION gv_fm_name
      EXPORTING
        control_parameters = gs_controls
        output_options     = gs_output_op
        user_settings      = ' '
        it_items           = gt_items
        is_header          = gs_header
      EXCEPTIONS
        formatting_error   = 1
        internal_error     = 2
        send_error         = 3
        user_canceled      = 4
        OTHERS             = 5.
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
      WHEN '&SF'.
        go_local->print_smartform( ).
    ENDCASE.
  ENDMETHOD.
  METHOD set_fcat.
    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name = 'ZGY_S_0027'
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
          i_parent = go_container.  " Parent Container
      CALL METHOD go_alv_grid->set_table_for_first_display
        EXPORTING
          is_layout       = gs_layout   " Layout
        CHANGING
          it_outtab       = gt_alv   " Output Table
          it_fieldcatalog = gt_fcat.   " Field Catalog
    ELSE.
      CALL METHOD go_alv_grid->refresh_table_display.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
