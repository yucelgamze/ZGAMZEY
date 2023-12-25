*&---------------------------------------------------------------------*
*& Include          ZGY_EKKO_LCL
*&---------------------------------------------------------------------*
CLASS lcl_class DEFINITION.
  PUBLIC SECTION.
    METHODS:
      get_data,
      save_data,
      check,
      call_screen,
      pbo_0100,
      pai_0100 IMPORTING iv_ucomm TYPE sy-ucomm,
      set_fcat,
      set_layout,
      display_alv.
ENDCLASS.
CLASS lcl_class IMPLEMENTATION.

  METHOD get_data.
    SELECT
    ekko~ebeln,
    ekko~bukrs,
    ekko~bstyp,
    ekko~bsart,
    ekko~loekz,
    ekko~statu,
    ekko~aedat,
    ekko~ernam,
    ekko~lifnr,
    ekko~spras,
    ekko~zterm,
    ekko~ekorg,
    ekko~ekgrp,
    ekko~waers
    FROM ekko
      WHERE ekko~bukrs IN @so_bukrs AND
            ekko~bstyp IN @so_bstyp AND
            ekko~bsart IN @so_bsart
    INTO CORRESPONDING FIELDS OF TABLE @gt_alv.
  ENDMETHOD.

  METHOD save_data.

    DATA:ls_ekko TYPE zgy_t_ekko.
    DATA:lt_index_row TYPE lvc_t_row.

    CALL METHOD go_alv_grid->get_selected_rows
      IMPORTING
        et_index_rows = lt_index_row.   " Indexes of Selected Rows

    IF lt_index_row IS INITIAL.
      MESSAGE |Lütfen KAYDETME işlemi için bir satır veri seçin!| TYPE 'I' DISPLAY LIKE 'W'.
    ELSE.
      LOOP AT lt_index_row ASSIGNING FIELD-SYMBOL(<gfs_index_row>).

*        READ TABLE gt_alv INTO gs_alv INDEX <gfs_index_row>-index.
        READ TABLE gt_alv ASSIGNING FIELD-SYMBOL(<gfs_alv>) INDEX <gfs_index_row>-index.

      ENDLOOP.

      MOVE-CORRESPONDING <gfs_alv> TO ls_ekko .
      MODIFY zgy_t_ekko FROM ls_ekko.

      IF sy-subrc EQ 0.
        COMMIT WORK.
        MESSAGE |KAYDETME işlemi başarılı bir şekilde gerçekleştirildi!| TYPE 'I' DISPLAY LIKE 'S'.
        <gfs_alv>-line_color = 'C510'.
        CALL METHOD go_alv_grid->refresh_table_display.
      ELSE.
        ROLLBACK WORK.
        MESSAGE |HATA!| TYPE 'I' DISPLAY LIKE 'W'.
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD check.

    SELECT
      ebeln
      FROM zgy_t_ekko
      INTO TABLE @DATA(lt_ekko).

    LOOP AT lt_ekko ASSIGNING FIELD-SYMBOL(<gfs_ekko>).
      READ TABLE gt_alv  ASSIGNING FIELD-SYMBOL(<gfs_alv2>) WITH KEY ebeln = <gfs_ekko>-ebeln.
      <gfs_alv2>-line_color = 'C510'.
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
        i_structure_name = 'ZGY_t_EKKO'
      CHANGING
        ct_fieldcat      = gt_fcat.

  ENDMETHOD.

  METHOD set_layout.
*    gs_layout-zebra      = abap_true.
    gs_layout-cwidth_opt = abap_true.
    gs_layout-col_opt    = abap_true.
    gs_layout-sel_mode   = 'A'.
    gs_layout-info_fname = 'LINE_COLOR'.
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
          it_fieldcatalog = gt_fcat.  " Field Catalog

    ELSE.
*      CALL METHOD go_alv_grid->refresh_table_display.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
