*&---------------------------------------------------------------------*
*& Include          ZGAMZEY_MEDIUM_STOKR_CLASS
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

*    DATA:ls_selopt TYPE selopt,
*         lt_stok   TYPE TABLE OF zgamzey_stok_s.

    SELECT
      t1~matnr,
      t2~maktx,
      t3~labst,
      t3~werks,
      t4~name1,
      t3~lgort,
      t5~lgobe
      FROM mara AS t1
      LEFT JOIN makt AS t2
      ON t1~matnr EQ t2~matnr
      LEFT JOIN mard AS t3
      ON t1~matnr EQ t3~matnr
      LEFT JOIN t001w AS t4
      ON t3~werks EQ t4~werks
      LEFT JOIN t001l AS t5
      ON t3~lgort EQ t5~lgort AND t3~werks EQ t5~werks
      WHERE  t2~spras EQ @p_spras and t1~matnr in @so_matnr
      INTO CORRESPONDING FIELDS OF TABLE @gt_stok.

*      LOOP AT so_matnr INTO ls_selopt.
*        gv_matnr = ls_selopt-low.
*
*        READ TABLE lt_stok INTO gs_stok WITH KEY matnr = gv_matnr.
*        IF gs_stok IS NOT INITIAL.
*          APPEND gs_stok TO gt_stok.
*          CLEAR gs_stok.
*        ENDIF.
*      ENDLOOP.
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
          i_structure_name = 'ZGAMZEY_STOK_S'
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
*           i_parent = cl_gui_container=>screen0.
            i_parent = go_container.   " Parent Container
        CALL METHOD go_alv_grid->set_table_for_first_display
          EXPORTING
            is_layout       = gs_layout   " Layout
          CHANGING
            it_outtab       = gt_stok   " Output Table
            it_fieldcatalog = gt_fieldcat.  " Field Catalog
      ELSE.
        CALL METHOD go_alv_grid->refresh_table_display.
      ENDIF.
    ENDMETHOD.

ENDCLASS.
