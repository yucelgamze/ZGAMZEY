*&---------------------------------------------------------------------*
*& Include          ZGAMZEY_STUDY1_LCL
*&---------------------------------------------------------------------*
CLASS lcl_class DEFINITION.
  PUBLIC SECTION.
    METHODS:
      get_data,
      check1,
      check2,
      save_data,
      random,
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
      db_t~tc,
      db_t~ad,
      db_t~soyad,
      db_t~aciklama
      FROM zgy_per_t AS db_t
      INTO CORRESPONDING FIELDS OF TABLE @gt_alv.
  ENDMETHOD.
  METHOD   check1.
    SELECT SINGLE tc
      FROM zgy_per_t
      WHERE tc EQ @p_tc
      INTO @DATA(lv_check).

    IF sy-subrc EQ 0.
      gv_found = abap_true.
      MESSAGE |TC alanı key alanıdır girilen TC ile yeni kayıt yapılamaz!| TYPE 'I' DISPLAY LIKE 'W'.
    ELSE.
      gv_found = abap_false.
      MESSAGE |Yeni TC! Kayıt için uygundur!| TYPE 'I' DISPLAY LIKE 'S'.
    ENDIF.
  ENDMETHOD.
  METHOD check2.
    SELECT
    db_t~tc,
    db_t~ad,
    db_t~soyad,
    db_t~aciklama
    FROM zgy_per_t AS db_t
    WHERE tc    EQ @p_tc    AND
          ad    EQ @p_ad    AND
          soyad EQ @p_soyad
    INTO  TABLE @DATA(lt_check2).
    IF sy-subrc EQ 0.
      gv_found2 = abap_true.
      MESSAGE |Girilen TC-AD-SOYAD kombinasyonu tabloda halihazırda mevcut| TYPE 'I' DISPLAY LIKE 'W'.
    ELSE.
      gv_found2 = abap_false.
      MESSAGE |Girilen kombinasyon kaydedilebilir!| TYPE 'I' DISPLAY LIKE 'S'.
    ENDIF.

  ENDMETHOD.

  METHOD save_data.

    go_local->check1( ).
    go_local->check2( ).
    IF gv_found EQ abap_false AND gv_found2 EQ abap_false .
      DATA:ls_alv TYPE zgy_per_t.
      ls_alv-tc       = p_tc.
      ls_alv-ad       = p_ad.
      ls_alv-soyad    = p_soyad.
      ls_alv-aciklama = p_acikla.
      INSERT zgy_per_t FROM ls_alv.
    ELSE.
      MESSAGE |Kayıt sırasında hata!!| TYPE 'I' DISPLAY LIKE 'W'.
    ENDIF.
  ENDMETHOD.

  METHOD random.
    DATA:lv_lines  TYPE int4,
         lv_random TYPE int4,
         lt_alv    TYPE TABLE OF zgy_per_t,
         ls_alv    TYPE zgy_per_t.

    DESCRIBE TABLE gt_alv LINES lv_lines.

    IF p_winner LE lv_lines.

      DO p_winner TIMES.
        CALL FUNCTION 'QF05_RANDOM_INTEGER'
          EXPORTING
            ran_int_max   = lv_lines
            ran_int_min   = 1
          IMPORTING
            ran_int       = lv_random
          EXCEPTIONS
            invalid_input = 1
            OTHERS        = 2.

*        READ TABLE gt_alv ASSIGNING FIELD-SYMBOL(<gfs_alv>) INDEX lv_random.
        READ TABLE gt_alv INTO DATA(gs_alv) INDEX lv_random.
        IF sy-subrc EQ 0.
          DELETE TABLE gt_alv FROM gs_alv.
          APPEND gs_alv TO lt_alv.
          lv_lines = lv_lines - 1.

          ls_alv-aciklama = gs_alv-aciklama.
          INSERT zgy_per_t FROM ls_alv.
        ENDIF.
      ENDDO.
    ENDIF.
    gt_alv = lt_alv.

***    ls_alv-aciklama = <gfs_alv>-aciklama.   !!!!!! dump verdi
***    INSERT zgy_per_t FROM ls_alv.

    gv_flag2 = abap_true.

    go_local->call_screen( ).

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
        UPDATE zgy_per_t FROM TABLE gt_alv.
        go_local->get_data( ).
        CALL METHOD go_alv_grid->refresh_table_display.
    ENDCASE.
  ENDMETHOD.

  METHOD set_fcat.
    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name = 'ZGY_PER_T'
      CHANGING
        ct_fieldcat      = gt_fcat.

    IF  gv_flag2 EQ abap_true.
      READ TABLE gt_fcat ASSIGNING FIELD-SYMBOL(<gfs_fcat>) WITH KEY fieldname = 'ACIKLAMA'.
      IF sy-subrc EQ 0.
        <gfs_fcat>-edit = abap_true.
      ENDIF.
    ENDIF.

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
          it_outtab       = gt_alv " Output Table
          it_fieldcatalog = gt_fcat.  " Field Catalog

      CALL METHOD go_alv_grid->register_edit_event
        EXPORTING
          i_event_id = cl_gui_alv_grid=>mc_evt_modified.   " Event ID

    ELSE.
      CALL METHOD go_alv_grid->refresh_table_display.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
