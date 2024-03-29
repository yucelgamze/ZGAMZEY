*&---------------------------------------------------------------------*
*& Include          ZGY_0027_LCL
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
      display_alv.
ENDCLASS.
CLASS lcl_class IMPLEMENTATION.
  METHOD get_data.
    SELECT
    personal_id,
    personal_is_basi
    FROM zgy_t_0015 INTO CORRESPONDING FIELDS OF TABLE @gt_alv.

    LOOP AT gt_alv ASSIGNING FIELD-SYMBOL(<lfs_alv>).
      CALL FUNCTION 'HR_99S_INTERVAL_BETWEEN_DATES'
        EXPORTING
          begda    = <lfs_alv>-personal_is_basi
          endda    = '20220321'
        IMPORTING
          days     = <lfs_alv>-personal_gun
          c_months = <lfs_alv>-personal_ay
          c_years  = <lfs_alv>-personal_yil.

      <lfs_alv>-personal_gun = <lfs_alv>-personal_gun MOD 30.
      <lfs_alv>-personal_ay  = <lfs_alv>-personal_ay  MOD 12.
    ENDLOOP.

    SORT gt_alv ASCENDING BY personal_is_basi.
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
    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name = 'ZGY_S_0018'
      CHANGING
        ct_fieldcat      = gt_fcat.

  ENDMETHOD.
  METHOD set_layout.
    gs_layout-zebra      = abap_true.
    gs_layout-col_opt    = abap_true.
    gs_layout-cwidth_opt = abap_true.
  ENDMETHOD.
  METHOD display_alv.
    IF go_alv_grid IS INITIAL.
      CREATE OBJECT go_container
        EXPORTING
          container_name = 'CC_ALV'.  " Name of the Screen CustCtrl Name to Link Container To
      CREATE OBJECT go_alv_grid
        EXPORTING
          i_parent = go_container.   " Parent Container
      CALL METHOD go_alv_grid->set_table_for_first_display
        EXPORTING
          is_layout       = gs_layout    " Layout
        CHANGING
          it_outtab       = gt_alv   " Output Table
          it_fieldcatalog = gt_fcat.  " Field Catalog
    ELSE.
      CALL METHOD go_alv_grid->refresh_table_display( ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
