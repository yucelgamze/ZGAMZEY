*&---------------------------------------------------------------------*
*& Include          ZGAMZEY_HARD3_LCL
*&---------------------------------------------------------------------*
CLASS local DEFINITION.
  PUBLIC SECTION.
    METHODS:
      get_data,
      call_func,
      rezerve_et,
      rezerve_sil,
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
      t1~matnr,
      t2~maktx,
      t1~rezerve_stok,
      t1~cname,
      t1~cdate,
      t1~ctime
      FROM zrezervestok_t AS t1
      LEFT JOIN makt AS t2
      ON t1~matnr EQ t2~matnr
      INTO TABLE @gt_rezerve
      WHERE spras EQ 'T'.

  ENDMETHOD.

  METHOD call_func.

    CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
      EXPORTING
        input  = gv_matnr
      IMPORTING
        output = gv_matnr.
  ENDMETHOD.

  METHOD rezerve_et.
    go_local->call_func( ).

    SELECT SINGLE SUM( labst )
      FROM mard
      INTO @DATA(lv_labst)
      WHERE matnr EQ @gv_matnr.

    SELECT SINGLE rezerve_stok
      FROM zrezervestok_t
      INTO @DATA(lv_stok)
      WHERE matnr EQ @gv_matnr.

    IF lv_stok IS NOT INITIAL.
      lv_labst = lv_labst - lv_stok.
    ENDIF.

    IF gv_rezerve_stok LE lv_labst.
      gs_stok-matnr = gv_matnr.
      gs_stok-cname = sy-uname.
      gs_stok-cdate = sy-datum.
      gs_stok-ctime = sy-uzeit.
      IF sy-subrc EQ 4.
        gs_stok-rezerve_stok = gv_rezerve_stok.
        INSERT zrezervestok_t FROM gs_stok.
      ELSEIF sy-subrc EQ 0.
        gs_stok-rezerve_stok = lv_stok + gv_rezerve_stok.
        UPDATE zrezervestok_t SET rezerve_stok = gs_stok-rezerve_stok
        WHERE matnr EQ gs_stok-matnr.
      ENDIF.
    ENDIF.

    CLEAR gs_stok.
  ENDMETHOD.

  METHOD rezerve_sil.
    go_local->call_func( ).

    SELECT SINGLE rezerve_stok
      FROM zrezervestok_t
      INTO @DATA(lv_stok)
      WHERE matnr EQ @gv_matnr.

    IF gv_rezerve_stok LE lv_stok.
      gs_stok-matnr = gv_matnr.
      gs_stok-cname = sy-uname.
      gs_stok-cdate = sy-datum.
      gs_stok-ctime = sy-uzeit.
      gs_stok-rezerve_stok = lv_stok - gv_rezerve_stok.

      IF gs_stok-rezerve_stok EQ 0.
        DELETE FROM zrezervestok_t WHERE matnr EQ gs_stok-matnr.
      ELSE.
        UPDATE zrezervestok_t SET rezerve_stok = gs_stok-rezerve_stok
        WHERE matnr EQ gs_stok-matnr.
      ENDIF.
    ELSE.
      MESSAGE i000 DISPLAY LIKE 'W'.
    ENDIF.
    CLEAR gs_stok.
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
      WHEN '&OP'.
        go_local->rezerve_et( ).
        go_local->get_data( ).
        CALL METHOD go_alv_grid->refresh_table_display.
      WHEN'&DEL'.
        go_local->rezerve_sil( ).
        go_local->get_data( ).
        CALL METHOD go_alv_grid->refresh_table_display.
    ENDCASE.
  ENDMETHOD.
  METHOD set_fieldcat.
    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name = 'ZREZERVE_S'
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
          it_outtab       = gt_rezerve " Output Table
          it_fieldcatalog = gt_fieldcat.  " Field Catalog
    ELSE.
      CALL METHOD go_alv_grid->refresh_table_display.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
