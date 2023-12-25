*&---------------------------------------------------------------------*
*& Include          ZGY_VBAK_LCL
*&---------------------------------------------------------------------*
CLASS lcl_class DEFINITION.
  PUBLIC SECTION.
    METHODS:
      get_data,
      save_data,
      call_screen,
      pbo_0100,
      pai_0100 IMPORTING iv_ucomm TYPE sy-ucomm,
      set_fcat,
      set_layout,
      display_alv,
      handle_data_changed FOR EVENT data_changed OF cl_gui_alv_grid
        IMPORTING
            er_data_changed.
ENDCLASS.
CLASS lcl_class IMPLEMENTATION.
  METHOD get_data.

    SELECT
    vbak~vbeln,
    vbak~erdat,
    vbak~erzet,
    vbak~ernam,
    vbak~audat,
    vbak~vbtyp,
    vbak~auart,
    vbak~netwr,
    vbak~waerk,
    vbak~vkorg,
    vbak~vtweg,
    vbak~spart,
    vbak~vkgrp,
    vbak~vkbur,
    vbak~ktext
    FROM vbak
    WHERE vbak~audat IN  @so_audat  AND
          vbak~vbtyp IN  @so_vbtyp  AND
          vbak~auart IN  @so_auart
    INTO CORRESPONDING FIELDS OF TABLE @gt_alv.

  ENDMETHOD.
  METHOD save_data.
    DATA:ls_vbak TYPE zgy_t_vbak.
    DATA:lt_index_row TYPE lvc_t_row.

    CALL METHOD go_alv_grid->get_selected_rows
      IMPORTING
        et_index_rows = lt_index_row.  " Indexes of Selected Rows

    IF lt_index_row IS INITIAL.
      MESSAGE |Kayıt için satır seçiniz!| TYPE 'I' DISPLAY LIKE 'W'.
    ELSE.
      LOOP AT lt_index_row ASSIGNING FIELD-SYMBOL(<gfs_index_row>) .
        READ TABLE gt_alv ASSIGNING FIELD-SYMBOL(<gfs_alv>) INDEX <gfs_index_row>-index.
      ENDLOOP.

      IF <gfs_alv>-ktext IS NOT INITIAL.
        MOVE-CORRESPONDING <gfs_alv> TO ls_vbak.
        MODIFY zgy_t_vbak FROM ls_vbak.
      ENDIF.

      IF sy-subrc EQ 0.
        COMMIT WORK.
        MESSAGE |EDIT kolonu ile birlikte ilgili satır database table'a kaydedilmiştir!| TYPE 'I' DISPLAY LIKE 'S'.
      ELSE.
        ROLLBACK WORK.
        MESSAGE |HATA!| TYPE 'I' DISPLAY LIKE 'W'.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD handle_data_changed.

    DATA:ls_modi TYPE lvc_s_modi.

    LOOP AT er_data_changed->mt_good_cells INTO ls_modi.

      READ TABLE gt_alv ASSIGNING FIELD-SYMBOL(<gfs_alv>) INDEX ls_modi-row_id.
      IF sy-subrc EQ 0.
        CASE ls_modi-fieldname .
          WHEN  'KTEXT'.
            <gfs_alv>-ktext = ls_modi-value.
        ENDCASE.
      ENDIF.
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
      WHEN '&SAVE'.
        go_local->save_data( ).
    ENDCASE.
  ENDMETHOD.

  METHOD set_fcat.
    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name = 'ZGY_T_VBAK'
      CHANGING
        ct_fieldcat      = gt_fcat.


    READ TABLE gt_fcat ASSIGNING FIELD-SYMBOL(<gfs_fcat>) WITH KEY fieldname = 'KTEXT'.
    IF sy-subrc EQ 0.
      <gfs_fcat>-edit = abap_true.
    ENDIF.

  ENDMETHOD.

  METHOD set_layout.
    gs_layout-zebra      = abap_true.
    gs_layout-cwidth_opt = abap_true.
    gs_layout-col_opt    = abap_true.
    gs_layout-sel_mode   = 'A'.
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

      SET HANDLER go_local->handle_data_changed FOR go_alv_grid.

      CALL METHOD go_alv_grid->set_table_for_first_display
        EXPORTING
          is_layout       = gs_layout   " Layout
        CHANGING
          it_outtab       = gt_alv " Output Table
          it_fieldcatalog = gt_fcat.  " Field Catalog

      CALL METHOD go_alv_grid->register_edit_event
        EXPORTING
          i_event_id = cl_gui_alv_grid=>mc_evt_modified.  " Event ID

    ELSE.
      CALL METHOD go_alv_grid->refresh_table_display.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
