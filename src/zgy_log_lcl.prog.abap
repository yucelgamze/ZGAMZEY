*&---------------------------------------------------------------------*
*& Include          ZGAMZEY_STUDY2_LCL
*&---------------------------------------------------------------------*
CLASS lcl_class DEFINITION.
  PUBLIC SECTION.
    METHODS:
      get_data,
      template_xls_button,
      log_excel,
      call_screen,
      pbo_0100,
      pai_0100 IMPORTING iv_ucomm TYPE sy-ucomm,
      set_fcat,
      set_layout,
      display_alv.
ENDCLASS.
CLASS lcl_class IMPLEMENTATION.
  METHOD get_data.

    DATA:lo_alv TYPE REF TO cl_salv_table.

    CREATE DATA gt_dref TYPE TABLE OF (p_table).
    CREATE DATA gs_dref TYPE (p_table).

    ASSIGN gt_dref->* TO <dyn_table>.
    ASSIGN gs_dref->* TO <gfs_s_table>.

    CALL FUNCTION 'ALSM_EXCEL_TO_INTERNAL_TABLE'
      EXPORTING
        filename                = p_file
        i_begin_col             = 1
        i_begin_row             = 1
        i_end_col               = 99
        i_end_row               = 999999
      TABLES
        intern                  = gt_excel
      EXCEPTIONS
        inconsistent_parameters = 1
        upload_ole              = 2
        OTHERS                  = 3.
    IF sy-subrc EQ 0.

      SORT gt_excel BY row.

      LOOP AT gt_excel INTO DATA(ls_excel).
        "adding count to skip the mapping for Mandt field
        gv_col = ls_excel-col + 1.

        ASSIGN COMPONENT gv_col OF STRUCTURE <gfs_s_table> TO <gfs>.
        IF sy-subrc EQ 0.
          "excel kolonlarını dynamic tablo alanları ile kıyaslar
          IF ls_excel-row = 1.   ""BAŞLIK BİLGİSİ 1. SATIR OLMALI
            "DD: Interface for Reading Text on Tables or Types
            CALL FUNCTION 'DDIF_FIELDINFO_GET'
              EXPORTING
                tabname        = p_table
              TABLES
                dfies_tab      = gt_table_filds
*               FIXED_VALUES   =
              EXCEPTIONS
                not_found      = 1
                internal_error = 2
                OTHERS         = 3.

            READ TABLE gt_table_filds INTO DATA(ls_table_fields) INDEX gv_col.
            IF sy-subrc EQ 0.
              IF ls_table_fields-fieldname NE ls_excel-value.
                MESSAGE i000 DISPLAY LIKE 'W'.
                EXIT.
              ENDIF.
            ENDIF.
          ELSE.
            <gfs> = ls_excel-value.
          ENDIF.
        ENDIF.

        IF  ls_excel-row GT 1.
          AT END OF row.
            APPEND <gfs_s_table> TO <dyn_table>.
            CLEAR <gfs_s_table>.
          ENDAT.
        ENDIF.
      ENDLOOP.

      IF <dyn_table> IS NOT INITIAL.

        IF p_test IS INITIAL.


          MODIFY (p_table) FROM TABLE <dyn_table>.
          IF sy-subrc EQ 0.
            COMMIT WORK.
            DATA(lv_lines) = lines( <dyn_table> ).
            WRITE: TEXT-001, lv_lines.
          ELSE.
            ROLLBACK WORK.
            MESSAGE i001 DISPLAY LIKE 'E'.
          ENDIF.
        ELSE.
          cl_salv_table=>factory(
            IMPORTING
              r_salv_table   =  lo_alv   " Basis Class Simple ALV Tables
            CHANGING
              t_table        = <dyn_table> ).
*** --- Display
          lo_alv->display( ) .

        ENDIF.
      ENDIF.
    ENDIF.


    "sadece alv ye basıyor gt_list i doldurmuyor

*    DATA:lt_raw TYPE truxs_t_text_data.
*    CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
*      EXPORTING
*        i_line_header        = abap_true
*        i_tab_raw_data       = lt_raw
*        i_filename           = p_file
*      TABLES
*        i_tab_converted_data = gt_list
*      EXCEPTIONS
*        conversion_failed    = 1
*        OTHERS               = 2.
  ENDMETHOD.

  METHOD template_xls_button.

    gs_sel_button-icon_id   = icon_xls.
    gs_sel_button-icon_text = 'Template EXCEL'.
    gs_sel_button-quickinfo = 'Download Template EXCEL'.
    sscrfields-functxt_01   = gs_sel_button.

  ENDMETHOD.

  METHOD log_excel.
*    DATA:lt_log TYPE TABLE OF zgy_t_log,
*         ls_log TYPE zgy_t_log.
*
*    IF gt_list IS NOT INITIAL.
*      SELECT
*        dbt~matnr,
*        dbt~erdat,
*        dbt~ernam
*        FROM zgy_t_log AS dbt
*        FOR ALL ENTRIES IN @gt_list
**      INNER JOIN @gt_list as gt
**      on gt~matnr eq dbt~matnr
*        WHERE dbt~matnr EQ @gt_list-matnr
*        INTO TABLE @DATA(lt_kontrol).
*    ENDIF.
*
*
*    LOOP AT lt_kontrol ASSIGNING FIELD-SYMBOL(<lfs_s_kontrol>).
*      READ TABLE gt_list INTO gs_list WITH KEY matnr = <lfs_s_kontrol>-matnr.
*
*      IF sy-subrc EQ 0.
*        ls_log-matnr = gs_list-matnr.
*        ls_log-erdat = gs_list-erdat.
*        ls_log-ernam = gs_list-ernam.
*        ls_log-cname = sy-uname.
*        ls_log-cdate = sy-datum.
*        ls_log-ctime = sy-uzeit.
*        APPEND ls_log TO lt_log.
*      ENDIF.
*
*    ENDLOOP.
*
*    MODIFY zgy_t_log FROM TABLE @lt_log.

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

*    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
*      EXPORTING
**       i_structure_name = 'ZGY_T_LOG'
*        i_structure_name = 'ZGY_S_LOG'
*      CHANGING
*        ct_fieldcat      = gt_fcat.

*    CLEAR: gs_fcat.
*    gs_fcat-col_pos   = 1.
*    gs_fcat-fieldname = 'MATNR'.
*    gs_fcat-ref_field = 'MATNR'.
*    gs_fcat-ref_table = 'ZGY_T_LOG'.
*    gs_fcat-scrtext_l = 'MATNR'.
*    gs_fcat-scrtext_m = 'MATNR'.
*    gs_fcat-scrtext_s = 'MATNR'.
*    APPEND gs_fcat TO gt_fcat.
*
*    CLEAR: gs_fcat.
*    gs_fcat-col_pos   = 2.
*    gs_fcat-fieldname = 'ERDAT'.
*    gs_fcat-ref_field = 'ERDAT'.
*    gs_fcat-ref_table = 'ZGY_T_LOG'.
*    gs_fcat-scrtext_l = 'ERDAT'.
*    gs_fcat-scrtext_m = 'ERDAT'.
*    gs_fcat-scrtext_s = 'ERDAT'.
*    APPEND gs_fcat TO gt_fcat.
*
*    CLEAR: gs_fcat.
*    gs_fcat-col_pos   = 3.
*    gs_fcat-fieldname = 'ERNAM'.
*    gs_fcat-ref_field = 'ERNAM'.
*    gs_fcat-ref_table = 'ZGY_T_LOG'.
*    gs_fcat-scrtext_l = 'ERNAM'.
*    gs_fcat-scrtext_m = 'ERNAM'.
*    gs_fcat-scrtext_s = 'ERNAM'.
*    APPEND gs_fcat TO gt_fcat.
*
*    "dinamik tablo oluşturma
*    CALL METHOD cl_alv_table_create=>create_dynamic_table
*      EXPORTING
*        it_fieldcatalog = gt_fcat   " Field Catalog
*      IMPORTING
*        ep_table        = go_dynamic.   " Pointer to Dynamic Data Table
*
*    ASSIGN go_dynamic->* TO <dyn_table>.
*    CREATE DATA gs_dynamic LIKE LINE OF <dyn_table>.
*    ASSIGN gs_dynamic->* TO <gfs_s_table>.
***
*    LOOP AT gt_list ASSIGNING FIELD-SYMBOL(<lfs_list>).
*      APPEND INITIAL LINE TO <dyn_table> ASSIGNING <gfs_s_table>.
*      ASSIGN COMPONENT 'MATNR' OF STRUCTURE <gfs_s_table> TO <gfs>.
*      <gfs> = <lfs_list>-matnr.
*      ASSIGN COMPONENT 'ERDAT' OF STRUCTURE <gfs_s_table> TO <gfs>.
*      <gfs> = <lfs_list>-erdat.
*      ASSIGN COMPONENT 'ERNAM' OF STRUCTURE <gfs_s_table> TO <gfs>.
*      <gfs> = <lfs_list>-ernam.
*    ENDLOOP.

  ENDMETHOD.

  METHOD set_layout.
    gs_layout-zebra      = abap_true.
    gs_layout-cwidth_opt = abap_true.
    gs_layout-col_opt    = abap_true.
  ENDMETHOD.

  METHOD display_alv.

*        IF go_alv_grid IS INITIAL.
*          CREATE OBJECT go_container
*            EXPORTING
*              container_name = 'CC_ALV'.   " Name of the Screen CustCtrl Name to Link Container To
*          CREATE OBJECT go_alv_grid
*            EXPORTING
**             i_parent = cl_gui_container=>screen0.
*              i_parent = go_container.   " Parent Container
*          CALL METHOD go_alv_grid->set_table_for_first_display
*            EXPORTING
*              is_layout       = gs_layout   " Layout
*            CHANGING
*              it_outtab       = <dyn_table> " Output Table
*              it_fieldcatalog = gt_fcat.  " Field Catalog
*
*        ELSE.
*          CALL METHOD go_alv_grid->refresh_table_display.
*        ENDIF.
  ENDMETHOD.

ENDCLASS.
