*&---------------------------------------------------------------------*
*& Include          ZGY_DYNAMIC_LCL
*&---------------------------------------------------------------------*
CLASS lcl_class DEFINITION.
  PUBLIC SECTION.
    METHODS:
      get_data,
      get_data2,
      get_data_process,
      print_adobe,
      template_xls_button,
      upload_xls,
      call_screen,
      pbo_0100,
      pai_0100 IMPORTING iv_ucomm TYPE sy-ucomm,
      set_fcat,
      set_fcat2,
      set_fcat_del,
      set_fcat_add,
      set_layout,
      display_alv,
      handle_button_click_del
                    FOR EVENT button_click OF cl_gui_alv_grid
        IMPORTING es_col_id
                    es_row_no,
      handle_button_click_add
                    FOR EVENT button_click OF cl_gui_alv_grid
        IMPORTING es_col_id
                    es_row_no.
ENDCLASS.
CLASS lcl_class IMPLEMENTATION.
  METHOD get_data.
    SELECT
      ililce~il_kodu,
      il~il_tanim,
      ilce~ilce_tanim
      FROM zgy_t_il AS il
      LEFT JOIN zgy_t_ililce AS ililce
      ON il~il_kodu EQ ililce~il_kodu
      LEFT JOIN zgy_t_ilce AS ilce
      ON ilce~ilce_kodu EQ ililce~ilce_kodu
      INTO CORRESPONDING FIELDS OF TABLE @gt_alv.
  ENDMETHOD.
  METHOD get_data2.
    SELECT
    ebeln,
    bukrs,
    bstyp,
    bsart,
    statu,
    aedat,
    ernam
    FROM ekko
    WHERE ebeln IN @so_ebeln
    INTO CORRESPONDING FIELDS OF TABLE @gt_al.
  ENDMETHOD.

  METHOD get_data_process.

    SELECT
    vbeln,
    ernam,
    audat,
    zprocess
    FROM zgy_t_satis AS del
    WHERE del~zprocess EQ 'DEL'
    INTO CORRESPONDING FIELDS OF TABLE @gt_del.

    LOOP AT gt_del ASSIGNING FIELD-SYMBOL(<lfs_s_del>).
      <lfs_s_del>-zprocess = '@11@'.
    ENDLOOP.

    SELECT
    vbeln,
    ernam,
    audat,
    zprocess
    FROM zgy_t_satis AS add
    WHERE add~zprocess EQ 'ADD'
    INTO CORRESPONDING FIELDS OF TABLE @gt_add.

    LOOP AT gt_add ASSIGNING FIELD-SYMBOL(<lfs_s_add>).
      <lfs_s_add>-zprocess = '@CL@'.
    ENDLOOP.

  ENDMETHOD.

  METHOD print_adobe.

    DATA:lt_index_rows TYPE lvc_t_row.

    CALL METHOD go_alv_grid2->get_selected_rows
      IMPORTING
        et_index_rows = lt_index_rows. " Indexes of Selected Rows

    IF lt_index_rows IS INITIAL.
      MESSAGE i000 DISPLAY LIKE 'W'.
    ELSE.
      LOOP AT lt_index_rows INTO DATA(ls_index_rows).
        READ TABLE gt_al INTO gs_al INDEX ls_index_rows-index.
        IF sy-subrc EQ 0.
          DATA(lv_ebeln) = gs_al-ebeln.
        ENDIF.
      ENDLOOP.
    ENDIF.

    SELECT SINGLE
    ebeln,
    bukrs,
    bstyp,
    bsart,
    statu,
    aedat,
    ernam
    FROM ekko
    WHERE ekko~ebeln EQ @lv_ebeln
    INTO @gs_header.

    IF sy-subrc EQ 0.
      SELECT
      ebeln,
      ebelp,
      statu,
      aedat,
      bukrs,
      werks,
      lgort
      FROM ekpo
      WHERE ekpo~ebeln EQ @gs_header-ebeln
      INTO TABLE @gt_items.
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
        i_name     = 'ZGY_AF_0004'
      IMPORTING
        e_funcname = fm_name.

    CALL FUNCTION fm_name
*    CALL FUNCTION '/1BCDWB/SM00000458'
      EXPORTING
        /1bcdwb/docparams = fp_docparams
        is_header         = gs_header
        it_items          = gt_items
*     IMPORTING
*       /1BCDWB/FORMOUTPUT       =
      EXCEPTIONS
        usage_error       = 1
        system_error      = 2
        internal_error    = 3
        OTHERS            = 4.

    CALL FUNCTION 'FP_JOB_CLOSE'
* IMPORTING
*   E_RESULT             =
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

    "dinamik ilce_tanim kolonunun pozisyonu il_kodu ve İl_tanım ilk 2
    "kolon olduğu için 3. kolondan başlatıp koop içinde artıracağız.
    DATA:lv_count     TYPE int4 VALUE 3,
         lv_sayac     TYPE int4 VALUE 1,
         lv_fieldname TYPE string.

    CLEAR: gs_fcat.
    gs_fcat-col_pos   = 1.
    gs_fcat-fieldname = 'IL_KODU'.
    gs_fcat-ref_field = 'IL_KODU'.
    gs_fcat-ref_table = 'ZGY_T_IL'.
    gs_fcat-scrtext_l = 'IL_KODU'.
    gs_fcat-scrtext_m = 'IL_KODU'.
    gs_fcat-scrtext_s = 'IL_KODU'.
    APPEND gs_fcat TO gt_fcat.

    CLEAR: gs_fcat.
    gs_fcat-col_pos   = 2.
    gs_fcat-fieldname = 'IL_TANIM'.
    gs_fcat-ref_field = 'IL_TANIM'.
    gs_fcat-ref_table = 'ZGY_T_IL'.
    gs_fcat-scrtext_l = 'IL_TANIM'.
    gs_fcat-scrtext_m = 'IL_TANIM'.
    gs_fcat-scrtext_s = 'IL_TANIM'.
    APPEND gs_fcat TO gt_fcat.

    "birinci yöntem****************************************************************************
    gt_ilcetanim = gt_alv.
    SORT gt_ilcetanim BY ilce_tanim.
    DELETE ADJACENT DUPLICATES FROM gt_ilcetanim COMPARING il_kodu.

*    LOOP AT gt_ilcetanim INTO DATA(ls_ilcetanim).
*      CLEAR:gs_fcat.
*      gs_fcat-col_pos   = lv_count.
*      gs_fcat-fieldname = |ILCE_TANIM| && lv_sayac.
*      gs_fcat-scrtext_l = |ILCE_TANIM| && lv_sayac.
*      gs_fcat-scrtext_m = |ILCE_TANIM| && lv_sayac.
*      gs_fcat-scrtext_s = |ILCE_TANIM| && lv_sayac.
*      APPEND gs_fcat TO gt_fcat.
*      lv_count = lv_count + 1.
*      lv_sayac = lv_sayac + 1.
*    ENDLOOP.

    "ikinci yöntem*****************************************************************************
    DATA(lv_ilce) = 1.
    SELECT
      il_kodu,
      COUNT(*) AS ilce
*      MAX( il_kodu ) AS max
      FROM zgy_t_ililce
      INTO TABLE @DATA(lt_ilce)
      GROUP BY il_kodu.

    SORT lt_ilce ASCENDING BY ilce.
    LOOP AT lt_ilce INTO DATA(ls_ilce).
      lv_ilce = ls_ilce-ilce.
    ENDLOOP.

    DO lv_ilce TIMES.

      CLEAR:gs_fcat.
      gs_fcat-col_pos   = lv_count.
      gs_fcat-datatype  = 'ZILCE_KODU'.
      gs_fcat-fieldname = |ILCE_TANIM| && lv_sayac.
      gs_fcat-scrtext_l = |ILCE_TANIM| && lv_sayac.
      gs_fcat-scrtext_m = |ILCE_TANIM| && lv_sayac.
      gs_fcat-scrtext_s = |ILCE_TANIM| && lv_sayac.
      APPEND gs_fcat TO gt_fcat.
      lv_sayac = lv_sayac + 1.
      lv_count = lv_count + 1.
    ENDDO.
*****************************************************************************************************************
    "dinamik tablo oluşturma
    CALL METHOD cl_alv_table_create=>create_dynamic_table
      EXPORTING
        it_fieldcatalog = gt_fcat   " Field Catalog
      IMPORTING
        ep_table        = go_dynamic.   " Pointer to Dynamic Data Table

    ASSIGN go_dynamic->* TO <dyn_table>.
    CREATE DATA gs_dynamic LIKE LINE OF <dyn_table>.
    ASSIGN gs_dynamic->* TO <gfs_s_table>.
**************************************************************************************************************************
    DATA(lv_sira) = 1.
    "en dıştaki loopta il_kodu uniqe olarak tutuluyor
    LOOP AT gt_alv ASSIGNING FIELD-SYMBOL(<lfs_group>) GROUP BY <lfs_group>-il_kodu.

      APPEND INITIAL LINE TO <dyn_table> ASSIGNING <gfs_s_table>.
      IF <gfs_s_table> IS ASSIGNED.

        ASSIGN COMPONENT 'IL_KODU' OF STRUCTURE <gfs_s_table> TO <gfs>.
        IF <gfs> IS ASSIGNED.
          <gfs> = <lfs_group>-il_kodu.
        ENDIF.
        ASSIGN COMPONENT 'IL_TANIM' OF STRUCTURE <gfs_s_table> TO <gfs>.
        IF <gfs> IS ASSIGNED.
          <gfs> = <lfs_group>-il_tanim.
        ENDIF.
      ENDIF.

      lv_sira = 1.

      LOOP AT GROUP <lfs_group> ASSIGNING FIELD-SYMBOL(<lfs_s_group>).

        lv_fieldname = |ILCE_TANIM| && lv_sira.
        ASSIGN COMPONENT lv_fieldname OF STRUCTURE <gfs_s_table> TO <gfs>.
        IF <gfs> IS ASSIGNED.
          <gfs> = <lfs_s_group>-ilce_tanim.
        ENDIF.
        lv_sira = lv_sira + 1.
      ENDLOOP.

*      APPEND  <gfs_s_table> to <dyn_table>.
*      CLEAR <gfs_s_table>.

    ENDLOOP.
  ENDMETHOD.

  METHOD set_fcat2.
    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name = 'ZGY_S_SATINALMA'
      CHANGING
        ct_fieldcat      = gt_fcat2.

  ENDMETHOD.

  METHOD set_fcat_del.

    CLEAR:gs_fcat_del.
    gs_fcat_del-ref_table = 'ZGY_T_SATIS'.
    gs_fcat_del-fieldname = 'VBELN'.
    gs_fcat_del-scrtext_l = 'Satış Belgesi'.
    gs_fcat_del-scrtext_m = 'Satış Belgesi'.
    gs_fcat_del-scrtext_s = 'Satış Belgesi'.
    APPEND gs_fcat_del TO gt_fcat_del.

    CLEAR:gs_fcat_del.
    gs_fcat_del-ref_table = 'ZGY_T_SATIS'.
    gs_fcat_del-fieldname = 'ERNAM'.
    gs_fcat_del-scrtext_l = 'Oluşturan'.
    gs_fcat_del-scrtext_m = 'Oluşturan'.
    gs_fcat_del-scrtext_s = 'Oluşturan'.
    APPEND gs_fcat_del TO gt_fcat_del.

    CLEAR:gs_fcat_del.
    gs_fcat_del-ref_table = 'ZGY_T_SATIS'.
    gs_fcat_del-fieldname = 'AUDAT'.
    gs_fcat_del-scrtext_l = 'Belge Tarihi'.
    gs_fcat_del-scrtext_m = 'Belge Tarihi'.
    gs_fcat_del-scrtext_s = 'Belge Tarihi'.
    APPEND gs_fcat_del TO gt_fcat_del.

    CLEAR:gs_fcat_del.
    gs_fcat_del-ref_table = 'ZGY_T_SATIS'.
    gs_fcat_del-fieldname = 'ZPROCESS'.
    gs_fcat_del-scrtext_l = 'Delete'.
    gs_fcat_del-scrtext_m = 'Delete'.
    gs_fcat_del-scrtext_s = 'Delete'.
    gs_fcat_del-style     = cl_gui_alv_grid=>mc_style_button.
    gs_fcat_del-icon      = abap_true.
    APPEND gs_fcat_del TO gt_fcat_del.

  ENDMETHOD.
  METHOD set_fcat_add.

    CLEAR:gs_fcat_add.
    gs_fcat_add-ref_table = 'ZGY_T_SATIS'.
    gs_fcat_add-fieldname = 'VBELN'.
    gs_fcat_add-scrtext_l = 'Satış Belgesi'.
    gs_fcat_add-scrtext_m = 'Satış Belgesi'.
    gs_fcat_add-scrtext_s = 'Satış Belgesi'.
    APPEND gs_fcat_add TO gt_fcat_add.

    CLEAR:gs_fcat_del.
    gs_fcat_add-ref_table = 'ZGY_T_SATIS'.
    gs_fcat_add-fieldname = 'ERNAM'.
    gs_fcat_add-scrtext_l = 'Oluşturan'.
    gs_fcat_add-scrtext_m = 'Oluşturan'.
    gs_fcat_add-scrtext_s = 'Oluşturan'.
    APPEND gs_fcat_add TO gt_fcat_add.

    CLEAR:gs_fcat_del.
    gs_fcat_add-ref_table = 'ZGY_T_SATIS'.
    gs_fcat_add-fieldname = 'AUDAT'.
    gs_fcat_add-scrtext_l = 'Belge Tarihi'.
    gs_fcat_add-scrtext_m = 'Belge Tarihi'.
    gs_fcat_add-scrtext_s = 'Belge Tarihi'.
    APPEND gs_fcat_add TO gt_fcat_add.

    CLEAR:gs_fcat_del.
    gs_fcat_add-ref_table = 'ZGY_T_SATIS'.
    gs_fcat_add-fieldname = 'ZPROCESS'.
    gs_fcat_add-scrtext_l = 'Add'.
    gs_fcat_add-scrtext_m = 'Add'.
    gs_fcat_add-scrtext_s = 'Add'.
    gs_fcat_add-style     = cl_gui_alv_grid=>mc_style_button.
    gs_fcat_add-icon      = abap_true.
    APPEND gs_fcat_add TO gt_fcat_add.
  ENDMETHOD.

  METHOD handle_button_click_del.

    READ TABLE gt_del INTO DATA(ls_del) INDEX es_row_no-row_id.
    DATA:ls_satis TYPE zgy_t_satis.
    ls_satis-vbeln    = ls_del-vbeln.
    ls_satis-ernam    = ls_del-ernam.
    ls_satis-audat    = ls_del-audat.
    ls_satis-zprocess = 'ADD'.

    UPDATE zgy_t_satis FROM ls_satis.

    IF sy-subrc EQ 0.
      go_local->get_data_process( ).
      CALL METHOD go_alv_grid_del->refresh_table_display.
      CALL METHOD go_alv_grid_add->refresh_table_display.
      CLEAR:ls_del,ls_satis.
    ENDIF.

  ENDMETHOD.

  METHOD handle_button_click_add.

    READ TABLE gt_add INTO DATA(ls_add) INDEX es_row_no-row_id.
    DATA:ls_satis TYPE zgy_t_satis.
    ls_satis-vbeln    = ls_add-vbeln.
    ls_satis-ernam    = ls_add-ernam.
    ls_satis-audat    = ls_add-audat.
    ls_satis-zprocess = 'DEL'.

    UPDATE zgy_t_satis FROM ls_satis.

    IF sy-subrc EQ 0.
      go_local->get_data_process( ).
      CALL METHOD go_alv_grid_del->refresh_table_display.
      CALL METHOD go_alv_grid_add->refresh_table_display.
      CLEAR:ls_add,ls_satis.
    ENDIF.

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
          it_outtab       = <dyn_table> " Output Table
          it_fieldcatalog = gt_fcat.  " Field Catalog

    ELSE.
      CALL METHOD go_alv_grid->refresh_table_display.
    ENDIF.

    IF go_alv_grid2 IS INITIAL.
      CREATE OBJECT go_container2
        EXPORTING
          container_name = 'CC_ALV_SATINALMA'.   " Name of the Screen CustCtrl Name to Link Container To
      CREATE OBJECT go_alv_grid2
        EXPORTING
*         i_parent = cl_gui_container=>screen0.
          i_parent = go_container2.   " Parent Container
      CALL METHOD go_alv_grid2->set_table_for_first_display
        EXPORTING
          is_layout       = gs_layout   " Layout
        CHANGING
          it_outtab       = gt_al " Output Table
          it_fieldcatalog = gt_fcat2.  " Field Catalog

    ELSE.
      CALL METHOD go_alv_grid2->refresh_table_display.
    ENDIF.

    IF go_alv_grid3 IS INITIAL.
      CREATE OBJECT go_container3
        EXPORTING
          container_name = 'CC_ALV_UPLOAD'.   " Name of the Screen CustCtrl Name to Link Container To
      CREATE OBJECT go_alv_grid3
        EXPORTING
*         i_parent = cl_gui_container=>screen0.
          i_parent = go_container3.   " Parent Container
      CALL METHOD go_alv_grid3->set_table_for_first_display
        EXPORTING
          is_layout       = gs_layout   " Layout
        CHANGING
          it_outtab       = gt_list " Output Table
          it_fieldcatalog = gt_fcat2.  " Field Catalog

    ELSE.
      CALL METHOD go_alv_grid3->refresh_table_display.
    ENDIF.

    IF go_alv_grid_del IS INITIAL AND go_alv_grid_add IS INITIAL.
      CREATE OBJECT go_container_del
        EXPORTING
          container_name = 'CC_ALV_DEL'. " Name of the Screen CustCtrl Name to Link Container To
      CREATE OBJECT go_alv_grid_del
        EXPORTING
          i_parent = go_container_del.  " Parent Container
      SET HANDLER go_local->handle_button_click_del FOR go_alv_grid_del.
      CALL METHOD go_alv_grid_del->set_table_for_first_display
        EXPORTING
          is_layout       = gs_layout   " Layout
        CHANGING
          it_outtab       = gt_del   " Output Table
          it_fieldcatalog = gt_fcat_del.  " Field Catalog

      CREATE OBJECT go_container_add
        EXPORTING
          container_name = 'CC_ALV_ADD'. " Name of the Screen CustCtrl Name to Link Container To
      CREATE OBJECT go_alv_grid_add
        EXPORTING
          i_parent = go_container_add.   " Parent Container
      SET HANDLER go_local->handle_button_click_add FOR go_alv_grid_add.
      CALL METHOD go_alv_grid_add->set_table_for_first_display
        EXPORTING
          is_layout       = gs_layout   " Layout
        CHANGING
          it_outtab       = gt_add   " Output Table
          it_fieldcatalog = gt_fcat_add.   " Field Catalog

    ELSE.
      CALL METHOD go_alv_grid_del->refresh_table_display.
      CALL METHOD go_alv_grid_add->refresh_table_display.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
