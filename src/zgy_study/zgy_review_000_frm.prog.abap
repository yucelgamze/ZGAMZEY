*&---------------------------------------------------------------------*
*& Include          ZEGT_VKT_BLNTO_0O02_FRM
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form DISPLAY_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM display_data .


  gs_layout-edit_mode  = 'X'.
  gs_layout-zebra      = 'X'.
  gs_layout-cwidth_opt = 'X'.

  IF go_alv_grid IS INITIAL.

    PERFORM build_fcat.

    CREATE OBJECT go_alv_grid
      EXPORTING
        i_parent = cl_gui_custom_container=>screen0.

    CREATE OBJECT go_event.
    SET HANDLER go_event->handle_data_changed FOR go_alv_grid.

    CALL METHOD go_alv_grid->register_edit_event
      EXPORTING
        i_event_id = cl_gui_alv_grid=>mc_evt_modified.


    CALL METHOD go_alv_grid->set_table_for_first_display
      EXPORTING
        is_layout       = gs_layout
        i_save          = 'A'
      CHANGING
        it_outtab       = gt_output
        it_fieldcatalog = gt_fcat.

*    CALL METHOD go_alv_grid->set_ready_for_input
*      EXPORTING
*       i_ready_for_input = 1.
  ELSE.

    gs_stable-col = 'X'.
    gs_stable-row = 'X'.

    CALL METHOD go_alv_grid->refresh_table_display
      EXPORTING
        is_stable = gs_stable.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form BUILD_FCAT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM build_fcat .

  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
      i_bypassing_buffer     = 'X'
      i_structure_name       = 'ZEGT_VKT_S010'
    CHANGING
      ct_fieldcat            = gt_fcat
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

* ALV'de sütunları Edit'e açma


  READ TABLE gt_fcat ASSIGNING FIELD-SYMBOL(<lfs_fcat>) WITH KEY fieldname = 'MATNR'.
  IF <lfs_fcat> IS ASSIGNED.
    <lfs_fcat>-edit = abap_true.
    UNASSIGN <lfs_fcat>.
  ENDIF.

  READ TABLE gt_fcat ASSIGNING <lfs_fcat> WITH KEY fieldname = 'VKORG'.
  IF <lfs_fcat> IS ASSIGNED.
    <lfs_fcat>-edit = abap_true.
    UNASSIGN <lfs_fcat>.
  ENDIF.

  READ TABLE gt_fcat ASSIGNING <lfs_fcat> WITH KEY fieldname = 'VTWEG'.
  IF <lfs_fcat> IS ASSIGNED.
    <lfs_fcat>-edit = abap_true.
    UNASSIGN <lfs_fcat>.
  ENDIF.

  READ TABLE gt_fcat ASSIGNING <lfs_fcat> WITH KEY fieldname = 'QUANTITY'.
  IF <lfs_fcat> IS ASSIGNED.
    <lfs_fcat>-edit = abap_true.
    UNASSIGN <lfs_fcat>.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_SALES_ORDER
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM create_sales_order .

  DATA: ls_header_in   TYPE          bapisdhd1,
        ls_header_inx  TYPE          bapisdhd1x,
        lv_salesorder  TYPE          vbeln_va,
        lt_return      TYPE TABLE OF bapiret2,
        ls_return      TYPE          bapiret2,
        lt_item_in     TYPE TABLE OF bapisditm,
        ls_item_in     TYPE          bapisditm,
        lt_item_inx    TYPE TABLE OF bapisditmx,
        ls_item_inx    TYPE          bapisditmx,
        lt_partners    TYPE TABLE OF bapiparnr,
        ls_partners    TYPE          bapiparnr,
        lt_sched_in    TYPE TABLE OF bapischdl,
        ls_sched_in    TYPE          bapischdl,
        lt_sched_inx   TYPE TABLE OF bapischdlx,
        ls_sched_inx   TYPE          bapischdlx,
        lv_item_number TYPE          posnr.

  REFRESH: gt_msg.


  go_alv_grid->get_selected_rows(
   IMPORTING
     et_index_rows = DATA(lt_selected_rows) ).

  LOOP AT lt_selected_rows INTO DATA(ls_selected_rows).
    READ TABLE gt_output INTO gs_output INDEX ls_selected_rows.
    IF sy-subrc EQ 0.
      ls_header_in-doc_type   = 'ZDEN'.
      ls_header_in-division   = 'Z1'.
      ls_header_in-sales_org  = gs_output-vkorg.
      ls_header_in-distr_chan = gs_output-vtweg.

      ls_header_inx-doc_type   = abap_true.
      ls_header_inx-division   = abap_true.
      ls_header_inx-sales_org  = abap_true.
      ls_header_inx-distr_chan = abap_true.

      ADD 10 TO lv_item_number.
      ls_item_in-itm_number = lv_item_number.
      ls_item_in-material   = gs_output-matnr.
      ls_item_in-target_qty = gs_output-quantity.
      ls_item_in-target_qu  = 'ST'.
      APPEND ls_item_in TO lt_item_in.

      ls_item_inx-itm_number = lv_item_number.
      ls_item_inx-updateflag = 'I'.
      ls_item_inx-material   = abap_true.
      ls_item_inx-target_qty = abap_true.
      ls_item_inx-target_qu  = abap_true.
      APPEND ls_item_inx TO lt_item_inx.

      ls_sched_in-itm_number = lv_item_number.
      ls_sched_in-sched_line = '0001'.
      ls_sched_in-req_date   = sy-datum.
      ls_sched_in-req_qty    = ls_item_in-target_qty.
      APPEND ls_sched_in TO lt_sched_in.


      ls_sched_inx-itm_number = lv_item_number.
      ls_sched_inx-updateflag = 'I'.
      ls_sched_inx-sched_line = '0001'.
      ls_sched_inx-req_date   = abap_true.
      ls_sched_inx-req_qty    = abap_true.
      APPEND ls_sched_inx TO lt_sched_inx.

    ENDIF.
  ENDLOOP.

  ls_partners-partn_role = 'AG'.
  ls_partners-partn_numb = '0001000061'.
  APPEND ls_partners TO lt_partners.

  ls_partners-partn_role = 'WE'.
*  ls_partners-partn_numb = '0001000061'.
  APPEND ls_partners TO lt_partners.

  CALL FUNCTION 'BAPI_SALESORDER_CREATEFROMDAT2'
    EXPORTING
      order_header_in     = ls_header_in
      order_header_inx    = ls_header_inx
    IMPORTING
      salesdocument       = lv_salesorder
    TABLES
      return              = lt_return
      order_items_in      = lt_item_in
      order_items_inx     = lt_item_inx
      order_partners      = lt_partners
      order_schedules_in  = lt_sched_in
      order_schedules_inx = lt_sched_inx.

  LOOP AT lt_return INTO ls_return WHERE type CA 'EAX'.

    gs_msg-mess = ls_return-message.
    gs_msg-icon = icon_red_light. "kırmızı ışıklı icon
    APPEND gs_msg TO gt_msg.

  ENDLOOP.
  IF sy-subrc EQ 0.
    gs_output-icon = icon_red_light.
*    MODIFY gt_output FROM gs_output.
    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
  ELSE.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = abap_true.
    gs_msg-mess       = TEXT-001.
    gs_msg-icon       = icon_green_light. "yeşil ışıklı icon
    gs_msg-doc_number = lv_salesorder.
    APPEND gs_msg TO gt_msg.

    gs_output-icon  = icon_green_light.
    gs_output-vbeln = lv_salesorder.
*    MODIFY gt_output FROM gs_output.
  ENDIF.

  PERFORM display_messages USING gt_msg.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_MESSAGES
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*      -->P_GT_MSG  text
*&---------------------------------------------------------------------*
FORM display_messages  USING    pt_messages.
  DATA:
    lr_messages TYPE REF TO cl_salv_table,
    lr_columns  TYPE REF TO cl_salv_columns_table,
    lr_column   TYPE REF TO cl_salv_column,
    lr_error    TYPE REF TO cx_salv_error,
    lv_message  TYPE string.

  CHECK pt_messages IS NOT INITIAL.

  TRY.
      cl_salv_table=>factory(
        IMPORTING
          r_salv_table = lr_messages
        CHANGING
          t_table      = pt_messages ).
    CATCH cx_salv_msg INTO lr_error.
      lv_message = lr_error->if_message~get_text( ).
      MESSAGE lv_message TYPE 'E'.
  ENDTRY.

  "Columns optimized
  lr_columns = lr_messages->get_columns( ).
  lr_columns->set_optimize( abap_true ).

  lr_column = lr_columns->get_column( 'ICON' ).
  lr_column->set_long_text( 'Durum' ).

  lr_column = lr_columns->get_column( 'MESS' ).
  lr_column->set_long_text( 'Mesaj' ).

  lr_column = lr_columns->get_column( 'DOC_NUMBER' ).
  lr_column->set_long_text( 'Belge Numarası' ).

  lr_messages->set_screen_popup(
    start_column = 1
    end_column   = 80
    start_line   = 1
    end_line     = 15 ).

  lr_messages->display( ).
ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_DATA_CHANGED
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*      -->P_ER_DATA_CHANGED  text
*&---------------------------------------------------------------------*
FORM handle_data_changed  USING er_data_changed TYPE REF TO cl_alv_changed_data_protocol.
  DATA: ls_good   TYPE lvc_s_modi.
  DATA: ls_stable TYPE lvc_s_stbl.

  FIELD-SYMBOLS: <lfs_output> LIKE LINE OF gt_output.

  LOOP AT er_data_changed->mt_good_cells INTO ls_good.
    READ TABLE gt_output ASSIGNING <lfs_output> INDEX ls_good-row_id.
    IF sy-subrc EQ 0.
      <lfs_output>-icon = icon_yellow_light.

      CASE ls_good-fieldname.
        WHEN 'MATNR'.
          <lfs_output>-matnr = ls_good-value.
          SELECT SINGLE matnr
          FROM mara
          INTO @DATA(ls_mara)
          WHERE matnr EQ @<lfs_output>-matnr.
          IF sy-subrc NE 0.
            MESSAGE 'Malzeme bulunamadı!' TYPE 'I' DISPLAY LIKE 'E'.
            <lfs_output>-icon = icon_red_light.
          ELSE.
            <lfs_output>-icon = icon_green_light.
          ENDIF.

        WHEN 'VKORG'.
          <lfs_output>-vkorg = ls_good-value.
          SELECT SINGLE matnr,vkorg
           FROM mvke
           INTO @DATA(ls_mvke)
           WHERE matnr EQ @<lfs_output>-matnr
             AND vkorg EQ @<lfs_output>-vkorg.
          IF sy-subrc NE 0.
            MESSAGE 'Malzeme X satış organizasyonunda bulunmuyor!' TYPE 'I' DISPLAY LIKE 'E'.
            <lfs_output>-icon = icon_red_light.
          ELSE.
            <lfs_output>-icon = icon_green_light.
          ENDIF.
        WHEN 'VTWEG'.
          <lfs_output>-vtweg = ls_good-value.
          SELECT SINGLE matnr,vkorg,vtweg
         FROM mvke
         INTO @DATA(ls_mvke2)
         WHERE matnr EQ @<lfs_output>-matnr
           AND vkorg EQ @<lfs_output>-vkorg
           AND vtweg EQ @<lfs_output>-vtweg.
          IF sy-subrc NE 0.
            MESSAGE 'Malzeme X satış organiasyonu ve Y dağıtım kanalında bulunmuyor!' TYPE 'I' DISPLAY LIKE 'E'.
            <lfs_output>-icon = icon_red_light.
          ELSE.
            <lfs_output>-icon = icon_green_light.
          ENDIF.
        WHEN 'QUANTITY'.
          <lfs_output>-quantity = ls_good-value.

          IF <lfs_output>-quantity LT 0.
            MESSAGE: 'Miktar girmelisiniz!' TYPE 'I' DISPLAY LIKE 'E'.
            <lfs_output>-icon = icon_red_light.
          ELSE.
            <lfs_output>-icon = icon_green_light.
          ENDIF.
      ENDCASE.
      CALL METHOD go_alv_grid->refresh_table_display.
    ENDIF.
  ENDLOOP.



ENDFORM.
