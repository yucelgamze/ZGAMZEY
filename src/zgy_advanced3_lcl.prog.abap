*&---------------------------------------------------------------------*
*& Include          ZGAMZEY_ADVANCED3_LCL
*&---------------------------------------------------------------------*
CLASS lcl_class DEFINITION.
  PUBLIC SECTION.
    METHODS:
      save_data,
      make_non_editable,
      get_data_2,
      call_screen,
      call_screen_2,
      pbo_0100,
      pai_0100 IMPORTING iv_ucomm TYPE sy-ucomm,
      pbo_0200,
      pai_0200 IMPORTING iv_ucomm TYPE sy-ucomm,
      set_fcat,
      set_fcat_2,
      set_layout,
      set_layout_2,
      display_alv,
      display_alv_2,
      call_func_title IMPORTING iv_title_id TYPE  zpers_title_id
                      EXPORTING ev_found    TYPE  char1,
      call_func_dep   IMPORTING iv_departman_id TYPE  zpers_departman_id
                      EXPORTING ev_found        TYPE  char1.
ENDCLASS.
CLASS lcl_class IMPLEMENTATION.
  METHOD call_func_title.
    CALL FUNCTION 'ZGY_TITLE'
      EXPORTING
        iv_title_id = iv_title_id
      IMPORTING
        ev_found    = ev_found.

  ENDMETHOD.
  METHOD call_func_dep.
    CALL FUNCTION 'ZGY_DEP'
      EXPORTING
        iv_departman_id = iv_departman_id
      IMPORTING
        ev_found        = ev_found.

  ENDMETHOD.
  METHOD save_data.
    LOOP AT gt_alvedit ASSIGNING FIELD-SYMBOL(<fs>).
      IF <fs>-personel_id IS NOT INITIAL AND
         <fs>-personel_ad IS NOT INITIAL AND
         <fs>-personel_soyad IS NOT INITIAL AND
         <fs>-personel_departman_id IS NOT INITIAL AND
         <fs>-personel_title_id IS NOT INITIAL AND
         <fs>-toplam_tecrube IS NOT INITIAL AND
         <fs>-line_color NE 'C510'.

        go_local->call_func_title(
          EXPORTING
            iv_title_id = <fs>-personel_title_id
          IMPORTING
            ev_found    = gv_found_t
        ).
        go_local->call_func_dep(
          EXPORTING
            iv_departman_id = <fs>-personel_departman_id
          IMPORTING
            ev_found        = gv_found_d
        ).

        IF gv_found_t EQ 'X' AND gv_found_d EQ 'X'.
          DATA:ls_editp TYPE zper_t.
          ls_editp-personel_id           = gs_alvedit-personel_id.
          ls_editp-personel_ad           = gs_alvedit-personel_ad.
          ls_editp-personel_soyad        = gs_alvedit-personel_soyad.
          ls_editp-personel_departman_id = gs_alvedit-personel_departman_id.
          ls_editp-personel_title_id     = gs_alvedit-personel_title_id.
          ls_editp-toplam_tecrube        = gs_alvedit-toplam_tecrube.

          INSERT zper_t FROM ls_editp.
          <fs>-line_color = 'C510'.
          go_local->make_non_editable( ).
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD make_non_editable.
    DATA:ls_stylerow TYPE  lvc_s_styl,
         lt_stylerow TYPE TABLE OF lvc_s_styl.

*    DATA:lt_index_rows TYPE lvc_t_row,
*         lt_row_no     TYPE lvc_t_roid,
*         ls_row_no     TYPE lvc_s_roid.
*
*    CALL METHOD go_alv_grid->get_selected_rows
*      IMPORTING
*        et_index_rows = lt_index_rows   " Indexes of Selected Rows
*        et_row_no     = lt_row_no.  " Numeric IDs of Selected Rows

*    IF lt_row_no IS INITIAL.

    LOOP AT gt_alvedit ASSIGNING FIELD-SYMBOL(<fs>).

*        READ TABLE lt_row_no INTO ls_row_no WITH KEY row_id = sy-tabix. "(index ya da numarası)

*        IF sy-subrc = 0.
      ls_stylerow-style     = cl_gui_alv_grid=>mc_style_disabled.
      ls_stylerow-fieldname = 'PERSONEL_ID'.
      INSERT ls_stylerow INTO TABLE lt_stylerow.

      ls_stylerow-style     = cl_gui_alv_grid=>mc_style_disabled.
      ls_stylerow-fieldname = 'PERSONEL_AD'.
      INSERT ls_stylerow INTO TABLE lt_stylerow.

      ls_stylerow-style     = cl_gui_alv_grid=>mc_style_disabled.
      ls_stylerow-fieldname = 'PERSONEL_SOYAD'.
      INSERT ls_stylerow INTO TABLE lt_stylerow.

      ls_stylerow-style     = cl_gui_alv_grid=>mc_style_disabled.
      ls_stylerow-fieldname = 'PERSONEL_DEPARTMAN_ID'.
      INSERT ls_stylerow INTO TABLE lt_stylerow.

      ls_stylerow-style     = cl_gui_alv_grid=>mc_style_disabled.
      ls_stylerow-fieldname = 'PERSONEL_TITLE_ID'.
      INSERT ls_stylerow INTO TABLE lt_stylerow.

      ls_stylerow-style     = cl_gui_alv_grid=>mc_style_disabled.
      ls_stylerow-fieldname = 'TOPLAM_TECRUBE'.
      INSERT ls_stylerow INTO TABLE lt_stylerow.

      CLEAR:<fs>-celltab.
      INSERT LINES OF lt_stylerow INTO TABLE <fs>-celltab.
*          CLEAR:lt_stylerow.
*        ENDIF.
    ENDLOOP.
*    ENDIF.
  ENDMETHOD.

  METHOD get_data_2.
    IF so_ad     IS NOT INITIAL OR
       so_soyad  IS NOT INITIAL OR
       so_dep    IS NOT INITIAL OR
       so_title  IS NOT INITIAL.
      SELECT
      db_t1~personel_id,
      db_t1~personel_ad,
      db_t1~personel_soyad,
      db_t2~departman_ad,
      db_t3~title_ad,
      db_t1~toplam_tecrube,
      db_t3~maas_katsayi
      FROM zper_t AS db_t1
      LEFT JOIN zdep_t AS db_t2
      ON db_t1~personel_departman_id EQ db_t2~departman_id
      LEFT JOIN ztitle_t AS db_t3
      ON db_t1~personel_title_id EQ db_t3~title_id
      WHERE db_t1~personel_ad    IN @so_ad    OR
            db_t1~personel_soyad IN @so_soyad OR
            db_t2~departman_ad   IN @so_dep   OR
            db_t3~title_ad       IN @so_title
      INTO TABLE @DATA(lt_alvlist). "yeni kolonlar geleceği için gloal itab (alv ye basılan) değil
    ENDIF.
    LOOP AT lt_alvlist ASSIGNING FIELD-SYMBOL(<fs>). "fs de database'den gelen kolonlar var
      CLEAR:gs_alvlist.
      gs_alvlist-personel_id           = <fs>-personel_id.
      gs_alvlist-personel_ad           = <fs>-personel_ad.
      gs_alvlist-personel_soyad        = <fs>-personel_soyad.
      gs_alvlist-personel_departman_ad = <fs>-departman_ad.
      gs_alvlist-personel_title_ad     = <fs>-title_ad.
      gs_alvlist-toplam_tecrube        = <fs>-toplam_tecrube.
      gs_alvlist-maas                  = <fs>-toplam_tecrube * <fs>-maas_katsayi * 2000.

      IF <fs>-toplam_tecrube LE 1.
        gs_alvlist-yillik_izin = 'YILLIK İZİN YOK'.
      ELSEIF  <fs>-toplam_tecrube BETWEEN 1 AND 3.
        gs_alvlist-yillik_izin = '1 HAFTA İZİN'.
      ELSEIF <fs>-toplam_tecrube BETWEEN 3 AND 5.
        gs_alvlist-yillik_izin = '2 HAFTA İZİN'.
      ELSEIF <fs>-toplam_tecrube BETWEEN 5 AND 10.
        gs_alvlist-yillik_izin = '3 HAFTA İZİN'.
      ELSEIF <fs>-toplam_tecrube GT 10.
        gs_alvlist-yillik_izin = '1 AY'.
      ENDIF.

      INSERT gs_alvlist INTO TABLE gt_alvlist.

    ENDLOOP.
  ENDMETHOD.

  METHOD call_screen.
    CALL SCREEN 100.
  ENDMETHOD.

  METHOD call_screen_2.
    CALL SCREEN 0200.
  ENDMETHOD.

  METHOD pbo_0100.
    SET PF-STATUS '0100'.
    SET TITLEBAR '0100'.
  ENDMETHOD.

  METHOD pbo_0200.
    SET PF-STATUS '0200'.
    SET TITLEBAR '0200'.
  ENDMETHOD.

  METHOD pai_0100.
    CASE iv_ucomm.
      WHEN '&BACK'.
        SET SCREEN 0.
      WHEN '&SAVE'.
        go_local->save_data( ).
    ENDCASE.
  ENDMETHOD.

  METHOD pai_0200.
    CASE iv_ucomm.
      WHEN '&BACK'.
        SET SCREEN 0.
    ENDCASE.
  ENDMETHOD.

  METHOD set_fcat.
    CLEAR gs_fcat.
    gs_fcat-ref_table = 'ZPER_T'.
    gs_fcat-ref_field = 'PERSONEL_ID'.
    gs_fcat-fieldname = 'PERSONEL_ID'.
    APPEND gs_fcat TO gt_fcat.

    CLEAR gs_fcat.
    gs_fcat-ref_table = 'ZPER_T'.
    gs_fcat-ref_field = 'PERSONEL_AD'.
    gs_fcat-fieldname = 'PERSONEL_AD'.
    APPEND gs_fcat TO gt_fcat.

    CLEAR gs_fcat.
    gs_fcat-ref_table = 'ZPER_T'.
    gs_fcat-ref_field = 'PERSONEL_SOYAD'.
    gs_fcat-fieldname = 'PERSONEL_SOYAD'.
    APPEND gs_fcat TO gt_fcat.

    CLEAR gs_fcat.
    gs_fcat-ref_table = 'ZDEP_T'.
    gs_fcat-ref_field = 'DEPARTMAN_ID'.
    gs_fcat-fieldname = 'PERSONEL_DEPARTMAN_ID'.
    APPEND gs_fcat TO gt_fcat.

    CLEAR gs_fcat.
    gs_fcat-ref_table = 'ZTITLE_T'.
    gs_fcat-ref_field = 'TITLE_ID'.
    gs_fcat-fieldname = 'PERSONEL_TITLE_ID'.
    APPEND gs_fcat TO gt_fcat.

    CLEAR gs_fcat.
    gs_fcat-ref_table = 'ZPER_T'.
    gs_fcat-ref_field = 'TOPLAM_TECRUBE'.
    gs_fcat-fieldname = 'TOPLAM_TECRUBE'.
    APPEND gs_fcat TO gt_fcat.

  ENDMETHOD.

  METHOD set_fcat_2.
    CLEAR:gs_fcat_2.
    gs_fcat_2-ref_table = 'ZPER_T'.
    gs_fcat_2-ref_field = 'PERSONEL_ID'.
    gs_fcat_2-fieldname = 'PERSONEL_ID'.
    APPEND gs_fcat_2 TO gt_fcat_2.

    CLEAR:gs_fcat_2.
    gs_fcat_2-ref_table = 'ZPER_T'.
    gs_fcat_2-ref_field = 'PERSONEL_AD'.
    gs_fcat_2-fieldname = 'PERSONEL_AD'.
    APPEND gs_fcat_2 TO gt_fcat_2.

    CLEAR:gs_fcat_2.
    gs_fcat_2-ref_table = 'ZPER_T'.
    gs_fcat_2-ref_field = 'PERSONEL_SOYAD'.
    gs_fcat_2-fieldname = 'PERSONEL_SOYAD'.
    APPEND gs_fcat_2 TO gt_fcat_2.

    CLEAR:gs_fcat_2.
    gs_fcat_2-ref_table = 'ZDEP_T'.
    gs_fcat_2-ref_field = 'DEPARTMAN_AD'.
    gs_fcat_2-fieldname = 'PERSONAL_DEPARTMAN_AD'.
    APPEND gs_fcat_2 TO gt_fcat_2.

    CLEAR:gs_fcat_2.
    gs_fcat_2-ref_table = 'ZTITLE_T'.
    gs_fcat_2-ref_field = 'TITLE_AD'.
    gs_fcat_2-fieldname = 'PERSONEL_TITLE_AD'.
    APPEND gs_fcat_2 TO gt_fcat_2.

    CLEAR:gs_fcat_2.
    gs_fcat_2-ref_table = 'ZPER_T'.
    gs_fcat_2-ref_field = 'TOPLAM_TECRUBE'.
    gs_fcat_2-fieldname = 'TOPLAM_TECRUBE'.
    APPEND gs_fcat_2 TO gt_fcat_2.

    CLEAR:gs_fcat_2.
    gs_fcat_2-scrtext_l = 'MAAŞ'.
    gs_fcat_2-scrtext_m = 'MAAŞ'.
    gs_fcat_2-scrtext_s = 'MAAŞ'.
    gs_fcat_2-seltext   = 'MAAŞ'.
    gs_fcat_2-reptext   = 'MAAŞ'.
    gs_fcat_2-fieldname = 'MAAS'.
    gs_fcat_2-datatype  = 'INT4'.
    APPEND gs_fcat_2 TO gt_fcat_2.

    CLEAR:gs_fcat_2.
    gs_fcat_2-fieldname = 'YILLIK_IZIN'.
    gs_fcat_2-scrtext_l = 'YILLIK_IZIN'.
    gs_fcat_2-scrtext_l = 'YILLIK_IZIN'.
    gs_fcat_2-scrtext_l = 'YILLIK_IZIN'.
    gs_fcat_2-seltext   = 'YILLIK_IZIN'.
    gs_fcat_2-reptext   = 'YILLIK_IZIN'.
    gs_fcat_2-datatype  = 'CHAR15'.
    APPEND gs_fcat_2 TO gt_fcat_2.
  ENDMETHOD.

  METHOD set_layout. "tüm alv kolonlarında
    gs_layout-zebra      = abap_true.
    gs_layout-cwidth_opt = abap_true.
    gs_layout-col_opt    = abap_true.
    gs_layout-edit       = abap_true.
    gs_layout-info_fname = 'LINE_COLOR'.
    gs_layout-stylefname = 'CELLTAB'.
  ENDMETHOD.

  METHOD set_layout_2.
    gs_layout_2-zebra = abap_true.
    gs_layout_2-cwidth_opt = abap_true.
    gs_layout_2-col_opt = abap_true.
  ENDMETHOD.

  METHOD display_alv.
    IF go_alv_grid IS INITIAL.
      CREATE OBJECT go_container
        EXPORTING
          container_name = 'CC_ALV_EDIT'.
      CREATE OBJECT go_alv_grid
        EXPORTING
*         i_parent = cl_gui_container=>screen0.
          i_parent = go_container.   " Parent Container

      CALL METHOD go_alv_grid->set_table_for_first_display
        EXPORTING
          is_layout       = gs_layout   " Layout
        CHANGING
          it_outtab       = gt_alvedit " Output Table
          it_fieldcatalog = gt_fcat.  " Field Catalog

      CALL METHOD go_alv_grid->register_edit_event
        EXPORTING
          i_event_id = cl_gui_alv_grid=>mc_evt_enter.

    ELSE.
      CALL METHOD go_alv_grid->refresh_table_display.
    ENDIF.
  ENDMETHOD.

  METHOD display_alv_2.
    IF go_alv_grid_2 IS INITIAL.
      CREATE OBJECT go_container_2
        EXPORTING
          container_name = 'CC_ALV_LIST'.
      CREATE OBJECT go_alv_grid_2
        EXPORTING
*         i_parent = cl_gui_container=>screen0.
          i_parent = go_container_2.   " Parent Container
      CALL METHOD go_alv_grid_2->set_table_for_first_display
        EXPORTING
          is_layout       = gs_layout_2   " Layout
        CHANGING
          it_outtab       = gt_alvlist " Output Table
          it_fieldcatalog = gt_fcat_2.  " Field Catalog
    ELSE.
      CALL METHOD go_alv_grid_2->refresh_table_display.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
