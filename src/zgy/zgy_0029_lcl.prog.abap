*&---------------------------------------------------------------------*
*& Include          ZGY_0029_LCL
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
      select,
      insert,
      update,
      delete.
ENDCLASS.
CLASS lcl_class IMPLEMENTATION.
  METHOD get_data.
    SELECT
    t1~ogrenci_id,
    t1~ogrenci_ad,
    t1~ogrenci_soyad,
    t2~ders_ad,
    t2~ders_kredi,
    t1~puan
    FROM zgy_t_0016 AS t1
    LEFT JOIN zders_detay AS t2 ON t1~ders_id EQ t2~ders_id
    INTO CORRESPONDING FIELDS OF TABLE @gt_alv.
  ENDMETHOD.
  METHOD call_screen.
    CALL SCREEN 0100.
  ENDMETHOD.
  METHOD pbo_0100.
    SET PF-STATUS '0100'.
    SET TITLEBAR '0100'.

    LOOP AT SCREEN.
      CASE abap_true.
        WHEN p_select.
          IF screen-group1 EQ 'X'.
            screen-active = 0.
            MODIFY SCREEN.
          ENDIF.
        WHEN p_insert.
          IF screen-group2 EQ 'X'.
            screen-active = 0.
            MODIFY SCREEN.
          ENDIF.
        WHEN p_update.
          IF screen-group3 EQ 'X'.
            screen-active = 0.
            MODIFY SCREEN.
          ENDIF.
        WHEN p_delete.
          IF screen-group4 EQ 'X'.
            screen-active = 0.
            MODIFY SCREEN.
          ENDIF.
      ENDCASE.
    ENDLOOP.
  ENDMETHOD.
  METHOD pai_0100.
    CASE iv_ucomm.
      WHEN '&BACK'.
        SET SCREEN 0.
      WHEN '&OP'.
        CASE abap_true.
          WHEN p_select.
            go_local->select( ).
            go_alv_grid->refresh_table_display( ).
          WHEN p_insert.
            go_local->insert( ).
            go_local->get_data( ).
            go_alv_grid->refresh_table_display( ).
          WHEN p_update.
            go_local->update( ).
            go_local->get_data( ).
            go_alv_grid->refresh_table_display( ).
          WHEN p_delete.
            go_local->delete( ).
            go_local->get_data( ).
            go_alv_grid->refresh_table_display( ).
        ENDCASE.
    ENDCASE.
  ENDMETHOD.
  METHOD set_fcat.
    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name = 'ZGY_S_0019'
      CHANGING
        ct_fieldcat      = gt_fcat.

  ENDMETHOD.
  METHOD set_layout.
    gs_layout-zebra      = abap_true.
    gs_layout-col_opt    = abap_true.
    gs_layout-cwidth_opt = abap_true.
    gs_layout-sel_mode   = 'A'.
  ENDMETHOD.
  METHOD display_alv.
    IF go_alv_grid IS INITIAL.
      CREATE OBJECT go_container
        EXPORTING
          container_name = 'CC_ALV'.   " Name of the Screen CustCtrl Name to Link Container To
      CREATE OBJECT go_alv_grid
        EXPORTING
          i_parent = go_container.  " Parent Container
      CALL METHOD go_alv_grid->set_table_for_first_display
        EXPORTING
          is_layout       = gs_layout   " Layout
        CHANGING
          it_outtab       = gt_alv   " Output Table
          it_fieldcatalog = gt_fcat.    " Field Catalog
    ELSE.
      CALL METHOD go_alv_grid->refresh_table_display.
    ENDIF.
  ENDMETHOD.
  METHOD select.
    SELECT
    t1~ogrenci_id,
    t1~ogrenci_ad,
    t1~ogrenci_soyad,
    t2~ders_ad,
    t2~ders_kredi,
    t1~puan
    FROM zgy_t_0016 AS t1
    LEFT JOIN zders_detay AS t2 ON t1~ders_id EQ t2~ders_id
    WHERE t1~puan GT @gv_puan
    INTO CORRESPONDING FIELDS OF TABLE @gt_alv.
  ENDMETHOD.
  METHOD insert.
    IF gv_ogr_id    IS NOT INITIAL AND
       gv_ogr_ad    IS NOT INITIAL AND
       gv_ogr_soyad IS NOT INITIAL AND
       gv_ders_id   IS NOT INITIAL AND
       gv_puan      IS NOT INITIAL.

      DATA:ls_0016 TYPE zgy_t_0016.

      ls_0016 = VALUE #( ogrenci_id    = gv_ogr_id
                         ogrenci_ad    = gv_ogr_ad
                         ogrenci_soyad = gv_ogr_soyad
                         ders_id       = gv_ders_id
                         puan          = gv_puan ).

      INSERT zgy_t_0016 FROM ls_0016.

      IF sy-subrc EQ 0.
        COMMIT WORK.
        MESSAGE |Kayıt işlemi başarılı!| TYPE 'I' DISPLAY LIKE 'S'.
      ENDIF.
    ELSE.
      ROLLBACK WORK.
      MESSAGE |Tüm alanlar dolu olmak zorunda!| TYPE 'I' DISPLAY LIKE 'W'.
    ENDIF.
  ENDMETHOD.
  METHOD update.
    IF  gv_ogr_id    IS NOT INITIAL AND
        gv_ogr_ad    IS NOT INITIAL AND
        gv_ogr_soyad IS NOT INITIAL.

      UPDATE zgy_t_0016 SET ogrenci_id    = gv_ogr_id
                            ogrenci_ad    = gv_ogr_ad
                            ogrenci_soyad = gv_ogr_soyad WHERE ogrenci_id EQ gv_ogr_id.
      IF sy-subrc IS INITIAL.
        COMMIT WORK.
        MESSAGE |İlgili veriler güncellenmiştir!| TYPE 'I' DISPLAY LIKE 'S'.
      ELSE.
        ROLLBACK WORK.
        MESSAGE |İlgili veriler güncellenememiştir!| TYPE 'I' DISPLAY LIKE 'E'.
      ENDIF.
    ELSE.
      MESSAGE |Tüm alanlar dolu olmak zorunda!| TYPE 'I' DISPLAY LIKE 'W'.
    ENDIF.
  ENDMETHOD.
  METHOD delete.
    IF gv_ogr_id IS NOT INITIAL.

      DELETE FROM zgy_t_0016 WHERE ogrenci_id EQ gv_ogr_id.

      IF sy-subrc IS INITIAL.
        COMMIT WORK.
        MESSAGE |Başarıl ıbir şekilde silinmiştir!| TYPE 'I' DISPLAY LIKE 'S'.
      ELSE.
        ROLLBACK WORK.
        MESSAGE |Silme işlemi sırasında hata!| TYPE 'I' DISPLAY LIKE 'S'.
      ENDIF.
    ELSE.
      MESSAGE |Öğrenci ID alanını doldurmadan işlem yapamazsınız!| TYPE 'I' DISPLAY LIKE 'E'.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
