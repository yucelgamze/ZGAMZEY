*&---------------------------------------------------------------------*
*& Include          ZGAMZEY_MEDIUM_BAPI_CLASS
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
      display_alv,
      call_func IMPORTING iv_matnr TYPE matnr .
ENDCLASS.

CLASS local IMPLEMENTATION.
  METHOD get_data.
    DATA:ls_selopt TYPE selopt,
         lv_matnr  TYPE matnr.
    LOOP AT so_matnr INTO ls_selopt.
      lv_matnr = ls_selopt-low.
      go_local->call_func( EXPORTING iv_matnr = lv_matnr ).
    ENDLOOP.
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
        i_structure_name = 'ZGAMZEY_MEDIUM_BAPI_S'
      CHANGING
        ct_fieldcat      = gt_fieldcat.
  ENDMETHOD.

  METHOD set_layout.
    gs_layout-zebra = abap_true.
    gs_layout-col_opt = abap_true.
    gs_layout-cwidth_opt = abap_true.
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
          it_outtab       = gt_bapi   " Output Table
          it_fieldcatalog = gt_fieldcat.  " Field Catalog
    ELSE.
      CALL METHOD go_alv_grid->refresh_table_display.
    ENDIF.
  ENDMETHOD.

  METHOD call_func.
    DATA:
      lv_material              TYPE bapimatdet-material,
      ls_material_general_data TYPE bapimatdoa.

      lv_material = iv_matnr.

    CALL FUNCTION 'BAPI_MATERIAL_GET_DETAIL'
      EXPORTING
        material              = lv_material
      IMPORTING
        material_general_data = ls_material_general_data.

    gs_bapi-matnr = iv_matnr.
    gs_bapi-matl_type = ls_material_general_data-matl_type.
    gs_bapi-matl_desc = ls_material_general_data-matl_desc.
    gs_bapi-base_uom = ls_material_general_data-base_uom.
    gs_bapi-created_on = ls_material_general_data-created_on.
    gs_bapi-created_by = ls_material_general_data-created_by.
    INSERT gs_bapi INTO TABLE gt_bapi.
  ENDMETHOD.

ENDCLASS.
