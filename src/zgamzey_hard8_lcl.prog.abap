*&---------------------------------------------------------------------*
*& Include          ZGAMZEY_HARD8_LCL
*&---------------------------------------------------------------------*
CLASS local DEFINITION.
  PUBLIC SECTION.
    METHODS:
      get_data,
      get_data_2,
      call_screen,
      call_screen_2,
      pbo_0100,
      pbo_0200,
      pai_0100 IMPORTING iv_ucomm TYPE sy-ucomm,
      pai_0200 IMPORTING iv_ucomm TYPE sy-ucomm,
      set_fieldcat,
      set_fieldcat_2,
      set_layout,
      set_layout_2,
      display_alv,
      display_alv_2,
      handle_hotspot_click
                    FOR EVENT hotspot_click OF cl_gui_alv_grid
        IMPORTING e_row_id
                    e_column_id.
ENDCLASS.
CLASS local IMPLEMENTATION.
  METHOD get_data.
    SELECT
      cnam,
      COUNT(*) AS zprogram_sayisi
      FROM reposrc
      GROUP BY cnam
      INTO CORRESPONDING FIELDS OF TABLE @gt_usr_pro.

  ENDMETHOD.
  METHOD get_data_2.
    SELECT
      t~cnam,
      t~progname,
      t~cdat,
      t~vern,
      t~datalg
      FROM reposrc AS t
      WHERE t~cnam EQ @gv_cnam
      INTO CORRESPONDING FIELDS OF TABLE @gt_pro_inf.
  ENDMETHOD.
  METHOD call_screen.
    CALL SCREEN 0100.
  ENDMETHOD.

  METHOD call_screen_2.
    CALL SCREEN 0200.
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
    ENDCASE.
  ENDMETHOD.

  METHOD pai_0200.
    CASE iv_ucomm.
      WHEN '&BACK'.
        SET SCREEN 0.
    ENDCASE.
  ENDMETHOD.

  METHOD set_fieldcat.
    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name = 'ZGAMZEY_USER_PROG_S'
      CHANGING
        ct_fieldcat      = gt_fieldcat.

    "hotspot aktif edilir.
    LOOP AT gt_fieldcat ASSIGNING <gfs_fieldcat>.
      IF <gfs_fieldcat>-fieldname EQ 'ZPROGRAM_SAYISI'.
        <gfs_fieldcat>-hotspot = abap_true.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD set_fieldcat_2.
    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name = 'ZGAMZEY_PROG_INFO_S'
      CHANGING
        ct_fieldcat      = gt_fieldcat_2.
  ENDMETHOD.

  METHOD set_layout.
    gs_layout-zebra = abap_true.
    gs_layout-cwidth_opt = abap_true.
    gs_layout-col_opt = abap_true.
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

      "hotspot assign edildi
      SET HANDLER go_local->handle_hotspot_click FOR go_alv_grid.

      CALL METHOD go_alv_grid->set_table_for_first_display
        EXPORTING
          is_layout       = gs_layout   " Layout
        CHANGING
          it_outtab       = gt_usr_pro " Output Table
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
          it_outtab       = gt_pro_inf " Output Table
          it_fieldcatalog = gt_fieldcat_2.  " Field Catalog
    ELSE.
      CALL METHOD go_alv_grid_2->refresh_table_display.
    ENDIF.
  ENDMETHOD.

  METHOD handle_hotspot_click.
    READ TABLE gt_usr_pro INTO DATA(ls_usr_pro) INDEX e_row_id-index.
    IF sy-subrc EQ 0.
      CASE e_column_id-fieldname.
        WHEN 'ZPROGRAM_SAYISI'.
          gv_cnam = ls_usr_pro-cnam.
          go_local->get_data_2( ).
          go_local->call_screen_2( ).
      ENDCASE.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
