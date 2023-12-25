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
      set_fcat2,
      set_layout,
      set_layout2,
      display_alv,
      get_sum,
      make_non_editable,
      dropdown.
ENDCLASS.

CLASS lcl_class IMPLEMENTATION.
  METHOD get_data.
    SELECT * FROM sflight INTO TABLE gt_alv2.

    SELECT
      db_t~carrid,
      db_t~carrname,
      db_t~currcode,
      db_t~url,
      '@0A@' AS durum

      FROM scarr AS db_t
      INTO  CORRESPONDING FIELDS OF TABLE @gt_alv.

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
    gs_fcat-fieldname = 'DURUM'.
    gs_fcat-scrtext_s = 'Durum'.
    gs_fcat-scrtext_m = 'Durum'.
    gs_fcat-scrtext_l = 'Durum'.
    gs_fcat-icon      = abap_true.
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
    gs_fcat-edit      = abap_true.
    APPEND gs_fcat TO gt_fcat.

    CLEAR:gs_fcat.
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

  METHOD set_fcat2.
    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name = 'SFLIGHT'
      CHANGING
        ct_fieldcat      = gt_fcat2.
  ENDMETHOD.

  METHOD set_layout2.
    gs_layout2-col_opt    = abap_true.
    gs_layout2-cwidth_opt = abap_true.
    gs_layout2-zebra      = abap_true.
  ENDMETHOD.


  METHOD display_alv.
    IF go_alv_grid IS INITIAL.
      CREATE OBJECT go_container
        EXPORTING
          container_name = 'CC_ALV'.
************************************************************************************************
      "splitter container
      CREATE OBJECT go_splitter
        EXPORTING
          parent  = go_container   " Parent Container
          rows    = 1  " Number of Rows to be displayed
          columns = 2.  " Number of Columns to be Displayed

      CALL METHOD go_splitter->get_container
        EXPORTING
          row       = 1   " Row
          column    = 1  " Column
        RECEIVING
          container = go_gui1. " Container

      CALL METHOD go_splitter->get_container
        EXPORTING
          row       = 1   " Row
          column    = 2  " Column
        RECEIVING
          container = go_gui2. " Container

      CREATE OBJECT go_alv_grid
        EXPORTING
          i_parent = go_gui1.    " Parent Container

      CREATE OBJECT go_alv_grid2
        EXPORTING
          i_parent = go_gui2.    " Parent Container
*************************************************************************************************
*      CREATE OBJECT go_alv_grid
*        EXPORTING
*          i_parent = go_container.    " Parent Container

      go_local->dropdown( ).

      CALL METHOD go_alv_grid->set_table_for_first_display
        EXPORTING
          is_layout       = gs_layout   " Layout
        CHANGING
          it_outtab       = gt_alv  " Output Table
          it_fieldcatalog = gt_fcat. " Field Catalog

      CALL METHOD go_alv_grid->register_edit_event
        EXPORTING
          i_event_id = cl_gui_alv_grid=>mc_evt_modified.

      "splitter 2. alv***********************************************
      CALL METHOD go_alv_grid2->set_table_for_first_display
        EXPORTING
          is_layout       = gs_layout2   " Layout
        CHANGING
          it_outtab       = gt_alv2  " Output Table
          it_fieldcatalog = gt_fcat2. " Field Catalog

      CALL METHOD go_alv_grid2->register_edit_event
        EXPORTING
          i_event_id = cl_gui_alv_grid=>mc_evt_modified.

      "*******************************************************
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
*         lt_stylerow TYPE TABLE OF lvc_s_styl.
         lt_stylerow TYPE  lvc_t_styl.

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
ENDCLASS.
