*&---------------------------------------------------------------------*
*& Include          ZGAMZEY_HARD7_LCL
*&---------------------------------------------------------------------*
CLASS local DEFINITION.
  PUBLIC SECTION.
    METHODS:
      get_data,
      call_screen,
      call_pop_up_screen,
      get_selected_rows,
      pbo_0100,
      pbo_0200,
      pai_0100 IMPORTING iv_ucomm TYPE sy-ucomm,
      pai_0200 IMPORTING iv_ucomm TYPE sy-ucomm,
      set_fieldcat,
      set_fieldcat_2,
      set_layout,
      set_layout_2,
      display_alv,
      display_alv_2.
ENDCLASS.
CLASS local IMPLEMENTATION.
  METHOD get_data.
    SELECT
      t1~bname,
      t1~ustyp,
      t1~aname,
      t1~erdat,
      t1~trdat,
      t1~ltime
      FROM usr02 AS t1
      INTO CORRESPONDING FIELDS OF TABLE @gt_user_l.
  ENDMETHOD.

  METHOD call_screen.
    CALL SCREEN 0100.
  ENDMETHOD.

  METHOD call_pop_up_screen.
    CALL SCREEN 0200 STARTING AT 10 10
                     ENDING AT   50 20.
  ENDMETHOD.

  METHOD get_selected_rows.
    DATA:lt_index_rows TYPE lvc_t_row.
    CALL METHOD go_alv_grid->get_selected_rows
      IMPORTING
        et_index_rows = lt_index_rows.  " Indexes of Selected Rows

    IF lt_index_rows IS INITIAL.
      gv_flag = ''.
      MESSAGE 'Lütfen bir satır veri seçin!' TYPE 'I' DISPLAY LIKE 'W'.
    ELSE.
      gv_flag = 'X'.
      LOOP AT lt_index_rows INTO DATA(ls_index_rows).
        READ TABLE gt_user_l INTO DATA(ls_user_l) INDEX ls_index_rows-index.
      ENDLOOP.

      SELECT
        t1~bname,
        t2~profile
        FROM usr02 AS t1
        LEFT JOIN ust04 AS t2
        ON t1~bname EQ t2~bname
        WHERE t1~bname EQ @ls_user_l-bname
        INTO CORRESPONDING FIELDS OF TABLE @gt_profil.
    ENDIF.

  ENDMETHOD.

  METHOD pbo_0100.
    SET PF-STATUS '0100'.
    SET TITLEBAR '0100'.
  ENDMETHOD.

  METHOD pbo_0200.
    SET PF-STATUS '0200'.
    SET TITLEBAR '0200'.

  ENDMETHOD.

  METHOD pai_0100.
    CASE iv_ucomm.
      WHEN '&BACK'.
        SET SCREEN 0.
      WHEN '&PROFIL'.
        go_local->get_selected_rows( ).
        IF gv_flag EQ abap_true.
          go_local->call_pop_up_screen( ).
        ENDIF.

    ENDCASE.
  ENDMETHOD.

  METHOD pai_0200.
    CASE iv_ucomm.
      WHEN '&CANCEL'.
        SET SCREEN 0.
    ENDCASE.
  ENDMETHOD.

  METHOD set_fieldcat.
    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name = 'ZGAMZEY_USER_L_S'
      CHANGING
        ct_fieldcat      = gt_fieldcat.
  ENDMETHOD.
  METHOD set_fieldcat_2.
    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name = 'ZGAMZEY_PROFIL_L_S'
      CHANGING
        ct_fieldcat      = gt_fieldcat_2.
  ENDMETHOD.

  METHOD set_layout.
    gs_layout-zebra = abap_true.
    gs_layout-cwidth_opt = abap_true.
    gs_layout-col_opt = abap_true.
    gs_layout-sel_mode = 'B'.
  ENDMETHOD.
  METHOD set_layout_2.
    gs_layout_2-zebra = abap_true.
    gs_layout_2-cwidth_opt = abap_true.
    gs_layout_2-col_opt = abap_true.
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
          it_outtab       = gt_user_l " Output Table
          it_fieldcatalog = gt_fieldcat.  " Field Catalog
    ELSE.
      CALL METHOD go_alv_grid->refresh_table_display.
    ENDIF.
  ENDMETHOD.

  METHOD display_alv_2.
    IF go_alv_grid_2 IS INITIAL.
      CREATE OBJECT go_container_2
        EXPORTING
          container_name = 'CC_ALV_2'.   " Name of the Screen CustCtrl Name to Link Container To
      CREATE OBJECT go_alv_grid_2
        EXPORTING
*         i_parent = cl_gui_container=>screen0.
          i_parent = go_container_2.   " Parent Container
      CALL METHOD go_alv_grid_2->set_table_for_first_display
        EXPORTING
          is_layout       = gs_layout_2   " Layout
        CHANGING
          it_outtab       = gt_profil " Output Table
          it_fieldcatalog = gt_fieldcat_2.  " Field Catalog
    ELSE.
      CALL METHOD go_alv_grid_2->refresh_table_display.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
