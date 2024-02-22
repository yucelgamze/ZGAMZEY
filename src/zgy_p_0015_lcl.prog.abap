*&---------------------------------------------------------------------*
*& Include          ZGY_P_LCL
*&---------------------------------------------------------------------*
CLASS lcl_class DEFINITION.
  PUBLIC SECTION.
    METHODS:
*      function_matnr IMPORTING iv_matnr TYPE matnr
*                     EXPORTING ev_exist TYPE char1,
*      control_matnr,
*      function_vkorg IMPORTING iv_matnr TYPE matnr
*                               iv_vkorg TYPE vkorg
*                     EXPORTING ev_exist TYPE char1,
*      control_vkorg,
*      function_vtweg IMPORTING iv_matnr TYPE matnr
*                               iv_vkorg TYPE vkorg
*                               iv_vtweg TYPE vtweg
*                     EXPORTING ev_exist TYPE char1,
*      control_vtweg,
      handle_data_changed
            FOR EVENT data_changed OF cl_gui_alv_grid   "DATA_CHANGED
        IMPORTING
            er_data_changed
            e_onf4
            e_onf4_before
            e_onf4_after
            e_ucomm,
      create,
      disable_edit,
      call_screen,
      pbo_0100,
      pai_0100 IMPORTING iv_ucomm TYPE sy-ucomm,
      call_popup_screen,
      pbo_0200,
      pai_0200 IMPORTING iv_ucomm TYPE sy-ucomm,
      set_fcat,
      set_fcat2,
      set_layout,
      display_alv,
      display_alv2.
ENDCLASS.
CLASS lcl_class IMPLEMENTATION.

*  METHOD function_matnr.
*    CALL FUNCTION 'ZGY_FM_0002'
*      EXPORTING
*        iv_matnr = iv_matnr
*      IMPORTING
*        ev_exist = ev_exist.
*  ENDMETHOD.
*
*  METHOD control_matnr.
*    go_local->function_matnr(
*      EXPORTING
*        iv_matnr = gv_matnr
*      IMPORTING
*        ev_exist = gv_exist1
*    ).
*  ENDMETHOD.
*
*  METHOD function_vkorg.
*    CALL FUNCTION 'ZGY_FM_0003'
*      EXPORTING
*        iv_matnr = iv_matnr
*        iv_vkorg = iv_vkorg
*      IMPORTING
*        ev_exist = ev_exist.
*
*  ENDMETHOD.
*
*  METHOD control_vkorg.
*    go_local->function_vkorg(
*      EXPORTING
*        iv_matnr = gv_matnr
*        iv_vkorg = gv_vkorg
*      IMPORTING
*        ev_exist = gv_exist2
*    ).
*  ENDMETHOD.
*
*  METHOD function_vtweg.
*    CALL FUNCTION 'ZGY_FM_0004'
*      EXPORTING
*        iv_matnr = iv_matnr
*        iv_vkorg = iv_vkorg
*        iv_vtweg = iv_vtweg
*      IMPORTING
*        ev_exist = ev_exist.
*
*  ENDMETHOD.
*
*  METHOD control_vtweg.
*    go_local->function_vtweg(
*      EXPORTING
*        iv_matnr = gv_matnr
*        iv_vkorg = gv_vkorg
*        iv_vtweg = gv_vtweg
*      IMPORTING
*        ev_exist = gv_exist3
*    ).
*  ENDMETHOD.

  METHOD  handle_data_changed.

    DATA:ls_modi TYPE lvc_s_modi.

    LOOP AT er_data_changed->mt_good_cells INTO ls_modi.
      READ TABLE gt_alv ASSIGNING <gfs_alv> INDEX ls_modi-row_id.
      IF sy-subrc EQ 0.
        <gfs_alv>-durum = '@09@'.

        CASE ls_modi-fieldname.
          WHEN 'MATNR'.
            <gfs_alv>-matnr = ls_modi-value.
            gv_matnr = ls_modi-value.
*            go_local->control_matnr( ).
*            IF gv_exist1 EQ abap_true.
*              <gfs_alv>-durum = '@08@'.
*            ELSE.
*              MESSAGE i004 DISPLAY LIKE 'E'.
*              <gfs_alv>-durum = '@0A@'.
*            ENDIF.
          WHEN 'VKORG'.
            <gfs_alv>-vkorg = ls_modi-value.
            gv_vkorg = ls_modi-value.
*            go_local->control_vkorg( ).
*            IF gv_exist2 EQ abap_true.
*              <gfs_alv>-durum = '@08@'.
*            ELSE.
*              MESSAGE i005 WITH <gfs_alv>-vkorg DISPLAY LIKE 'E'.
*              <gfs_alv>-durum = '@0A@'.
*            ENDIF.
          WHEN 'VTWEG'.
            <gfs_alv>-vtweg = ls_modi-value.
            gv_vtweg = ls_modi-value.
*            go_local->control_vtweg( ).
*            IF gv_exist3 EQ abap_true.
*              <gfs_alv>-durum = '@08@'.
*            ELSE.
*              MESSAGE i005 WITH <gfs_alv>-vkorg <gfs_alv>-vtweg DISPLAY LIKE 'E'.
*              <gfs_alv>-durum = '@0A@'.
*            ENDIF.
          WHEN 'MIKTAR'.
            <gfs_alv>-miktar = ls_modi-value.
            gv_miktar = ls_modi-value.
        ENDCASE.
      ENDIF.
    ENDLOOP.

    IF gv_matnr IS NOT INITIAL AND gv_vkorg IS NOT INITIAL AND gv_vtweg IS NOT INITIAL.

      SELECT SINGLE matnr
      FROM mara
      WHERE matnr EQ @gv_matnr
      INTO @DATA(lv_mara).

      IF sy-subrc IS INITIAL.
        READ TABLE gt_alv ASSIGNING <gfs_alv> WITH KEY matnr = lv_mara.
        IF <gfs_alv> IS ASSIGNED.
          <gfs_alv>-durum = '@08@'.
        ENDIF.
        UNASSIGN <gfs_alv>.
      ELSE.
        MESSAGE i004 DISPLAY LIKE 'E'.
        READ TABLE gt_alv ASSIGNING <gfs_alv> WITH KEY matnr = lv_mara.
        IF <gfs_alv> IS ASSIGNED.
          <gfs_alv>-durum = '@0A@'.
        ENDIF.
        UNASSIGN <gfs_alv>.
      ENDIF.

    ENDIF.

    IF gv_matnr IS NOT INITIAL AND gv_vkorg IS NOT INITIAL AND gv_vtweg IS NOT INITIAL.

      SELECT SINGLE matnr,vkorg
      FROM mvke
      WHERE matnr EQ @gv_matnr
      AND   vkorg EQ @gv_vkorg
      INTO  @DATA(ls_mvke).

      IF sy-subrc IS INITIAL.
        READ TABLE gt_alv ASSIGNING <gfs_alv> WITH KEY matnr = ls_mvke-matnr vkorg = ls_mvke-vkorg.
        IF <gfs_alv> IS ASSIGNED.
          <gfs_alv>-durum = '@08@'.
        ENDIF.
        UNASSIGN <gfs_alv>.
      ELSE.
        MESSAGE i005 WITH gv_vkorg DISPLAY LIKE 'E'.
        READ TABLE gt_alv ASSIGNING <gfs_alv> WITH KEY matnr = ls_mvke-matnr vkorg = ls_mvke-vkorg.
        IF <gfs_alv> IS ASSIGNED.
          <gfs_alv>-durum = '@0A@'.
        ENDIF.
        UNASSIGN <gfs_alv>.
      ENDIF.

    ENDIF.

    IF gv_matnr IS NOT INITIAL AND gv_vkorg IS NOT INITIAL AND gv_vtweg IS NOT INITIAL.

      SELECT SINGLE matnr,vkorg,vtweg
      FROM mvke
      WHERE matnr EQ @gv_matnr
      AND   vkorg EQ @gv_vkorg
      AND   vtweg EQ @gv_vtweg
      INTO  @DATA(ls_mvke2).

      IF sy-subrc IS INITIAL.
        READ TABLE gt_alv ASSIGNING <gfs_alv> WITH KEY  matnr = ls_mvke-matnr vkorg = ls_mvke2-vkorg vtweg = ls_mvke2-vtweg.
        IF <gfs_alv> IS ASSIGNED.
          <gfs_alv>-durum = '@08@'.
        ENDIF.
        UNASSIGN <gfs_alv>.
      ELSE.
        MESSAGE i006 WITH gv_vkorg gv_vtweg DISPLAY LIKE 'E'.
        READ TABLE gt_alv ASSIGNING <gfs_alv> WITH KEY matnr = ls_mvke-matnr vkorg = ls_mvke2-vkorg vtweg = ls_mvke2-vtweg.
        IF <gfs_alv> IS ASSIGNED.
          <gfs_alv>-durum = '@0A@'.
        ENDIF.
        UNASSIGN <gfs_alv>.
      ENDIF.

    ENDIF.

    IF gv_miktar LT 0 AND gv_matnr IS NOT INITIAL AND gv_vkorg IS NOT INITIAL AND gv_vtweg IS NOT INITIAL.
      MESSAGE i009 DISPLAY LIKE 'E'.
    ENDIF.

    CALL METHOD go_alv_grid->refresh_table_display( ).
  ENDMETHOD.

  METHOD create.

    DATA:ls_order_header_in     TYPE bapisdhd1,
         ls_order_header_inx    TYPE bapisdhd1x,
         lv_salesdocument       TYPE vbeln_va,
         lt_return              TYPE TABLE OF bapiret2,
         ls_return              TYPE bapiret2,
         lt_order_items_in      TYPE TABLE OF bapisditm,
         ls_order_items_in      TYPE bapisditm,
         lt_order_items_inx     TYPE TABLE OF bapisditmx,
         ls_order_items_inx     TYPE bapisditmx,
         lt_order_partners      TYPE TABLE OF bapiparnr,
         ls_order_partners      TYPE bapiparnr,
         lt_order_schedules_in  TYPE TABLE OF bapischdl,
         ls_order_schedules_in  TYPE bapischdl,
         lt_order_schedules_inx TYPE TABLE OF bapischdlx,
         ls_order_schedules_inx TYPE bapischdlx,
         lv_item_number         TYPE posnr.

    DATA:lt_index_rows TYPE lvc_t_row.

    CALL METHOD go_alv_grid->get_selected_rows
      IMPORTING
        et_index_rows = lt_index_rows.  " Indexes of Selected Rows .

    IF lt_index_rows IS INITIAL.
      MESSAGE i010 DISPLAY LIKE 'E'.
    ELSE.

      LOOP AT lt_index_rows ASSIGNING FIELD-SYMBOL(<lfs_index_rows>).
        READ TABLE gt_alv INTO gs_alv INDEX <lfs_index_rows>-index.
        IF sy-subrc IS INITIAL.
          IF gs_alv-durum EQ '@0A@' OR gs_alv-durum EQ '@09@'.
            MESSAGE i007 DISPLAY LIKE 'E'.

          ELSE.
            ls_order_header_in = VALUE #(  doc_type   = 'ZDEN'
                                           division   = 'Z1'
                                           sales_org  = gs_alv-vkorg
                                           distr_chan = gs_alv-vtweg ).

            ls_order_header_inx = VALUE #( doc_type   =  abap_true
                                           division   =  abap_true
                                           sales_org  =  abap_true
                                           distr_chan =  abap_true ).

            lv_item_number = lv_item_number + 10.
            ls_order_items_in = VALUE #( itm_number   = lv_item_number
                                         material     = gs_alv-matnr
                                         target_qty   = gs_alv-miktar
                                         target_qu    = 'ST' ).
            APPEND ls_order_items_in TO lt_order_items_in.

            ls_order_items_inx = VALUE #( itm_number  = lv_item_number
                                          material    = abap_true
                                          target_qty  = abap_true
                                          target_qu   = abap_true
                                          updateflag  = 'I' ).
            APPEND ls_order_items_inx TO lt_order_items_inx.
            ls_order_schedules_in = VALUE #( itm_number = lv_item_number
                                             sched_line = '0001'
                                             req_date   = sy-datum
                                             req_qty    = ls_order_items_in-target_qty ).
            APPEND ls_order_schedules_in TO lt_order_schedules_in.

            ls_order_schedules_inx = VALUE #( itm_number  = lv_item_number
                                              sched_line  = '0001'
                                              req_date    = abap_true
                                              req_qty     = abap_true
                                              updateflag  = 'I'  ).
            APPEND ls_order_schedules_inx TO lt_order_schedules_inx.
          ENDIF.


          ls_order_partners = VALUE #( partn_role = 'AG'
                                       partn_numb = '0001000061' ).
          APPEND ls_order_partners TO lt_order_partners.
          ls_order_partners = VALUE #( BASE ls_order_partners
                                        partn_role = 'WE'
                                        partn_numb = '0001000061').
          APPEND ls_order_partners TO lt_order_partners.


          gs_bapi = CORRESPONDING #( gs_alv ).
          APPEND gs_bapi TO gt_bapi.

          CALL FUNCTION 'BAPI_SALESORDER_CREATEFROMDAT2'
            EXPORTING
              order_header_in     = ls_order_header_in
              order_header_inx    = ls_order_header_inx
            IMPORTING
              salesdocument       = lv_salesdocument
            TABLES
              return              = lt_return
              order_items_in      = lt_order_items_in
              order_items_inx     = lt_order_items_inx
              order_partners      = lt_order_partners
              order_schedules_in  = lt_order_schedules_in
              order_schedules_inx = lt_order_schedules_inx.

          READ TABLE lt_return INTO ls_return WITH KEY type = 'S'.
          IF sy-subrc IS INITIAL.
            CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
              EXPORTING
                wait = 'X'.
          ELSE.
            CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
            LOOP AT gt_bapi ASSIGNING FIELD-SYMBOL(<lfs_bapi>).
              <lfs_bapi>-durum = '@0A@'.
            ENDLOOP.
          ENDIF.

          LOOP AT gt_bapi ASSIGNING <lfs_bapi>.
            LOOP AT lt_return INTO ls_return.

              <lfs_bapi> = VALUE #( BASE <lfs_bapi>
                                    type    = ls_return-type
                                    id      = ls_return-id
                                    znumber = ls_return-number
                                    message = ls_return-message
                                    cname   = sy-uname
                                    cdate   = sy-datum
                                    ctime   = sy-uzeit ).
            ENDLOOP.
          ENDLOOP.

        ENDIF.
      ENDLOOP.
    ENDIF.

    MODIFY zgy_t_0025 FROM TABLE gt_bapi.
    go_local->call_popup_screen( ).

  ENDMETHOD.

  METHOD disable_edit.
    DATA:lt_styl TYPE TABLE OF lvc_s_styl,
         ls_styl TYPE lvc_s_styl.

    LOOP AT gt_alv ASSIGNING FIELD-SYMBOL(<fs>).
      ls_styl = VALUE #( BASE ls_styl
                         style = cl_gui_alv_grid=>mc_style_disabled
                         fieldname = 'MATNR' ).
      INSERT ls_styl INTO TABLE lt_styl.

      ls_styl = VALUE #( BASE ls_styl
                         style = cl_gui_alv_grid=>mc_style_disabled
                         fieldname = 'VKORG' ).
      INSERT ls_styl INTO TABLE lt_styl.

      ls_styl = VALUE #( BASE ls_styl
                         style = cl_gui_alv_grid=>mc_style_disabled
                         fieldname = 'VTWEG' ).
      INSERT ls_styl INTO TABLE lt_styl.

      ls_styl = VALUE #( BASE ls_styl
                         style = cl_gui_alv_grid=>mc_style_disabled
                         fieldname = 'MIKTAR' ).
      INSERT ls_styl INTO TABLE lt_styl.

      CLEAR:<fs>-style.
      INSERT LINES OF lt_styl INTO TABLE <fs>-style.
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
      WHEN '&CREATE'.
        go_local->create( ).
    ENDCASE.
  ENDMETHOD.

  METHOD call_popup_screen.
    CALL SCREEN 0200 STARTING AT    80 80
                     ENDING AT     190 100.
  ENDMETHOD.

  METHOD pbo_0200.
    SET PF-STATUS '0200'.
    SET TITLEBAR '0200'.
  ENDMETHOD.

  METHOD pai_0200.
    CASE iv_ucomm.
      WHEN '&OK'.
        SET SCREEN 0.
      WHEN '&CANCEL'.
        SET SCREEN 0.
    ENDCASE.
  ENDMETHOD.

  METHOD set_fcat.
    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name = 'ZGY_S_0031'
      CHANGING
        ct_fieldcat      = gt_fcat.

    LOOP AT gt_fcat ASSIGNING FIELD-SYMBOL(<lfs_fcat>).
      CASE <lfs_fcat>-fieldname.
        WHEN 'MATNR'.
          <lfs_fcat>-edit = abap_true.
        WHEN 'VKORG'.
          <lfs_fcat>-edit = abap_true.
        WHEN 'VTWEG'.
          <lfs_fcat>-edit = abap_true.
        WHEN 'MIKTAR'.
          <lfs_fcat>-edit = abap_true.
      ENDCASE.
    ENDLOOP.
  ENDMETHOD.
  METHOD set_layout.
    gs_layout = VALUE #( zebra      = abap_true
                       cwidth_opt = abap_true
                       col_opt    = abap_true
                       sel_mode   = 'A'
                       info_fname = 'COLOR'
                       stylefname = 'STYLE' ).
  ENDMETHOD.

  METHOD set_fcat2.
    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name = 'ZGY_T_0025'
      CHANGING
        ct_fieldcat      = gt_fcat2.
  ENDMETHOD.

  METHOD display_alv.
    IF go_alv_grid IS INITIAL.
      CREATE OBJECT go_container
        EXPORTING
          container_name = 'CC_ALV'.   " Name of the Screen CustCtrl Name to Link Container To
      CREATE OBJECT go_alv_grid
        EXPORTING
*         i_parent = go_container.  " Parent Container
          i_parent = cl_gui_custom_container=>screen0.  " Parent Container

      SET HANDLER go_local->handle_data_changed FOR go_alv_grid.
      CALL METHOD go_alv_grid->register_edit_event
        EXPORTING
          i_event_id = cl_gui_alv_grid=>mc_evt_modified.  " Event ID

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

  METHOD display_alv2.
    IF go_alv_grid2 IS INITIAL.
      CREATE OBJECT go_container
        EXPORTING
          container_name = 'CC_ALV'.   " Name of the Screen CustCtrl Name to Link Container To
      CREATE OBJECT go_alv_grid2
        EXPORTING
          i_parent = go_container.    " Parent Container

      CALL METHOD go_alv_grid2->set_table_for_first_display
        EXPORTING
          is_layout       = gs_layout   " Layout
        CHANGING
          it_outtab       = gt_bapi   " Output Table
          it_fieldcatalog = gt_fcat2.   " Field Catalog

    ELSE.
      CALL METHOD go_alv_grid2->refresh_table_display.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
