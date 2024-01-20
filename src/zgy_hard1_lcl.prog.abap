*&---------------------------------------------------------------------*
*& Include          ZGAMZEY_HARD_1_LCL
*&---------------------------------------------------------------------*
CLASS local DEFINITION.
  PUBLIC SECTION.
    METHODS:
      get_data,
      get_data2,
      call_screen,
      pbo_0100,
      pai_0100 IMPORTING iv_ucomm TYPE sy-ucomm,
      set_fieldcat,
      set_layout,
      display_alv,
      save_student,
      update_student,
      delete_student.
ENDCLASS.

CLASS local IMPLEMENTATION.
  METHOD get_data.

    SELECT
      t1~ogrenci_id
      t1~ogrenci_ad
      t1~ogrenci_soyad
      t2~ders_ad
      t2~ders_kredi
      t1~puan
      FROM zgamzey_student AS t1
      LEFT JOIN zders_detay AS t2
      ON t1~ders_id EQ t2~ders_id
      INTO CORRESPONDING FIELDS OF TABLE gt_ogr.

  ENDMETHOD.
  METHOD get_data2.
    SELECT
      t1~ogrenci_id,
      t1~ogrenci_ad,
      t1~ogrenci_soyad,
      t2~ders_ad,
      t2~ders_kredi,
      t1~puan
      FROM zgamzey_student AS t1
      LEFT JOIN zders_detay AS t2
      ON t1~ders_id EQ t2~ders_id
      WHERE puan GE @gv_puan
      INTO CORRESPONDING FIELDS OF TABLE @gt_ogr.

  ENDMETHOD.

  METHOD call_screen.
    CALL SCREEN 0100.
  ENDMETHOD.

  METHOD pbo_0100.
    SET PF-STATUS '0100'.
    SET TITLEBAR '0100'.

    LOOP AT SCREEN.
      IF p_rad1 EQ abap_true. "SELECT
        IF screen-group1 EQ 'X'.
          screen-active = 0.
          MODIFY SCREEN.
        ENDIF.
      ELSEIF p_rad2 EQ abap_true. "INSERT
        IF screen-group2 EQ 'X'.
          screen-active = 0.
          MODIFY SCREEN.
        ENDIF.
      ELSEIF p_rad3 EQ abap_true. "UPDATE
        IF screen-group3 EQ 'X'.
          screen-active = 0.
          MODIFY SCREEN.
        ENDIF.
      ELSEIF p_rad4 EQ abap_true. "DELETE
        IF screen-group4 EQ 'X'.
          screen-active = 0.
          MODIFY SCREEN.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD pai_0100.
    CASE iv_ucomm.
      WHEN '&BACK'.
        SET SCREEN 0.
      WHEN '&OP'.
        IF p_rad1 EQ abap_true. "SELECT
          go_local->get_data2( ).
          CALL METHOD go_alv_grid->refresh_table_display.
        ELSEIF p_rad2 EQ abap_true. "INSERT
          go_local->save_student( ).
          go_local->get_data( ).
          CALL METHOD go_alv_grid->refresh_table_display.
        ELSEIF p_rad3 EQ abap_true. "UPDATE
          go_local->update_student( ).
          go_local->get_data( ).
          CALL METHOD go_alv_grid->refresh_table_display.
        ELSEIF p_rad4 EQ abap_true. "DELETE
          go_local->delete_student( ).
          go_local->get_data( ).
          CALL METHOD go_alv_grid->refresh_table_display.
        ENDIF.

    ENDCASE.
  ENDMETHOD.

  METHOD save_student.
    IF
       gv_ogrenci_id            IS NOT INITIAL
       AND gv_ogrenci_ad        IS NOT INITIAL
       AND gv_ogrenci_soyad     IS NOT INITIAL
       AND gv_ders_id           IS NOT INITIAL
       AND gv_puan              IS NOT INITIAL.

      DATA:ls_student TYPE zgamzey_student.
      ls_student-ogrenci_id = gv_ogrenci_id.
      ls_student-ogrenci_ad = gv_ogrenci_ad.
      ls_student-ogrenci_soyad = gv_ogrenci_soyad.
      ls_student-ders_id = gv_ders_id.
      ls_student-puan = gv_puan.
      INSERT zgamzey_student FROM ls_student.
      IF sy-subrc EQ 0.
        COMMIT WORK.
        MESSAGE 'Kayıt işlemi başarılı!' TYPE 'I' DISPLAY LIKE 'S'.
      ENDIF.
    ELSE.
      ROLLBACK WORK.
      MESSAGE 'Tüm alanlar dolu olmak zorunda' TYPE 'I' DISPLAY LIKE 'W'.
    ENDIF.
  ENDMETHOD.

  METHOD update_student.
    IF
      gv_ogrenci_id            IS NOT INITIAL
      AND gv_ogrenci_ad        IS NOT INITIAL
      AND gv_ogrenci_soyad     IS NOT INITIAL.

      UPDATE zgamzey_student SET
      ogrenci_ad = gv_ogrenci_ad
      ogrenci_soyad = gv_ogrenci_soyad
      WHERE ogrenci_id EQ gv_ogrenci_id.
      IF sy-subrc EQ 0.
        MESSAGE 'İlgili veriler güncellenmiştir!' TYPE 'I' DISPLAY LIKE 'S'.
      ELSE.
        MESSAGE 'İlgili veriler güncellenememiştir!' TYPE 'I' DISPLAY LIKE 'E'.
      ENDIF.
    ELSE.
      ROLLBACK WORK.
      MESSAGE 'Tüm alanlar dolu olmak zorunda' TYPE 'I' DISPLAY LIKE 'W'.
    ENDIF.
  ENDMETHOD.

  METHOD delete_student.
    IF gv_ogrenci_id IS  INITIAL.
      MESSAGE 'Öğrenci ID alanını doldurmadan işlem yapamazsın' TYPE 'I' DISPLAY LIKE 'W'.
    ELSE.

      DELETE FROM zgamzey_student WHERE ogrenci_id EQ gv_ogrenci_id.

      IF sy-subrc EQ 0.
        COMMIT WORK.
        MESSAGE 'Başarılı bir şekilde silinmiştir!' TYPE 'I' DISPLAY LIKE 'S'.
      ELSE.
        ROLLBACK WORK.
        MESSAGE 'Silme sırasında hata!' TYPE 'I' DISPLAY LIKE 'W'.
      ENDIF.

    ENDIF.

  ENDMETHOD.

  METHOD set_fieldcat.
    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name = 'ZOGR_ALV_S'
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
          it_outtab       = gt_ogr " Output Table
          it_fieldcatalog = gt_fieldcat.  " Field Catalog
    ELSE.
      CALL METHOD go_alv_grid->refresh_table_display.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
