*&---------------------------------------------------------------------*
*& Include          ZGY_WORK3_LCL
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
      get_sum.
ENDCLASS.

CLASS lcl_class IMPLEMENTATION.
  METHOD get_data.
    SELECT
      db_t~matnr,
      db_t~maktx,
      db_t~labst,
      db_t~demirbas_mi
      FROM zstok_t AS db_t
      INTO CORRESPONDING FIELDS OF TABLE @gt_alv .

*    "durum kolonuna icon ekler
*    LOOP AT gt_alv ASSIGNING <gfs_alv>.
*      <gfs_alv>-durum = '@7T@'.
*    ENDLOOP.

*    LOOP AT gt_alv ASSIGNING <gfs_alv>.
*      CASE <gfs_alv>-demirbas_mi.
*        WHEN 'D'.
*          <gfs_alv>-line_color = 'C710'.
*          CLEAR:gs_cell_color.
*          gs_cell_color-fname = 'MATNR'.
*          gs_cell_color-color-col = '6'.
*          gs_cell_color-color-int = '0'.
*          gs_cell_color-color-inv = '0'.
*          APPEND gs_cell_color TO <gfs_alv>-cell_color.
*        WHEN 'S'.
*          <gfs_alv>-line_color = 'C510'.
*          CLEAR:gs_cell_color.
*          gs_cell_color-fname = 'MAKTX'.
*          gs_cell_color-color-col = '3'.
*          gs_cell_color-color-int = '1'.
*          gs_cell_color-color-inv = '0'.
*          APPEND gs_cell_color TO <gfs_alv>-cell_color.
*      ENDCASE.
*    ENDLOOP.
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
        go_local->get_sum( ).
    ENDCASE.
  ENDMETHOD.

  METHOD set_fcat.

    CLEAR:gs_fcat.
    gs_fcat-fieldname = 'DURUM'.
    gs_fcat-scrtext_s = 'Durum'.
    gs_fcat-scrtext_m = 'Durum'.
    gs_fcat-scrtext_l = 'Durum'.
    APPEND gs_fcat TO gt_fcat.

    CLEAR:gs_fcat.
    gs_fcat-ref_table = 'ZSTOK_T'.
    gs_fcat-ref_field = 'MATNR'.
    gs_fcat-fieldname = 'MATNR'.
    gs_fcat-scrtext_s = 'Malzeme num'.
    gs_fcat-scrtext_m = 'Malzeme numarası'.
    gs_fcat-scrtext_l = 'Malzeme numarası'.
    APPEND gs_fcat TO gt_fcat.

    CLEAR:gs_fcat.
    gs_fcat-fieldname = 'MAKTX'.
    gs_fcat-scrtext_s = 'M.tanım'.
    gs_fcat-scrtext_m = 'Malzeme Tanımı'.
    gs_fcat-scrtext_l = 'Malzeme Tanımı'.
    APPEND gs_fcat TO gt_fcat.

    CLEAR:gs_fcat.
    gs_fcat-fieldname = 'LABST'.
    gs_fcat-scrtext_s = 'Stok'.
    gs_fcat-scrtext_m = 'Stok Miktarı'.
    gs_fcat-scrtext_l = 'Stok Miktarı'.
    APPEND gs_fcat TO gt_fcat.

    CLEAR:gs_fcat.
    gs_fcat-fieldname = 'DEMIRBAS_MI'.
    gs_fcat-scrtext_s = 'D Ekle'.
    gs_fcat-scrtext_m = 'Demirbaşlara Ekle'.
    gs_fcat-scrtext_l = 'Demirbaşlara Ekle'.
    APPEND gs_fcat TO gt_fcat.

    CLEAR:gs_fcat.
    gs_fcat-fieldname = 'MAAS'.
    gs_fcat-scrtext_s = 'MAAS'.
    gs_fcat-scrtext_m = 'MAAS'.
    gs_fcat-scrtext_l = 'MAAS'.
    gs_fcat-edit      = abap_true.
    APPEND gs_fcat TO gt_fcat.

*    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
*      EXPORTING
**       i_structure_name = 'ZSTOK_T'  DATABASE TABLE
*        i_structure_name = 'ZSTOK_S'   "STRUCTURE DATABASE TABLE
**        YAZAMAZSIN BU GLOBAL TYPE AMA STRUCTURE DB YA DA DB_T OLMALI!!!! YANLIŞ KULLANIM ->>>i_structure_name = 'GTY_LIST'
*      CHANGING
*        ct_fieldcat      = gt_fcat.
*
*    "maas kolonunun edit özelliğini açar
*    READ TABLE gt_fcat ASSIGNING <gfs_fcat> WITH KEY fieldname = 'MAAS'.
*    IF sy-ucomm EQ 0.
*      <gfs_fcat>-edit = abap_true.
*    ENDIF.

  ENDMETHOD.

  METHOD set_layout.
    gs_layout-col_opt    = abap_true.
    gs_layout-cwidth_opt = abap_true.
    gs_layout-zebra      = abap_true.
    gs_layout-info_fname = 'LINE_COLOR'.
    gs_layout-ctab_fname = 'CELL_COLOR'.
  ENDMETHOD.

  METHOD display_alv.
    IF go_alv_grid IS INITIAL.
      CREATE OBJECT go_container
        EXPORTING
          container_name = 'CC_ALV'.
      CREATE OBJECT go_alv_grid
        EXPORTING
          i_parent = go_container.    " Parent Container
      CALL METHOD go_alv_grid->set_table_for_first_display
        EXPORTING
          is_layout       = gs_layout   " Layout
        CHANGING
          it_outtab       = gt_alv  " Output Table
*         it_outtab       = gt_alv[]  " Output Table  "HEADER LINE ILE OLUŞTURULDU
          it_fieldcatalog = gt_fcat. " Field Catalog

*      CALL METHOD go_alv_grid->register_edit_event
*        EXPORTING
*          i_event_id = cl_gui_alv_grid=>mc_evt_modified. " Event ID

      CALL METHOD go_alv_grid->register_edit_event
        EXPORTING
          i_event_id = cl_gui_alv_grid=>mc_evt_modified.
    ELSE.
*      CALL METHOD go_alv_grid->refresh_table_display.
    ENDIF.
  ENDMETHOD.

  METHOD get_sum.

    DATA:lv_sum   TYPE int4,
         lv_lines TYPE int4,
         lv_avr   TYPE int4,
         lv_sum_c TYPE char10..

    LOOP AT gt_alv INTO gs_alv.
      lv_sum = lv_sum + gs_alv-maas.
    ENDLOOP.

    "internal table'dan kaç satır varsa saydı ve lv_lines değişkenine attı
    DESCRIBE TABLE gt_alv LINES lv_lines.

    lv_avr = lv_sum / lv_lines.

    LOOP AT gt_alv ASSIGNING <gfs_alv>.
      IF <gfs_alv>-maas > lv_avr.
        <gfs_alv>-durum = '@0A@'.
      ELSEIF <gfs_alv>-maas LT lv_avr.
        <gfs_alv>-durum = '@08@'.
      ELSE.
        <gfs_alv>-durum = '@09@'.
      ENDIF.
    ENDLOOP.

    lv_sum_c = lv_sum.

    CALL METHOD go_alv_grid->refresh_table_display.
    MESSAGE |Tüm satırların toplamı: | && lv_sum_c TYPE 'I' DISPLAY LIKE 'S'.
*    DATA:lv_sum   TYPE int4,
*         lv_mess  TYPE char200,
*         lv_sum_c TYPE char10.
*
*    LOOP AT gt_alv ASSIGNING <gfs_alv>.
*      lv_sum = lv_sum + <gfs_alv>-maas.
*    ENDLOOP.
*    lv_sum_c = lv_sum.
*
**    CONCATENATE 'Tüm satırların toplamı'
**                 lv_sum_c
**                 INTO lv_mess
**                 SEPARATED BY space.
**    MESSAGE lv_mess TYPE 'I' DISPLAY LIKE 'S'.
*
*    MESSAGE |Tüm satırların toplamı: | && lv_sum_c TYPE 'I' DISPLAY LIKE 'S'.
  ENDMETHOD.
ENDCLASS.
