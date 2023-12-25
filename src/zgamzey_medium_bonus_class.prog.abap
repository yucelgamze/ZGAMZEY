*&---------------------------------------------------------------------*
*& Include          ZGAMZEY_BONUS_CLASS
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
      bonus.
ENDCLASS.
CLASS local IMPLEMENTATION.
  METHOD get_data.
    SELECT
      t~pers_id
      t~pers_ad
      t~pers_soyad
      t~pers_yil
      FROM zgamzey_pers_t AS t
      INTO CORRESPONDING FIELDS OF TABLE gt_persb.
    go_local->bonus( ).
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
        i_structure_name = 'ZGAMZEY_PERS_BONUS_S'
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
          it_outtab       = gt_persb  " Output Table
          it_fieldcatalog = gt_fieldcat.  " Field Catalog
    ELSE.
      CALL METHOD go_alv_grid->refresh_table_display.
    ENDIF.
  ENDMETHOD.

  METHOD bonus.
    DATA:lv_yıl   TYPE i,
         lv_bonus TYPE i.

    LOOP AT gt_persb INTO gs_persb.
      IF  p_tbutce IS NOT INITIAL.
        lv_yıl = lv_yıl + gs_persb-pers_yil .
      ENDIF.
    ENDLOOP.

    lv_bonus = p_tbutce / lv_yıl.

    LOOP AT gt_persb INTO gs_persb.
      gs_persb-ikramiye_miktari = lv_bonus * gs_persb-pers_yil.
      MODIFY gt_persb FROM gs_persb.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
