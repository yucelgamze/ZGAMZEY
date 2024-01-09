*&---------------------------------------------------------------------*
*& Include          ZGY_0026_LCL
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
      ikramiye.
ENDCLASS.
CLASS lcl_class IMPLEMENTATION.
  METHOD get_data.
    SELECT * FROM zgy_t_0014 INTO CORRESPONDING FIELDS OF TABLE gt_alv.
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
        i_structure_name = 'ZGY_S_0017'
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
          container_name = 'CC_ALV'.    " Name of the Screen CustCtrl Name to Link Container To
      CREATE OBJECT go_alv_grid
        EXPORTING
          i_parent = go_container.  " Parent Container
      go_alv_grid->set_table_for_first_display(
        EXPORTING
          is_layout                     =  gs_layout   " Layout
        CHANGING
          it_outtab                     =  gt_alv   " Output Table
          it_fieldcatalog               = gt_fcat ).  " Field Catalog
    ELSE.
      go_alv_grid->refresh_table_display( ).

    ENDIF.
  ENDMETHOD.
  METHOD ikramiye.

    DATA:lv_toplam_yıl TYPE i,
         lv_miktar     TYPE i.

    LOOP AT gt_alv INTO gs_alv.
      lv_toplam_yil = lv_toplam_yil + gs_alv-pers_yil.
    ENDLOOP.

    lv_miktar = p_butce / lv_toplam_yil.

    LOOP AT gt_alv ASSIGNING FIELD-SYMBOL(<lfs_alv>).
      <lfs_alv>-ikramiye_miktari = <lfs_alv>-pers_yil * lv_miktar.
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
