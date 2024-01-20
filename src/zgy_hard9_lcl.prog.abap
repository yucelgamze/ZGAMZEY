*&---------------------------------------------------------------------*
*& Include          ZGAMZEY_HARD9_LCL
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

    SELECT
      db_t1~ana_malzeme,
      MIN( CAST( db_t2~stok_miktari AS FLTP ) / CAST( db_t1~alt_malzeme_miktar AS FLTP ) ) AS max_adet
      FROM zgamzey_urun_t AS db_t1
      LEFT JOIN zgamzey_stok_t AS db_t2
      ON db_t1~alt_malzeme EQ db_t2~alt_malzeme
      INTO TABLE @DATA(lt_max)
      WHERE db_t1~alt_malzeme GT 0
      GROUP BY db_t1~ana_malzeme.

    DATA:lv_adet TYPE p DECIMALS 1.
    LOOP AT lt_max INTO DATA(ls_max).

      lv_adet = ls_max-max_adet.
      lv_adet = floor( lv_adet ).
      gs_alv-ana_malzeme = ls_max-ana_malzeme.
      gs_alv-uretilebilecek_miktar = lv_adet.
      APPEND gs_alv TO gt_alv.

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
        i_structure_name = 'ZGAMZEY_URUN_AGAC_S'
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
          it_outtab       = gt_alv " Output Table
          it_fieldcatalog = gt_fieldcat.  " Field Catalog
    ELSE.
      CALL METHOD go_alv_grid->refresh_table_display.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
