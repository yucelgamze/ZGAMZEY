*&---------------------------------------------------------------------*
*& Include          ZGY_P_LCL
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
      print_smartform.
ENDCLASS.
CLASS lcl_class IMPLEMENTATION.
  METHOD get_data.

    SELECT
    vbak~vbeln,
    vbak~erdat,
    vbak~auart,
    vbap~posnr,
    vbap~matnr,
    vbap~arktx,
    vbap~kwmeng,
    vbap~vrkme,
    vbap~netwr,
    vbap~waerk
    FROM vbak
    LEFT JOIN vbap ON vbak~vbeln EQ vbap~vbeln
    INTO CORRESPONDING FIELDS OF TABLE @gt_alv.

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
        go_local->print_smartform( ).
    ENDCASE.
  ENDMETHOD.
  METHOD set_fcat.
    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name = 'ZGY_S_0025'
      CHANGING
        ct_fieldcat      = gt_fcat.
    CLEAR gs_fcat.
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
  METHOD print_smartform.

    DATA:lt_index_rows TYPE lvc_t_row.
    DATA:ls_data       TYPE zgy_s_0026.

    CALL METHOD go_alv_grid->get_selected_rows
      IMPORTING
        et_index_rows = lt_index_rows.   " Indexes of Selected Rows

    IF lt_index_rows IS INITIAL.
      MESSAGE i001 DISPLAY LIKE 'W'.
    ELSE.
      LOOP AT lt_index_rows INTO DATA(ls_index_row).
        READ TABLE gt_alv ASSIGNING FIELD-SYMBOL(<lfs_alv>) INDEX ls_index_row-index.
        IF sy-subrc IS INITIAL.
          DATA(lv_vbeln) = <lfs_alv>-vbeln.
        ENDIF.
      ENDLOOP.
    ENDIF.

    SELECT
    vbak~vbeln  AS siparis,
    vbap~posnr  AS kalem,
    vbap~arktx  AS urun_ack,
    vbap~matnr  AS urun_kod,
    vbap~kwmeng AS miktar,
    vbap~vrkme  AS satıs_obr,
    vbap~netwr  AS birim_fiyat,
    vbap~netwr  AS tutar,
    vbap~waerk  AS para_br
    FROM vbak
    LEFT JOIN vbap ON vbap~vbeln EQ vbak~vbeln
    WHERE vbak~vbeln EQ @lv_vbeln
    INTO CORRESPONDING FIELDS OF TABLE @gt_table.

    LOOP AT gt_table ASSIGNING FIELD-SYMBOL(<lfs_table>).
      <lfs_table>-no = sy-tabix.
    ENDLOOP.

    SELECT SINGLE vbeln, bukrs_vf, auart
    FROM vbak
    WHERE vbeln EQ @lv_vbeln
    INTO CORRESPONDING FIELDS OF @ls_data .

    IF sy-subrc IS INITIAL.

      IF ls_data-bukrs_vf EQ '1000'.
        ls_data-logo = 'ZGY_1000'.
      ELSEIF ls_data-bukrs_vf EQ 'ZV99'.
        ls_data-logo = 'ZGY_ZV99'.
      ELSE.
        ls_data-logo = 'VLOGO'.
      ENDIF.

      IF ls_data-auart EQ 'ZTAZ'.
        ls_data-baslik = 'X'.               "Proforma Fatura’
        ls_data-tarih  = 'X'.
        ls_data-no     = 'X'.
      ELSEIF ls_data-auart EQ 'ZSN1'.
        ls_data-baslik = ' '.                "Teklif Belgesi’
        ls_data-tarih  = ' '.
        ls_data-no     = ' '.
      ENDIF.

    ENDIF.

    gs_controls-no_dialog = abap_true.
    gs_controls-preview   = abap_true.
    gs_output_op-tddest   = 'LP01'.

    CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
      EXPORTING
        formname           = 'ZGY_SF_0002'
      IMPORTING
        fm_name            = gv_fm_name
      EXCEPTIONS
        no_form            = 1
        no_function_module = 2
        OTHERS             = 3.

*CALL FUNCTION '/1BCDWB/SF00000304'

    CALL FUNCTION gv_fm_name
      EXPORTING
        control_parameters = gs_controls
        output_options     = gs_output_op
        user_settings      = ' '
        is_data            = ls_data
        it_table           = gt_table
      EXCEPTIONS
        formatting_error   = 1
        internal_error     = 2
        send_error         = 3
        user_canceled      = 4
        OTHERS             = 5.

*--------------------------------------------------------------------*
    " table parametresi import edilmemiş versiyonu:

*    CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
*      EXPORTING
*        formname           = 'ZGY_SF_0001'
*      IMPORTING
*        fm_name            = gv_fm_name
*      EXCEPTIONS
*        no_form            = 1
*        no_function_module = 2
*        OTHERS             = 3.
*
**CALL FUNCTION '/1BCDWB/SF00000302'
*
*    CALL FUNCTION gv_fm_name
*      EXPORTING
*        control_parameters = gs_controls
*        output_options     = gs_output_op
*        user_settings      = ' '
*        is_data            = ls_data
*      EXCEPTIONS
*        formatting_error   = 1
*        internal_error     = 2
*        send_error         = 3
*        user_canceled      = 4
*        OTHERS             = 5.

  ENDMETHOD.
ENDCLASS.
