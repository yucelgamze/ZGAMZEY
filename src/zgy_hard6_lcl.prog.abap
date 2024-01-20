*&---------------------------------------------------------------------*
*& Include          ZGAMZEY_HARD6_LCL
*&---------------------------------------------------------------------*
CLASS local DEFINITION.
  PUBLIC SECTION.
    METHODS:
      get_data,
      call_func_number_get_next,
      call_screen,
      order,
      delete,
      pbo_0100,
      pai_0100 IMPORTING iv_ucomm TYPE sy-ucomm,
      set_fieldcat,
      set_layout,
      display_alv.
ENDCLASS.
CLASS local IMPLEMENTATION.
  METHOD get_data.
    SELECT
      db_t~vbeln,
      db_t~matnr,
      db_t~labst,
      db_t~cname,
      db_t~cdate,
      db_t~ctime
      FROM zgamzey_sipari_t AS db_t
      INTO CORRESPONDING FIELDS OF TABLE @gt_siparis.

"select sorgusunda database table'dan kolonlar çekilecek db structure'ın internal table'ı doldurulur.

  ENDMETHOD.

  METHOD call_func_number_get_next.
    CALL FUNCTION 'NUMBER_GET_NEXT'
      EXPORTING
        nr_range_nr = '01'
        object      = 'ZGY_NRO' "Aralık çakışmasın diye key bazlı çoklu key üretimi snro
      IMPORTING
        number      = gv_vbeln.
  ENDMETHOD.

  METHOD order.
    CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
      EXPORTING
        input  = gv_matnr
      IMPORTING
        output = gv_matnr.

    "girien malzeme numarası mara da mevcut mu select sorgusu
    SELECT SINGLE matnr
      FROM mara
      INTO @DATA(lv_matnr)
      WHERE matnr EQ @gv_matnr.

    IF sy-subrc EQ 0 AND gv_matnr IS NOT INITIAL AND gv_labst IS NOT INITIAL..
      go_local->call_func_number_get_next( ).

      gs_sip-vbeln = gv_vbeln.
      gs_sip-matnr = gv_matnr.
      gs_sip-labst = gv_labst.
      gs_sip-cname = sy-uname.
      gs_sip-cdate = sy-datum.
      gs_sip-ctime = sy-uzeit.

      INSERT zgamzey_sipari_t FROM gs_sip.
    ENDIF.
  ENDMETHOD.

  METHOD delete.
    CLEAR:gv_vbeln,
          gv_matnr,
          gv_labst.
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
      WHEN '&ORDER'.
        go_local->order( ).
        go_local->get_data( ).
        CALL METHOD go_alv_grid->refresh_table_display.
      WHEN '&DEL'.
        go_local->delete( ).
    ENDCASE.
  ENDMETHOD.

  METHOD set_fieldcat.
    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name = 'ZGAMZEY_SIPARIS_S'
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
          it_outtab       = gt_siparis " Output Table
          it_fieldcatalog = gt_fieldcat.  " Field Catalog
    ELSE.
      CALL METHOD go_alv_grid->refresh_table_display.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
