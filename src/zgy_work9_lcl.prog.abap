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
      get_sum,
      make_non_editable,
      dropdown,

      handle_top_of_page                            "TOP_OF_PAGE
            FOR EVENT top_of_page OF cl_gui_alv_grid
        IMPORTING
            e_dyndoc_id
            table_index,

      handle_hotspot_click                          "HOTSPOT_CLICK
            FOR EVENT hotspot_click OF cl_gui_alv_grid
        IMPORTING
            e_row_id
            e_column_id,

      handle_double_click
            FOR EVENT double_click OF cl_gui_alv_grid   "DOUBLE_CLICK
        IMPORTING
            e_row
            e_column
            es_row_no,

      handle_data_changed
            FOR EVENT data_changed OF cl_gui_alv_grid   "DATA_CHANGED
        IMPORTING
            er_data_changed
            e_onf4
            e_onf4_before
            e_onf4_after
            e_ucomm,

      handle_onf4
            FOR EVENT onf4 OF cl_gui_alv_grid            "ONF4
        IMPORTING
            e_fieldname
            e_fieldvalue
            es_row_no
            er_event_data
            et_bad_cells
            e_display,

      handle_button_click
            FOR EVENT button_click OF cl_gui_alv_grid   "BUTTON_CLICK
        IMPORTING
            es_col_id
            es_row_no,

      handle_toolbar
            FOR EVENT toolbar OF cl_gui_alv_grid              "TOOLBAR
        IMPORTING
            e_object
            e_interactive,

      handle_user_command                                 "USER_COMMAND
            FOR EVENT user_command OF cl_gui_alv_grid
        IMPORTING
            e_ucomm.

ENDCLASS.

CLASS lcl_class IMPLEMENTATION.
  METHOD get_data.
    SELECT
      db_t~carrid,
      db_t~carrname,
      db_t~currcode,
      db_t~url,
      '@0A@' AS durum

      FROM scarr AS db_t
      INTO  CORRESPONDING FIELDS OF TABLE @gt_alv.


    LOOP AT gt_alv ASSIGNING <gfs_alv>.
      <gfs_alv>-delete = '@11@'.
    ENDLOOP.

    DATA:lv_tabix     TYPE int4,
         lv_numc      TYPE n LENGTH 8,
         lv_numc_c    TYPE char8,
         ls_cellstyle TYPE lvc_s_styl.


    LOOP AT gt_alv ASSIGNING <gfs_alv>.
      lv_numc = lv_numc + 1.
      lv_numc_c = lv_numc.

      CLEAR:ls_cellstyle.
      ls_cellstyle-style     = lv_numc_c.
      ls_cellstyle-fieldname = 'URL'.
      APPEND ls_cellstyle TO <gfs_alv>-cellstyle.

      <gfs_alv>-styleval = lv_numc_c.
    ENDLOOP.


*    LOOP AT gt_alv ASSIGNING <gfs_alv>.
*      lv_tabix = lv_tabix + 1.
*      CASE lv_tabix.
*        WHEN 1.
*          CLEAR:ls_cellstyle.
*          ls_cellstyle-style     = '00000000'.
*          ls_cellstyle-fieldname = 'URL'.
*          APPEND ls_cellstyle TO <gfs_alv>-cellstyle.
*        WHEN 2.
*          CLEAR:ls_cellstyle.
*          ls_cellstyle-style     = '00000001'.
*          ls_cellstyle-fieldname = 'URL'.
*          APPEND ls_cellstyle TO <gfs_alv>-cellstyle.
*        WHEN 3.
*          CLEAR:ls_cellstyle.
*          ls_cellstyle-style     = '00000002'.
*          ls_cellstyle-fieldname = 'URL'.
*          APPEND ls_cellstyle TO <gfs_alv>-cellstyle.
*      ENDCASE.
*    ENDLOOP.

*    "CELL STYLE
*    DATA:ls_cellstyle TYPE lvc_s_styl.
*
*    LOOP AT gt_alv ASSIGNING <gfs_alv>.
*      IF <gfs_alv>-currcode <> 'EUR'.
*        CLEAR:ls_cellstyle.
*        ls_cellstyle-style     = cl_gui_alv_grid=>mc_style_disabled.
*        ls_cellstyle-fieldname = 'URL'.
*
*        APPEND ls_cellstyle TO <gfs_alv>-cellstyle.
*      ENDIF.
*    ENDLOOP.



    "CELL STYLE başka  versiyonu
*    DATA:ls_cellstyle TYPE lvc_s_styl,
*         lt_cellstyle TYPE lvc_t_styl.
*
*    LOOP AT gt_alv ASSIGNING <gfs_alv>.
*      IF <gfs_alv>-currcode <> 'EUR' .
*        ls_cellstyle-style     = cl_gui_alv_grid=>mc_style_disabled.
*        ls_cellstyle-fieldname = 'URL'.
*
*        INSERT ls_cellstyle INTO TABLE lt_cellstyle.
*
*        CLEAR:<gfs_alv>-cellstyle.
*        INSERT LINES OF lt_cellstyle INTO TABLE <gfs_alv>-cellstyle.
*      ENDIF.
*    ENDLOOP.


    "DYNAMIC DROPDOWN CELL
    LOOP AT gt_alv ASSIGNING <gfs_alv>.
      CASE <gfs_alv>-currcode.
        WHEN 'EUR'.
          <gfs_alv>-dd_handle = 3.
        WHEN 'USD'.
          <gfs_alv>-dd_handle = 4.
        WHEN 'JPY'.
          <gfs_alv>-dd_handle = 5.
      ENDCASE.
    ENDLOOP.

    "LINE_COLOR & CELL_COLOR

*    LOOP AT gt_alv ASSIGNING <gfs_alv>.
*      CASE <gfs_alv>-currcode.
*        WHEN 'USD'.
*          <gfs_alv>-line_color = 'C710'.
*        WHEN 'JPY'.
*          <gfs_alv>-line_color = 'C100'.
*        WHEN 'EUR'.
*          CLEAR:gs_cell_color.
*          gs_cell_color-fname = 'URL'.
*          gs_cell_color-color-col = '3'.
*          gs_cell_color-color-int = '0'.
*          gs_cell_color-color-inv = '0'.
*          APPEND gs_cell_color TO <gfs_alv>-cell_color.
*
*          CLEAR:gs_cell_color.
*          gs_cell_color-fname = 'CARRNAME'.
*          gs_cell_color-color-col = '5'.
*          gs_cell_color-color-int = '1'.
*          gs_cell_color-color-inv = '0'.
*          APPEND gs_cell_color TO <gfs_alv>-cell_color.
*        WHEN 'ZAR'.
*          CLEAR:gs_cell_color.
*          gs_cell_color-fname = 'URL'.
*          gs_cell_color-color-col = '6'.
*          gs_cell_color-color-int = '0'.
*          gs_cell_color-color-inv = '0'.
*          APPEND gs_cell_color TO <gfs_alv>-cell_color.
*        WHEN 'CHF'.
*          CLEAR:gs_cell_color.
*          gs_cell_color-fname = 'URL'.
*          gs_cell_color-color-col = '6'.
*          gs_cell_color-color-int = '0'.
*          gs_cell_color-color-inv = '1'.
*          APPEND gs_cell_color TO <gfs_alv>-cell_color.

*      ENDCASE.
*    ENDLOOP.
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
    gs_fcat-fieldname = 'DELETE'.
    gs_fcat-scrtext_l = 'DELETE'.
    gs_fcat-scrtext_m = 'DELETE'.
    gs_fcat-scrtext_s = 'DELETE'.
    gs_fcat-style     = cl_gui_alv_grid=>mc_style_button.
    gs_fcat-icon      = abap_true.
    APPEND gs_fcat TO gt_fcat.

    CLEAR:gs_fcat.
    gs_fcat-fieldname = 'DURUM'.
    gs_fcat-scrtext_s = 'Durum'.
    gs_fcat-scrtext_m = 'Durum'.
    gs_fcat-scrtext_l = 'Durum'.
    gs_fcat-icon      = abap_true.
    APPEND gs_fcat TO gt_fcat.

    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name = 'SCARR'
      CHANGING
        ct_fieldcat      = gt_fcat.

*    CLEAR:gs_fcat.
*    gs_fcat-fieldname = 'CARRID'.
*    gs_fcat-scrtext_s = 'Havayolu tanımı'.
*    gs_fcat-scrtext_m = 'Havayolu kısa tanımı'.
*    gs_fcat-scrtext_l = 'Havayolu şirketinin kısa tanımı'.
*    APPEND gs_fcat TO gt_fcat.
*
*    CLEAR:gs_fcat.
*    gs_fcat-fieldname = 'CARRNAME'.
*    gs_fcat-scrtext_s = 'Havayolu adı'.
*    gs_fcat-scrtext_m = 'Havayolu şirketinin adı'.
*    gs_fcat-scrtext_l = 'Havayolu şirketinin adı'.
*    APPEND gs_fcat TO gt_fcat.
*
*    CLEAR:gs_fcat.
*    gs_fcat-fieldname = 'CURRCODE'.
*    gs_fcat-scrtext_s = 'PB'.
*    gs_fcat-scrtext_m = 'Havayolu şirketinin ulusal para birimi'.
*    gs_fcat-scrtext_l = 'Havayolu şirketinin ulusal para birimi'.
*    APPEND gs_fcat TO gt_fcat.
*
*    CLEAR:gs_fcat.
*    gs_fcat-fieldname = 'URL'.
*    gs_fcat-scrtext_s = 'URL'.
*    gs_fcat-scrtext_m = 'Havayolu şirketinin URL'.
*    gs_fcat-scrtext_l = 'Havayolu şirketinin URL'.
*    gs_fcat-edit     = abap_true.
*    APPEND gs_fcat TO gt_fcat.
    CLEAR gs_fcat.
    gs_fcat-fieldname = 'COST'.
    gs_fcat-scrtext_s = 'COST'.
    gs_fcat-scrtext_m = 'COST'.
    gs_fcat-scrtext_l = 'COST'.
    APPEND gs_fcat TO gt_fcat.

    CLEAR:gs_fcat.
    gs_fcat-fieldname = 'LOCATION'.
    gs_fcat-scrtext_s = 'LOCATION'.
    gs_fcat-scrtext_m = 'LOCATION'.
    gs_fcat-scrtext_l = 'LOCATION'.
    gs_fcat-edit      = abap_true.
    gs_fcat-drdn_hndl = 1.
    APPEND gs_fcat TO gt_fcat.

    CLEAR:gs_fcat.
    gs_fcat-fieldname = 'SEATL'.
    gs_fcat-scrtext_s = 'Koltuk Harf'.
    gs_fcat-scrtext_m = 'Koltuk Harf'.
    gs_fcat-scrtext_l = 'Koltuk Harf'.
    gs_fcat-edit      = abap_true.
    gs_fcat-drdn_hndl = 2.
    APPEND gs_fcat TO gt_fcat.

    CLEAR:gs_fcat.
    gs_fcat-fieldname = 'SEATP'.
    gs_fcat-scrtext_s = 'Koltuk Pos.'.
    gs_fcat-scrtext_m = 'Koltuk Pos.'.
    gs_fcat-scrtext_l = 'Koltuk Pos.'.
    gs_fcat-edit      = abap_true.
    gs_fcat-drdn_field = 'DD_HANDLE'. "Dinamik bir dropdown için
    APPEND gs_fcat TO gt_fcat.

    CLEAR:gs_fcat.
    gs_fcat-fieldname = 'STYLEVAL'.
    gs_fcat-scrtext_s = 'STYLEVAL'.
    gs_fcat-scrtext_m = 'STYLEVAL'.
    gs_fcat-scrtext_l = 'STYLEVAL'.
    APPEND gs_fcat TO gt_fcat.

    READ TABLE gt_fcat ASSIGNING <gfs_fcat> WITH KEY fieldname = 'COST' .
    IF sy-subrc EQ 0.
      <gfs_fcat>-edit = abap_true.
    ENDIF.

    "HOTSPOT ÖZELLİĞİ İÇİN->TIKLANABİLİRLİK
    LOOP AT gt_fcat ASSIGNING <gfs_fcat>.
      IF <gfs_fcat>-fieldname EQ 'CARRID'.
*         OR
*         <gfs_fcat>-fieldname EQ 'CARRNAME'.
        <gfs_fcat>-hotspot = abap_true.
      ENDIF.
    ENDLOOP.

    "EDITABLE AÇILIR HANDLE DATA CHANGED
    LOOP AT gt_fcat ASSIGNING <gfs_fcat>.
      IF <gfs_fcat>-fieldname EQ 'CURRCODE'.
        <gfs_fcat>-edit = abap_true.
      ENDIF.
    ENDLOOP.

    "SEARCH HELP EVENT İÇİN
    LOOP AT gt_fcat ASSIGNING <gfs_fcat>.
      IF <gfs_fcat>-fieldname EQ 'CARRNAME'.
        <gfs_fcat>-edit       = abap_true.
*        <gfs_fcat>-f4availabl = abap_true.
        <gfs_fcat>-style      = cl_gui_alv_grid=>mc_style_f4.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD set_layout.
    CLEAR:gs_layout.
    gs_layout-col_opt    = abap_true.
    gs_layout-cwidth_opt = abap_true.
    gs_layout-zebra      = abap_true.
*    gs_layout-info_fname = 'LINE_COLOR'.
*    gs_layout-ctab_fname = 'CELL_COLOR'.
    gs_layout-stylefname = 'CELLSTYLE'.
  ENDMETHOD.

  METHOD display_alv.
    IF go_alv_grid IS INITIAL.

      CREATE OBJECT go_container
        EXPORTING
          container_name = 'CC_ALV'.

      CREATE OBJECT go_splitter
        EXPORTING
          parent  = go_container    " Parent Container
          rows    = 2    " Number of Rows to be displayed
          columns = 1.   " Number of Columns to be Displayed

      CALL METHOD go_splitter->get_container
        EXPORTING
          row       = 1   " Row
          column    = 1   " Column
        RECEIVING
          container = go_sub1.   " Container
      .
      CALL METHOD go_splitter->get_container
        EXPORTING
          row       = 2   " Row
          column    = 1   " Column
        RECEIVING
          container = go_sub2.   " Container
      .

      CALL METHOD go_splitter->set_row_height
        EXPORTING
          id     = 1   " Row ID
          height = 15.   " Height

      CREATE OBJECT go_docu
        EXPORTING
          style = 'ALV_GRID'.   " Adjusting to the Style of a Particular GUI Environment

      CREATE OBJECT go_alv_grid
        EXPORTING
*         i_parent = go_container.    " Parent Container
          i_parent = go_sub2.    " Parent Container

      go_local->dropdown( ).

      PERFORM register_f4.

      SET HANDLER go_local->handle_top_of_page   FOR go_alv_grid.
      SET HANDLER go_local->handle_hotspot_click FOR go_alv_grid.
      SET HANDLER go_local->handle_double_click  FOR go_alv_grid.
      SET HANDLER go_local->handle_data_changed  FOR go_alv_grid.
      SET HANDLER go_local->handle_onf4          FOR go_alv_grid.
      SET HANDLER go_local->handle_button_click  FOR go_alv_grid.
      SET HANDLER go_local->handle_toolbar       FOR go_alv_grid.
      SET HANDLER go_local->handle_user_command  FOR go_alv_grid.

      PERFORM set_excluding.
      PERFORM set_sort.
*     PERFORM set_filter.

      gs_variant-report  = sy-repid.
      gs_variant-variant = p_vari.

      CALL METHOD go_alv_grid->set_table_for_first_display
        EXPORTING
*         i_buffer_active      =     " Buffering Active
*         i_bypassing_buffer   =     " Switch Off Buffer
*         i_consistency_check  =     " Starting Consistency Check for Interface Error Recognition
*         i_structure_name     =     " Internal Output Table Structure Name
          is_variant           = gs_variant  " Layout
          i_save               = 'X'  " Save Layout
*         i_default            = 'X'    " Default Display Variant
          is_layout            = gs_layout  " Layout
*         is_print             =     " Print Control
*         it_special_groups    =     " Field Groups
          it_toolbar_excluding = gt_excluding  " Excluded Toolbar Standard Functions
*         it_hyperlink         =     " Hyperlinks
*         it_alv_graphics      =     " Table of Structure DTC_S_TC
*         it_except_qinfo      =     " Table for Exception Quickinfo
*         ir_salv_adapter      =     " Interface ALV Adapter
        CHANGING
          it_outtab            = gt_alv  " Output Table
          it_fieldcatalog      = gt_fcat " Field Catalog
          it_sort              = gt_sort   " Sort Criteria
          it_filter            = gt_filter  " Filter Criteria
*        EXCEPTIONS
*         invalid_parameter_combination = 1
*         program_error        = 2
*         too_many_lines       = 3
*         others               = 4
        .
      IF sy-subrc <> 0.
*       MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*                  WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.

      CALL METHOD go_alv_grid->register_edit_event
        EXPORTING
          i_event_id = cl_gui_alv_grid=>mc_evt_modified.

      "TOP_OF_PAGE EVENT
      CALL METHOD go_alv_grid->list_processing_events
        EXPORTING
          i_event_name = 'TOP_OF_PAGE'  " Event Name List Processing
          i_dyndoc_id  = go_docu. " Dynamic Document

    ELSE.
*      CALL METHOD go_alv_grid->refresh_table_display.
    ENDIF.
  ENDMETHOD.

  METHOD get_sum.
    DATA:lv_sum   TYPE int4,
         lv_sum_c TYPE char10,
         lv_lines TYPE int4,
         lv_avr   TYPE int4.

    LOOP AT gt_alv INTO gs_alv.
      lv_sum = lv_sum + gs_alv-cost.
    ENDLOOP.
    lv_sum_c = lv_sum.

    DESCRIBE TABLE gt_alv LINES lv_lines.

    lv_avr = lv_sum / lv_lines.

    LOOP AT gt_alv  ASSIGNING <gfs_alv>.
      IF <gfs_alv>-cost > lv_avr.
        <gfs_alv>-durum = '@0A@'.

      ELSEIF <gfs_alv>-cost < lv_avr.
        <gfs_alv>-durum = '@08@'.

      ELSE.
        <gfs_alv>-durum = '@09@'.
      ENDIF.
    ENDLOOP.

    go_alv_grid->refresh_table_display( ).

    MESSAGE |cost kolon satırlarının toplamı: | && lv_sum_c TYPE 'I' DISPLAY LIKE 'S'.
  ENDMETHOD.

  METHOD make_non_editable.
    DATA:ls_stylerow TYPE  lvc_s_styl,
*         lt_stylerow TYPE TABLE OF lvc_s_styl,
         lt_stylerow TYPE lvc_t_styl.

    LOOP AT gt_alv ASSIGNING FIELD-SYMBOL(<fs>).
      ls_stylerow-style     = cl_gui_alv_grid=>mc_style_disabled.
      ls_stylerow-fieldname =  'COST'.
      INSERT ls_stylerow INTO TABLE lt_stylerow.

      CLEAR:<fs>-cellstyle.
      INSERT LINES OF lt_stylerow INTO TABLE <fs>-cellstyle.

    ENDLOOP.
  ENDMETHOD.

  METHOD dropdown.

    DATA:lt_dropdown TYPE lvc_t_drop,
         ls_dropdown TYPE lvc_s_drop.

    CLEAR:ls_dropdown.
    ls_dropdown-handle = 1. "gs_fcatte drdn_hndl a verilen ID ile aynı olmalı!
    ls_dropdown-value  = 'Yurtiçi'.
    APPEND ls_dropdown TO lt_dropdown.

    CLEAR:ls_dropdown.
    ls_dropdown-handle = 1.
    ls_dropdown-value  = 'Yurdışı'.
    APPEND ls_dropdown TO lt_dropdown.

    CLEAR:ls_dropdown.
    ls_dropdown-handle = 2.
    ls_dropdown-value  = 'A'.
    APPEND ls_dropdown TO lt_dropdown.

    CLEAR:ls_dropdown.
    ls_dropdown-handle = 2.
    ls_dropdown-value  = 'B'.
    APPEND ls_dropdown TO lt_dropdown.

    CLEAR:ls_dropdown.
    ls_dropdown-handle = 2.
    ls_dropdown-value  = 'C'.
    APPEND ls_dropdown TO lt_dropdown.

    CLEAR:ls_dropdown.
    ls_dropdown-handle = 2.
    ls_dropdown-value  = 'D'.
    APPEND ls_dropdown TO lt_dropdown.

    CLEAR:ls_dropdown.
    ls_dropdown-handle = 2.
    ls_dropdown-value  = 'E'.
    APPEND ls_dropdown TO lt_dropdown.

    CLEAR:ls_dropdown.
    ls_dropdown-handle = 2.
    ls_dropdown-value  = 'F'.
    APPEND ls_dropdown TO lt_dropdown.

    CLEAR:ls_dropdown.
    ls_dropdown-handle = 3.
    ls_dropdown-value  = 'ÖN'.
    APPEND ls_dropdown TO lt_dropdown.

    CLEAR:ls_dropdown.
    ls_dropdown-handle = 3.
    ls_dropdown-value  = 'ARKA'.
    APPEND ls_dropdown TO lt_dropdown.

    CLEAR:ls_dropdown.
    ls_dropdown-handle = 3.
    ls_dropdown-value  = 'KANAT'.
    APPEND ls_dropdown TO lt_dropdown.

    CLEAR:ls_dropdown.
    ls_dropdown-handle = 4.
    ls_dropdown-value  = 'ÖN'.
    APPEND ls_dropdown TO lt_dropdown.

    CLEAR:ls_dropdown.
    ls_dropdown-handle = 4.
    ls_dropdown-value  = 'ARKA'.
    APPEND ls_dropdown TO lt_dropdown.

    CALL METHOD go_alv_grid->set_drop_down_table
      EXPORTING
        it_drop_down = lt_dropdown.   " Dropdown Table

  ENDMETHOD.


  METHOD handle_top_of_page.
    DATA:lv_text TYPE sdydo_text_element.

    lv_text = 'SCARR TABLE TOP OF PAGE TEXT'.

    CALL METHOD go_docu->add_text
      EXPORTING
        text      = lv_text   " Single Text,
        sap_style = cl_dd_document=>heading. " Recommended Styles

    CALL METHOD go_docu->new_line.
    CLEAR:lv_text.
    CONCATENATE 'User:' sy-uname INTO lv_text SEPARATED BY space.

    CALL METHOD go_docu->add_text
      EXPORTING
        text      = lv_text   " Single Text, Up To 255 Characters Long
        sap_style = cl_dd_document=>list_positive     " Recommended Styles
        sap_color = cl_dd_document=>medium.  " Not Release 99

    CALL METHOD go_docu->display_document
      EXPORTING
        parent = go_sub1.  " Contain Object Already Exists

  ENDMETHOD.

  METHOD handle_hotspot_click.
    DATA:lv_mess TYPE char200.

    READ TABLE gt_alv INTO gs_alv INDEX e_row_id-index.
    IF sy-subrc EQ 0.

      CASE e_column_id-fieldname.

        WHEN 'CARRID'.
          lv_mess = |Tıklanan kolon | && e_column_id-fieldname
           && | değeri:| && gs_alv-carrid.

          MESSAGE lv_mess TYPE 'I'.

*        WHEN 'CARRNAME'.
*          CONCATENATE 'Tıklanan kolon'
*                      e_column_id-fieldname
*                      'değeri'
*                      gs_alv-carrname
*                      INTO lv_mess
*                      SEPARATED BY space.
*          MESSAGE lv_mess TYPE 'I'.
      ENDCASE.
    ENDIF.
  ENDMETHOD.

  METHOD handle_double_click.
    DATA:lv_mess TYPE char200.

    READ TABLE gt_alv INTO gs_alv INDEX e_row-index.
    IF sy-subrc EQ 0.
      CONCATENATE 'Tıklanan kolon'
                   e_column-fieldname
                   ', satırın değeri'
                   gs_alv-durum
                   INTO lv_mess
      SEPARATED BY space.
      MESSAGE lv_mess TYPE 'I'.
    ENDIF.
  ENDMETHOD.

  METHOD  handle_data_changed.
    DATA:ls_modi TYPE lvc_s_modi,
         lv_mess TYPE char200.

    LOOP AT er_data_changed->mt_good_cells INTO ls_modi.
      READ TABLE gt_alv INTO gs_alv INDEX ls_modi-row_id.
      IF sy-subrc EQ 0.

        CASE ls_modi-fieldname.

          WHEN 'COST'.

            CONCATENATE  ls_modi-fieldname
                         '=> eski değeri'
                         'gs_alv-cost'
                         ', yeni değer'
                         ls_modi-value
                         INTO lv_mess
                         SEPARATED BY space.
            MESSAGE lv_mess TYPE 'I'.

          WHEN 'CURRCODE'.
            CONCATENATE  ls_modi-fieldname
                         '=> eski değeri'
                         gs_alv-currcode
                         ', yeni değer'
                         ls_modi-value
                         INTO lv_mess
                         SEPARATED BY space.
            MESSAGE lv_mess TYPE 'I'.
        ENDCASE.

      ENDIF.

    ENDLOOP.
  ENDMETHOD.

  METHOD handle_onf4.

    DATA:lt_return_tab TYPE TABLE OF ddshretval,
         ls_return_tab TYPE ddshretval.

    TYPES:BEGIN OF lty_value_tab,
            carrname TYPE s_carrname,
            carrdeff TYPE char20,
          END OF lty_value_tab.

    DATA:lt_value_tab TYPE TABLE OF lty_value_tab.
    DATA:ls_value_tab TYPE  lty_value_tab.

    CLEAR:ls_value_tab.
    ls_value_tab-carrname = 'Uçuş 1'.
    ls_value_tab-carrdeff = 'A'.
    APPEND ls_value_tab TO lt_value_tab.

    CLEAR:ls_value_tab.
    ls_value_tab-carrname = 'Uçuş 2'.
    ls_value_tab-carrdeff = 'B'.
    APPEND ls_value_tab TO lt_value_tab.

    CLEAR:ls_value_tab.
    ls_value_tab-carrname = 'Uçuş 3'.
    ls_value_tab-carrdeff = 'C'.
    APPEND ls_value_tab TO lt_value_tab.

    CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
      EXPORTING
        retfield     = 'CARRNAME'
        window_title = 'Carrname F4'
        value_org    = 'S'
      TABLES
        value_tab    = lt_value_tab
        return_tab   = lt_return_tab.

    READ TABLE lt_return_tab INTO ls_return_tab WITH KEY fieldname = 'F0001'.
    IF sy-subrc EQ 0.
      READ TABLE gt_alv ASSIGNING <gfs_alv> INDEX es_row_no-row_id.
      IF sy-subrc EQ 0.
        <gfs_alv>-carrname = ls_return_tab-fieldval.

        CALL METHOD go_alv_grid->refresh_table_display.
      ENDIF.
    ENDIF.

    er_event_data->m_event_handled = 'X'.
  ENDMETHOD.

  METHOD handle_button_click.
    DATA:lv_mess TYPE char200.

    READ TABLE gt_alv INTO gs_alv INDEX es_row_no-row_id.
    IF sy-subrc EQ 0.
      CASE es_col_id-fieldname.
        WHEN 'DELETE'.
          CONCATENATE es_col_id-fieldname
                      ','
                      'gs_alv'
                      INTO lv_mess
                      SEPARATED BY space.
          MESSAGE lv_mess TYPE 'I'.
      ENDCASE.
    ENDIF.

  ENDMETHOD.

  METHOD handle_toolbar.

    DATA:ls_toolbar TYPE stb_button.

    CLEAR:ls_toolbar.
    ls_toolbar-function   = '&DEL'.
    ls_toolbar-text       = 'Delete'.
    ls_toolbar-icon       = '@11@'.
    ls_toolbar-quickinfo  = 'Silme İşlemi'.
    ls_toolbar-disabled   = abap_false.

    APPEND ls_toolbar TO e_object->mt_toolbar.

    CLEAR:ls_toolbar.
    ls_toolbar-function   = '&DIS'.
    ls_toolbar-text       = 'Display'.
    ls_toolbar-icon       = '@10@'.
    ls_toolbar-quickinfo  = 'Görüntüleme İşlemi'.
    ls_toolbar-disabled   = abap_false.

    APPEND ls_toolbar TO e_object->mt_toolbar.

  ENDMETHOD.

  METHOD handle_user_command.
    CASE e_ucomm.
      WHEN '&DEL'.
        MESSAGE |toolbar button: DELETE !| TYPE 'I'.
      WHEN '&DIS'.
        MESSAGE |toolbar button: DISPLAY !| TYPE 'I'.
    ENDCASE.
  ENDMETHOD.

ENDCLASS.

" I_SAVE = ' ' --> Display variants cannot be saved
" I_SAVE = 'X' --> Standart save mode
" I_SAVE = 'U' --> User-specific save mode
" I_SAVE = 'A' --> Standart and user-specific save mode
