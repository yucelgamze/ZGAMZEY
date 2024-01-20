*&---------------------------------------------------------------------*
*& Include          ZGAMZEY_MEDIUM_PERS_CLASS
*&---------------------------------------------------------------------*
CLASS local DEFINITION.
  PUBLIC SECTION.
    METHODS:
      get_data,
      call_screen,
      pbo_0100,
      pai_0100 IMPORTING iv_ucomm TYPE sy-ucomm,
      set_fieldcat,
      set_layout,
      display_alv.
ENDCLASS.

CLASS local IMPLEMENTATION.
  METHOD get_data.

    DATA:lt_worker TYPE TABLE OF zgamzey_worker_t.

    SELECT
      t~personal_id
      t~personal_is_basi
      FROM zgamzey_worker_t AS t
      INTO CORRESPONDING FIELDS OF TABLE lt_worker.

    LOOP AT lt_worker INTO DATA(ls_worker).

      CALL FUNCTION 'HR_99S_INTERVAL_BETWEEN_DATES'
        EXPORTING
          begda    = ls_worker-personal_is_basi
          endda    = '20220321'
        IMPORTING
          days     = gs_worker-personal_gun
          c_months = gs_worker-personal_ay
          c_years  = gs_worker-personal_yil.

      gs_worker-personal_id = ls_worker-personal_id.
      gs_worker-personal_is_basi = ls_worker-personal_is_basi.
      gs_worker-personal_ay = gs_worker-personal_ay MOD 12.
      gs_worker-personal_gun = gs_worker-personal_gun MOD 30.
      APPEND gs_worker TO gt_worker.
    ENDLOOP.

    SORT gt_worker ASCENDING BY personal_is_basi.
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

  METHOD set_fieldcat.
    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name = 'ZGAMZEY_WORKER_S'
      CHANGING
        ct_fieldcat      = gt_fieldcat.
  ENDMETHOD.

  METHOD set_layout.
    gs_layout-zebra = abap_true.
    gs_layout-cwidth_opt = abap_true.
    gs_layout-col_opt = abap_true.
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
          it_outtab       = gt_worker  " Output Table
          it_fieldcatalog = gt_fieldcat.  " Field Catalog
    ELSE.
      CALL METHOD go_alv_grid->refresh_table_display.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
