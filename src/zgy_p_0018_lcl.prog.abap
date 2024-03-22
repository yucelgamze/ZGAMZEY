*&---------------------------------------------------------------------*
*& Include          ZGY_P_0018_LCL
*&---------------------------------------------------------------------*
CLASS lcl_class DEFINITION.
  PUBLIC SECTION.
    METHODS:
      get_data,
      print_adobe,
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
    mara~matnr,
    makt~maktx,
    mara~mtart,
    mara~matkl,
    mara~brgew,
    mara~ntgew,
    mara~gewei
    FROM mara
    LEFT JOIN makt ON mara~matnr = makt~matnr
    WHERE mara~matnr IN @so_matnr
    AND   makt~spras = 'T'
    INTO CORRESPONDING FIELDS OF TABLE @gt_alv.

    SORT gt_alv BY matnr.
    DELETE ADJACENT DUPLICATES FROM gt_alv COMPARING matnr.

  ENDMETHOD.

  METHOD print_adobe.
    CLEAR:gs_data,fm_name.

    DATA:lt_index_rows TYPE lvc_t_row.
    CALL METHOD go_alv_grid->get_selected_rows
      IMPORTING
        et_index_rows = lt_index_rows.
    IF lt_index_rows IS INITIAL.
      MESSAGE i000 DISPLAY LIKE 'E'.

    ELSE.
      LOOP AT lt_index_rows ASSIGNING FIELD-SYMBOL(<lfs_index_row>).
        READ TABLE gt_alv INTO gs_alv INDEX <lfs_index_row>-index.
        IF sy-subrc IS INITIAL.
          DATA(lv_matnr) = gs_alv-matnr.
        ENDIF.
      ENDLOOP.
    ENDIF.

    SELECT SINGLE
    mara~matnr,
    makt~maktx,
    mara~mtart,
    mara~matkl,
    mara~brgew,
    mara~ntgew,
    mara~gewei
    FROM mara
    LEFT JOIN makt ON mara~matnr = makt~matnr
    WHERE mara~matnr = @lv_matnr
    INTO CORRESPONDING FIELDS OF @gs_data.

    fp_outputparams-device   = 'PRINTER'.
    fp_outputparams-nodialog = abap_true.
    fp_outputparams-preview  = abap_true.
    fp_outputparams-dest     = 'LP01'.

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
        i_name     = 'ZGY_AF_0010'
      IMPORTING
        e_funcname = fm_name.

*    CALL FUNCTION '/1BCDWB/SM00000616'
    CALL FUNCTION fm_name
      EXPORTING
        /1bcdwb/docparams = fp_docparams
        is_data           = gs_data
      EXCEPTIONS
        usage_error       = 1
        system_error      = 2
        internal_error    = 3
        OTHERS            = 4.

    CALL FUNCTION 'FP_JOB_CLOSE'
      EXCEPTIONS
        usage_error    = 1
        system_error   = 2
        internal_error = 3
        OTHERS         = 4.

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
      WHEN '&ADOBE'.
        go_local->print_adobe( ).
    ENDCASE.
  ENDMETHOD.

  METHOD set_fcat.
    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name = 'ZGY_S_0034'
      CHANGING
        ct_fieldcat      = gt_fcat.
  ENDMETHOD.

  METHOD set_layout.
    gs_layout = VALUE #( col_opt    = abap_true
                         cwidth_opt = abap_true
                         zebra      = abap_true
                         sel_mode   = 'A'
                        ).
  ENDMETHOD.

  METHOD display_alv.
    IF go_alv_grid IS INITIAL.
      CREATE OBJECT go_container
        EXPORTING
          container_name = 'CC_ALV'.
      CREATE OBJECT go_alv_grid
        EXPORTING
*         i_parent = cl_gui_container=>screen0.
          i_parent = go_container.

      CALL METHOD go_alv_grid->set_table_for_first_display
        EXPORTING
          is_layout       = gs_layout
        CHANGING
          it_outtab       = gt_alv
          it_fieldcatalog = gt_fcat.
    ELSE.
      CALL METHOD go_alv_grid->refresh_table_display( ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
