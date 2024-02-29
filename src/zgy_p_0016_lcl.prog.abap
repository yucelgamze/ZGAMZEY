*&---------------------------------------------------------------------*
*& Include          ZGY_P_0016_LCL
*&---------------------------------------------------------------------*
CLASS lcl_class DEFINITION.
  PUBLIC SECTION.
    METHODS:
      get_data,
      handle_hotspot_click                             "HOTSPOT_CLICK
            FOR EVENT hotspot_click OF cl_gui_alv_grid
        IMPORTING
            e_row_id
            e_column_id,
      print_adobe,
      print_smartform,
      print_etiket,
      call_screen,
      pbo_0100,
      pai_0100 IMPORTING iv_ucomm TYPE sy-ucomm,
      set_fcat,
      set_fcat2,
      set_layout,
      display_alv.
ENDCLASS.

CLASS lcl_class IMPLEMENTATION.
  METHOD get_data.
    SELECT
    vbak~vbeln AS vbeln      ,
    vbak~ernam AS ernam      ,
    vbak~erdat AS erdat      ,
    vbak~auart AS auart      ,
    vbak~vkorg AS vkorg      ,
    vbak~kunnr AS kunnr      ,
    kna1~name1 AS kunnr_name ,
    vbpa~kunnr AS kunwe      ,
    kna1~kunnr AS kunwe_name ,
    vbak~netwr AS netwr      ,
    vbak~waerk AS waerk
*    vbap~werks,
*    vbap~lgort
    FROM vbak
    INNER JOIN vbap ON vbak~vbeln EQ vbap~vbeln
    LEFT  JOIN vbpa ON vbak~vbeln EQ vbpa~vbeln AND vbpa~posnr = '000000' AND vbpa~parvw = 'WE'
    LEFT  JOIN kna1 ON kna1~kunnr EQ vbpa~kunnr
    WHERE vbak~vbeln IN @so_vbeln
    AND   vbak~ernam IN @so_ernam
    AND   vbak~auart IN @so_auart
    AND   vbak~kunnr IN @so_kunnr
    AND   vbap~werks IN @so_werks
    AND   vbap~lgort IN @so_lgort
    INTO CORRESPONDING FIELDS OF TABLE @gt_baslik.

    SORT gt_baslik BY vbeln.
    DELETE ADJACENT DUPLICATES FROM gt_baslik COMPARING vbeln.
  ENDMETHOD.

  METHOD handle_hotspot_click.

    REFRESH:gt_kalem.
    IF gt_baslik IS NOT INITIAL.

      READ TABLE gt_baslik INTO gs_baslik INDEX e_row_id-index.
      IF sy-subrc IS INITIAL.
        CASE e_column_id-fieldname.
          WHEN 'VBELN'.

            SELECT
            vbap~vbeln  AS vbeln,
            vbap~posnr  AS posnr,
            vbap~matnr  AS matnr,
            makt~maktx  AS maktx,
            vbap~werks  AS werks,
            t001w~name1 AS werks_name,
            vbap~lgort  AS lgort,
            t001l~lgobe AS lgobe,
            vbap~ntgew  AS ntgew,
            vbap~brgew  AS brgew,
*            ( vbap~brgew - vbap~ntgew ) AS fark,
            vbap~gewei  AS gewei,
            vbap~netwr  AS netwr,
            vbap~waerk  AS waerk
            FROM vbap
            LEFT JOIN makt  ON vbap~matnr  EQ makt~matnr AND makt~spras = @sy-langu
            LEFT JOIN t001w ON vbap~werks  EQ t001w~werks
            LEFT JOIN t001l ON t001w~werks EQ t001l~werks AND
                               vbap~lgort  EQ t001l~lgort
*            FOR ALL ENTRIES IN @gt_baslik                    "sadece hotspot satırına ihtiyaç var tüm entrylere gerek yok
            WHERE vbap~vbeln EQ @gs_baslik-vbeln               " o yüzden structure yeterli
            INTO CORRESPONDING FIELDS OF TABLE @gt_kalem.

            LOOP AT gt_kalem ASSIGNING FIELD-SYMBOL(<lfs_kalem>).
              <lfs_kalem>-fark = <lfs_kalem>-brgew - <lfs_kalem>-ntgew.
            ENDLOOP.

            SORT gt_kalem BY vbeln posnr.
            DELETE ADJACENT DUPLICATES FROM gt_kalem COMPARING vbeln posnr.

        ENDCASE.
      ENDIF.
    ENDIF.
    CALL METHOD go_alv_grid2->refresh_table_display( ).
  ENDMETHOD.

  METHOD print_adobe.

    CLEAR:gs_header,gs_items,fm_name.
    REFRESH:gt_items.

    DATA:lt_index_rows TYPE lvc_t_row.
    CALL METHOD go_alv_grid->get_selected_rows
      IMPORTING
        et_index_rows = lt_index_rows.

    IF lt_index_rows IS INITIAL.
      MESSAGE i000 DISPLAY LIKE 'E'.
    ELSE.

      LOOP AT lt_index_rows ASSIGNING FIELD-SYMBOL(<lfs_index_rows>).
        READ TABLE gt_baslik INTO gs_baslik INDEX <lfs_index_rows>-index.
        DATA(lv_vbeln) = gs_baslik-vbeln.
      ENDLOOP.
    ENDIF.

    SELECT SINGLE
    vbak~vbeln AS vbeln      ,
    vbak~ernam AS ernam      ,
    vbak~erdat AS erdat      ,
    vbak~auart AS auart      ,
    vbak~vkorg AS vkorg      ,
    vbak~kunnr AS kunnr      ,
    kna1~name1 AS kunnr_name ,
    vbpa~kunnr AS kunwe      ,
    kna1~kunnr AS kunwe_name ,
    vbak~netwr AS netwr      ,
    vbak~waerk AS waerk
    FROM vbak
    INNER JOIN vbap ON vbak~vbeln EQ vbap~vbeln
    LEFT  JOIN vbpa ON vbak~vbeln EQ vbpa~vbeln
    LEFT  JOIN kna1 ON kna1~kunnr EQ vbpa~kunnr
    WHERE vbak~vbeln EQ @lv_vbeln
    INTO @gs_header.

    IF sy-subrc IS INITIAL.
      SELECT
      vbap~vbeln  AS vbeln,
      vbap~posnr  AS posnr,
      vbap~matnr  AS matnr,
      makt~maktx  AS maktx,
      vbap~werks  AS werks,
      t001w~name1 AS werks_name,
      vbap~lgort  AS lgort,
      t001l~lgobe AS lgobe,
      vbap~ntgew  AS ntgew,
      vbap~brgew  AS brgew,
      ( vbap~brgew - vbap~ntgew ) AS fark,
      vbap~gewei  AS gewei,
      vbap~netwr  AS netwr,
      vbap~waerk  AS waerk
      FROM vbap
      LEFT JOIN makt  ON vbap~matnr  EQ makt~matnr AND makt~spras = @sy-langu
      LEFT JOIN t001w ON vbap~werks  EQ t001w~werks
      LEFT JOIN t001l ON t001w~werks EQ t001l~werks AND
                         vbap~lgort  EQ t001l~lgort
      WHERE vbap~vbeln EQ @gs_header-vbeln
      INTO CORRESPONDING FIELDS OF TABLE @gt_items.
    ENDIF.

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
        i_name     = 'ZGY_AF_0008'
      IMPORTING
        e_funcname = fm_name.

*CALL FUNCTION '/1BCDWB/SM00000605'
    CALL FUNCTION fm_name
      EXPORTING
        /1bcdwb/docparams = fp_docparams
        is_header         = gs_header
        it_items          = gt_items
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

  METHOD print_smartform.

    CLEAR:gs_header,gs_items.
    REFRESH:gt_items.

    DATA:lt_index_rows TYPE lvc_t_row.
    CALL METHOD go_alv_grid->get_selected_rows
      IMPORTING
        et_index_rows = lt_index_rows.
    IF lt_index_rows IS INITIAL.
      MESSAGE i001 DISPLAY LIKE 'E'.
    ELSE.
      LOOP AT lt_index_rows ASSIGNING FIELD-SYMBOL(<lfs_index_row>).
        READ TABLE gt_baslik INTO gs_baslik INDEX <lfs_index_row>-index.
        IF sy-subrc IS INITIAL.
          DATA(lv_vbeln) = gs_baslik-vbeln.
        ENDIF.
      ENDLOOP.
    ENDIF.

    SELECT SINGLE
    vbak~vbeln AS vbeln      ,
    vbak~ernam AS ernam      ,
    vbak~erdat AS erdat      ,
    vbak~auart AS auart      ,
    vbak~vkorg AS vkorg      ,
    vbak~kunnr AS kunnr      ,
    kna1~name1 AS kunnr_name ,
    vbpa~kunnr AS kunwe      ,
    kna1~kunnr AS kunwe_name ,
    vbak~netwr AS netwr      ,
    vbak~waerk AS waerk
    FROM vbak
    INNER JOIN vbap ON vbak~vbeln EQ vbap~vbeln
    LEFT  JOIN vbpa ON vbak~vbeln EQ vbpa~vbeln
    LEFT  JOIN kna1 ON kna1~kunnr EQ vbpa~kunnr
    WHERE vbak~vbeln EQ @lv_vbeln
    INTO @gs_header.

    IF sy-subrc IS INITIAL.
      SELECT
      vbap~vbeln  AS vbeln,
      vbap~posnr  AS posnr,
      vbap~matnr  AS matnr,
      makt~maktx  AS maktx,
      vbap~werks  AS werks,
      t001w~name1 AS werks_name,
      vbap~lgort  AS lgort,
      t001l~lgobe AS lgobe,
      vbap~ntgew  AS ntgew,
      vbap~brgew  AS brgew,
      ( vbap~brgew - vbap~ntgew ) AS fark,
      vbap~gewei  AS gewei,
      vbap~netwr  AS netwr,
      vbap~waerk  AS waerk
      FROM vbap
      LEFT JOIN makt  ON vbap~matnr  EQ makt~matnr AND makt~spras = @sy-langu
      LEFT JOIN t001w ON vbap~werks  EQ t001w~werks
      LEFT JOIN t001l ON t001w~werks EQ t001l~werks AND
                         vbap~lgort  EQ t001l~lgort
      WHERE vbap~vbeln EQ @gs_header-vbeln
      INTO CORRESPONDING FIELDS OF TABLE @gt_items.
    ENDIF.

    IF gt_items IS NOT INITIAL.
      LOOP AT gt_items ASSIGNING FIELD-SYMBOL(<lfs_item>).
        gs_items = CORRESPONDING #( <lfs_item> ).
      ENDLOOP.
    ENDIF.

    gs_controls-no_dialog = abap_true.
    gs_controls-preview   = abap_true.
    gs_output_op-tddest   = 'LP01'.

    CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
      EXPORTING
        formname           = 'ZGY_SF_0011'
      IMPORTING
        fm_name            = gv_fm_name
      EXCEPTIONS
        no_form            = 1
        no_function_module = 2
        OTHERS             = 3.

    CALL FUNCTION '/1BCDWB/SF00000325'
      EXPORTING
        control_parameters = gs_controls
        output_options     = gs_output_op
        user_settings      = ' '
        is_header          = gs_header
        it_items           = gt_items
        is_items           = gs_items
      EXCEPTIONS
        formatting_error   = 1
        internal_error     = 2
        send_error         = 3
        user_canceled      = 4
        OTHERS             = 5.

  ENDMETHOD.

  METHOD print_etiket.
    CLEAR:gs_header, fm_name.
    DATA:lt_index_rows TYPE lvc_t_row.
    CALL METHOD go_alv_grid->get_selected_rows
      IMPORTING
        et_index_rows = lt_index_rows.
    IF lt_index_rows IS INITIAL.
      MESSAGE i011 DISPLAY LIKE 'E'.
    ELSE.
      LOOP AT lt_index_rows ASSIGNING FIELD-SYMBOL(<lfs_index_rows>).
        READ TABLE gt_baslik INTO gs_baslik INDEX <lfs_index_rows>-index.
        IF sy-subrc IS INITIAL.
          DATA(lv_vbeln) = gs_baslik-vbeln.
        ENDIF.
      ENDLOOP.
    ENDIF.

    SELECT SINGLE
    vbak~vbeln AS vbeln      ,
    vbak~ernam AS ernam      ,
    vbak~erdat AS erdat      ,
    vbak~auart AS auart      ,
    vbak~vkorg AS vkorg      ,
    vbak~kunnr AS kunnr      ,
    kna1~name1 AS kunnr_name ,
    vbpa~kunnr AS kunwe      ,
    kna1~kunnr AS kunwe_name ,
    vbak~netwr AS netwr      ,
    vbak~waerk AS waerk
    FROM vbak
    INNER JOIN vbap ON vbak~vbeln EQ vbap~vbeln
    LEFT  JOIN vbpa ON vbak~vbeln EQ vbpa~vbeln
    LEFT  JOIN kna1 ON kna1~kunnr EQ vbpa~kunnr
    WHERE vbak~vbeln EQ @lv_vbeln
    INTO @gs_header.

    IF sy-subrc IS INITIAL.
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
          i_name     = 'ZGY_AF_0009'
        IMPORTING
          e_funcname = fm_name.

*      CALL FUNCTION '/1BCDWB/SM00000606'
      CALL FUNCTION fm_name
        EXPORTING
          /1bcdwb/docparams = fp_docparams
          is_header         = gs_header
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

    ENDIF.

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
      WHEN '&REFRESH'.
        REFRESH:gt_baslik,gt_kalem.
        go_local->get_data( ).
        CALL METHOD go_alv_grid->refresh_table_display( ).
      WHEN '&ADOBEFORM'.
        go_local->print_adobe( ).
      WHEN '&SMARTFORM'.
        go_local->print_smartform( ).
      WHEN '&ETIKET'.
        go_local->print_etiket( ).
    ENDCASE.
  ENDMETHOD.

  METHOD set_fcat.
    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name = 'ZGY_S_0032'
      CHANGING
        ct_fieldcat      = gt_fcat.

    LOOP AT gt_fcat ASSIGNING FIELD-SYMBOL(<lfs_fcat>).
      CASE <lfs_fcat>-fieldname.
        WHEN 'VBELN'.
          <lfs_fcat>-hotspot = abap_true.
      ENDCASE.
    ENDLOOP.
  ENDMETHOD.

  METHOD set_fcat2.
    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name = 'ZGY_S_0033'
      CHANGING
        ct_fieldcat      = gt_fcat2.
  ENDMETHOD.

  METHOD set_layout.
    gs_layout = VALUE #( zebra      = abap_true
                         cwidth_opt = abap_true
                         col_opt    = abap_true
                         sel_mode   = 'A').
  ENDMETHOD.

  METHOD display_alv.
    IF go_alv_grid IS INITIAL AND go_alv_grid2 IS INITIAL.

      CREATE OBJECT go_container
        EXPORTING
          container_name = 'CC_ALV'.    " Name of the Screen CustCtrl Name to Link Container To

      CREATE OBJECT go_splitter
        EXPORTING
          parent  = go_container    " Parent Container
          rows    = 2   " Number of Rows to be displayed
          columns = 1.   " Number of Columns to be Displayed

      CALL METHOD go_splitter->get_container
        EXPORTING
          row       = 1   " Row
          column    = 1    " Column
        RECEIVING
          container = go_split1.    " Container

      CALL METHOD go_splitter->get_container
        EXPORTING
          row       = 2   " Row
          column    = 1   " Column
        RECEIVING
          container = go_split2.    " Container

      CREATE OBJECT go_alv_grid
        EXPORTING
          i_parent = go_split1.  " Parent Container

      SET HANDLER go_local->handle_hotspot_click FOR go_alv_grid.

      CALL METHOD go_alv_grid->register_edit_event
        EXPORTING
          i_event_id = cl_gui_alv_grid=>mc_evt_modified.

      CALL METHOD go_alv_grid->set_table_for_first_display
        EXPORTING
          is_layout       = gs_layout   " Layout
        CHANGING
          it_outtab       = gt_baslik    " Output Table
          it_fieldcatalog = gt_fcat.    " Field Catalog

      CREATE OBJECT go_alv_grid2
        EXPORTING
          i_parent = go_split2.   " Parent Container
      CALL METHOD go_alv_grid2->set_table_for_first_display
        EXPORTING
          is_layout       = gs_layout    " Layout
        CHANGING
          it_outtab       = gt_kalem   " Output Table
          it_fieldcatalog = gt_fcat2.    " Field Catalog

    ELSE.
      CALL METHOD go_alv_grid->refresh_table_display( ).
      CALL METHOD go_alv_grid2->refresh_table_display( ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
