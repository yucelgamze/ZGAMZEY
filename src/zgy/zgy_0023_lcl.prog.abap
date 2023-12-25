*&---------------------------------------------------------------------*
*& Include          ZGY_0023_LCL
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

    DATA:ls_selopt TYPE selopt.
    LOOP AT so_matnr INTO ls_selopt.
      gv_matnr = ls_selopt-low.
    ENDLOOP.

*    DATA(lv_matnr) = VALUE rsdsselopt_t( FOR ls_selopt IN so_matnr
*    ( sign = if_fsbp_const_range=>sign_include
*      option = if_fsbp_const_range=>option_equal
*      low = ls_selopt-low ) ).

    DATA:ls_data     TYPE bapimatdoa,
         lv_material TYPE bapimatdet-material.

    lv_material = gv_matnr.

    CALL FUNCTION 'BAPI_MATERIAL_GET_DETAIL'
      EXPORTING
        material              = lv_material
      IMPORTING
        material_general_data = ls_data.

    gs_alv-matnr      = gv_matnr.
    gs_alv-matl_type  = ls_data-matl_type.
    gs_alv-matl_desc  = ls_data-matl_desc.
    gs_alv-base_uom   = ls_data-base_uom.
    gs_alv-created_on = ls_data-created_on.
    gs_alv-created_by = ls_data-created_by.

    INSERT gs_alv INTO TABLE gt_alv.

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
        i_structure_name = 'ZGY_S_0008'
      CHANGING
        ct_fieldcat      = gt_fcat.
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
          i_parent = go_container.  " Parent Container
      CALL METHOD go_alv_grid->set_table_for_first_display
        EXPORTING
          is_layout       = gs_layout   " Layout
        CHANGING
          it_outtab       = gt_alv   " Output Table
          it_fieldcatalog = gt_fcat.   " Field Catalog
    ELSE.
      CALL METHOD go_alv_grid->refresh_table_display.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
